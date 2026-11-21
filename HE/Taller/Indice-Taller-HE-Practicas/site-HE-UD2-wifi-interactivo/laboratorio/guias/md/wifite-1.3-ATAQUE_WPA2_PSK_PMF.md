# Guía da práctica Wifite 1.3 — WPA2-PSK con PMF


!!! warning "**LIMITACIÓN DE RESPONSABILIDADE**" 
    O autor do presente documento declina calquera responsabilidade asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa información exposta no mesmo. Este documento foi xerado para uso didáctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.  
    O uso de Wifite ou calquera outra ferramenta de auditoría en redes Wi-Fi sen autorización expresa é **ILEGAL**.

## 1. Resumo

Esta práctica demostra como **PMF (Protected Management Frames, ieee80211w)** protexe determinadas tramas de xestión nas redes WPA2-PSK. Empregaremos **Wifite** para intentar forzar unha reconexión mediante tramas de desautenticación falsificadas e comprobar que, cunha asociación protexida por PMF obrigatorio (`ieee80211w=2`), o cliente non debe desconectarse por esas tramas non protexidas. **Isto non impide capturar pasivamente un handshake que se produza por unha conexión lexítima.**

**Obxectivos de aprendizaxe:**
- Comprender o papel de `ieee80211w` na protección contra ataques de desautenticación
- Verificar que as tramas DeAuth falsificadas non protexidas non desconectan un cliente cunha asociación PMF establecida
- Analizar con `tshark` o bit Protected das tramas de xestión e relacionar as capturas co estado da conexión
- Contrastar coa [práctica de desautenticación WPA2-PSK](1.2-ATAQUE_WPA2_PSK_DEAUTH.md), realizada sen PMF

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
- Wordlist: `/usr/share/wordlists/rockyou.txt.gz`  

**Referencias:**  
- [0] [1-Taller-HE-Practica-WiFi-3.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-3.pdf){:target="_blank"}  
- [1] [IEEE 802.11w-2009 (Protected Management Frames)](https://android.googlesource.com/platform/external/wpa_supplicant_8/+/444d567/wpa_supplicant/wpa_supplicant.conf){:target="_blank"}    
- [2] [hostapd ieee80211w configuration](https://w1.fi/hostapd/){:target="_blank"}  

---

## 3. Escenario e topoloxía

| Rol                  | Interface | Namespace             | Estado tras `wifilabctl up`  |
|----------------------|-----------|-----------------------|------------------------------|
| AP WPA2-PSK + PMF    | `wlan0`   | `wifi_ap_wlan0`       | ✅ Automático                 |
| Cliente PMF          | `wlan1`   | `wifi_cliente_wlan1`  | ✅ Automático                 |
| Atacante (Wifite)    | `wlan2`   | (global)              | ⏳ Interface libre            |
| Monitor (aireplay)   | `wlan3`   | (global)              | ⏳ Interface libre            |

**SSID:** `EMPRESA-XYZ` · **Contrasinal:** `spongebob19` · **Canal:** 6 · **ieee80211w:** 2 (obrigatorio) · **key_mgmt:** `WPA-PSK-SHA256`

```
[wlan1: Cliente PMF]  ----wireless----> [wlan0: AP WPA2-PSK + PMF]
                                               ^
                                               |
                                      [wlan2mon: Wifite]
                                      [wlan3mon: airodump-ng]
                                      (intentos de deauth → FALLAN con PMF)
```

> 💡 `wifilabctl up psk_pmf` levanta **automaticamente** AP e cliente con PMF configurado. As terminais son para observación e ataque, non para configuración manual.

---

## 4. Procedemento

**Resumo de terminais:**

Para seguir a práctica, abre catro terminais na sesión gráfica de Kali. Cada unha ten unha función específica:

| Terminal | Rol                                        |
|----------|--------------------------------------------|
| 1        | Arrancar e xestionar o escenario           |
| 2        | Monitorizar logs do AP en tempo real       |
| 3        | Executar o ataque con Wifite               |
| 4        | Captura e análise de tramas con tshark     |

---

### Terminal 1 — Arrancar o escenario

```bash
# Arrancar o escenario PSK con PMF obrigatorio
sudo wifilabctl up psk_pmf

# Verificar que AP e cliente están activos con PMF
sudo wifilabctl status
```

Saída esperada ao finalizar:
```
[*] Informe de Estado do Laboratorio
============================================================
NAMESPACE                 INTERFACE       IP                   ESTADO
---------------------------------------------------------------------------
wifi_cliente_wlan1        wlan1           -                    UP
wifi_ap_wlan0             wlan0           -                    UP
---------------------------------------------------------------------------
Interfaces GLOBAIS / ATACANTE:
(global)                  wlan2           (host/monitor)       LISTO
(global)                  wlan3           (host/monitor)       LISTO
```

> ⚠️ O escenario configura automaticamente `ieee80211w=2` e `wpa_key_mgmt=WPA-PSK-SHA256` no AP (`hostapd_pmf.conf`) e no cliente (`wpa_pmf.conf`). Non é necesario ningún paso manual.

---

### Terminal 2 — Monitorizar logs do AP (en tempo real)

Abrir **esta terminal antes de lanzar o ataque** para observar os logs do AP lexítimo:

```bash
tail -f /home/kali/wifiLab/run/psk_pmf/hostapd.log
```

Deixar correndo. 

---

### Terminal 3 — Ataque con Wifite

#### Paso 1: Acceder como root e preparar wordlist

```bash
sudo su -
gunzip -kf /usr/share/wordlists/rockyou.txt.gz
```

#### Paso 2: Lanzar Wifite

```bash
wifite --no-wps --dict /usr/share/wordlists/rockyou.txt
```

#### Paso 3: Avisos de procesos en conflito — non matar

Wifite detectará os procesos do escenario (`hostapd`, `wpa_supplicant`) e avisará:

```
 [!] Conflicting processes: NetworkManager (PID 642), wpa_supplicant (PID 1919),
     hostapd (PID 2009), wpa_supplicant (PID 2024)
 [!] If you have problems: kill -9 PID or re-run wifite with --kill
```

> ⚠️ **Non matar eses procesos nin utilizar `--kill`.** Son o AP e o cliente do escenario de laboratorio. Ignorar o aviso e continuar.

#### Paso 4: Seleccionar a interface de ataque

Con `mac80211_hwsim`, Wifite **non selecciona automaticamente** a interface. Lista `wlan2` e `wlan3` e pide escoller:

```
    Interface   PHY   Driver              Chipset
-----------------------------------------------------------------------
 1. wlan2       phy2  ??????              non-mac80211 device? (report this!)
 2. wlan3       phy3  ??????              non-mac80211 device? (report this!)
 [+] Select wireless interface (1-2): 1
```

Introducir `1` para seleccionar `wlan2` e premer Enter.

> 💡 O aviso `non-mac80211 device?` é normal con interfaces virtuais. Non impide o funcionamento.

```
 [+] Enabling monitor mode on wlan2... enabled!
```

#### Paso 5: Escaneo e selección do AP obxectivo

Wifite escaneará en modo monitor. Cando apareza `EMPRESA-XYZ` premer `Ctrl+C`:

```
   NUM                      ESSID   CH  ENCR    PWR    WPS  CLIENT
   ---  -------------------------  ---  -----   ----   ---  ------
     1               EMPRESA-XYZ     6  WPA-P   72db    no
```

```
 [+] Select target(s) (1-1) separated by commas, dashes or all: 1
```

Introducir `1` e premer Enter.

#### Paso 6: Ataque PMKID (primeiro intento automático — fallará)

Wifite pode tentar capturar primeiro un PMKID. Neste escenario a súa obtención non está garantida; consulta a [práctica 1.4 — WPA2-PSK PMKID](1.4-ATAQUE_WPA2_PSK_PMKID.md) para entender as condicións necesarias. Se non aparece, preme `Ctrl+C` para interromper o intento e despois `c` para continuar co seguinte método.

**Exemplo da saída de Wifite durante este paso:**

```
 [+] (1/1) Starting attacks against 06:FE:D8:7D:4F:43 (EMPRESA-XYZ)
 [+] EMPRESA-XYZ (72db) PMKID CAPTURE: Waiting for PMKID (4m47s) ^C
 [!] Interrupted
 [+] 1 attack(s) remain
 [+] Do you want to continue attacking, or exit (c, e)? c
```

#### Paso 7: Intento de forzar un handshake mediante DeAuth — resultado esperado con PMF

Wifite pasa ao ataque de handshake e intenta desautenticar o cliente. 

Abrir un Terminal 4 para análise de tramas con tshark (mentres Wifite intenta o handshake):

```bash
sudo su -

# Capturar tráfico con wlan3 mentres Wifite usa wlan2mon
airodump-ng wlan3 -c 6 -w /tmp/pmf-test
# Esperar ~30 segundos e premer Ctrl+C

# Analizar tramas de desautenticación capturadas
tshark -r /tmp/pmf-test-01.cap -Y "wlan.fc.type_subtype == 0x000c"   -T fields -e frame.number -e wlan.fc.protected -e wlan.sa -e wlan.da
```

**Saída esperada:**
```
# Tramas LEXÍTIMAS do cliente (cifradas con PMF):
# frame  wlan.fc.protected  wlan.sa           wlan.da
# 42     True               <MAC_cliente>     <BSSID_AP>

# Tramas FALSAS do atacante (non cifradas → rexeitadas):
# 43     False              <MAC_atacante>    <BSSID_AP>
```

**Interpretación:**  
- `wlan.fc.protected=True` → Trama cifrada con PMF ✔  
- `wlan.fc.protected=False` → Trama NON cifrada, rexeitada polo AP ✗  


**Exemplo posible de saída de Wifite se non se produce unha reconexión lexítima durante a captura:**  
```
 [+] EMPRESA-XYZ (72db) WPA Handshake capture: Discovered new client: 42:F9:95:B2:CB:34
 [+] EMPRESA-XYZ (72db) WPA Handshake capture: Listening. (clients:1, deauth:7s, timeout:0s)
 [!] WPA handshake capture FAILED: Timed out after 300 seconds
 [+] Finished attacking 1 target(s), exiting
 [!] Note: Leaving interface in Monitor Mode!
 [!] To disable Monitor Mode when finished: airmon-ng stop wlan2mon
```

**A desautenticación falsificada non protexida non debería expulsar o cliente cunha asociación PMF establecida.** Se Wifite non captura un handshake neste intento, iso non implica que PMF impida toda captura de handshakes.

---

!!! warning "**CLAVE**"
    Nunha asociación con PMF negociado, as tramas de desautenticación e desasociación robustas deben estar protexidas. O receptor descarta as falsificadas que chegan sen a protección correspondente; o atacante non dispón das claves para xerar unha trama válida. Isto non significa que *todas* as tramas de xestión estean cifradas nin que PMF impida a captura pasiva de EAPOL.

---

### Terminal 1 — Verificacións finais

```bash
# Verificar que o cliente permanece conectado tras o ataque
sudo ip netns exec wifi_cliente_wlan1 iw dev wlan1 link
# Connected to <BSSID_AP> (on wlan1)
# SSID: EMPRESA-XYZ

# Comprobar se Wifite gardou unha captura; pode existir se houbo unha conexión lexítima
sudo ls -lh /root/hs/
# A presenza dun .cap non proba que fallase PMF: verificar como se produciu a asociación

# Verificar que NON houbo ningunha desconexión no cliente
grep CTRL-EVENT-DISCONNECTED /home/kali/wifiLab/run/psk_pmf/wpa_supplicant.log
# Contrastar cos rexistros e co estado do cliente; unha saída baleira non proba por si soa continuidade
```

---

## 5. Limitacións de Wifite e reflexión didáctica

**Limitación concreta:** Wifite pode intentar provocar unha reconexión con `aireplay-ng --deauth`, pero esa técnica non debería desconectar un cliente que xa negociou PMF obrigatorio.

1. PMF protexe as tramas robustas de desautenticación e desasociación unha vez establecida a asociación protexida.
2. As tramas falsificadas non protexidas son descartadas polo receptor.
3. Se o cliente se asocia lexitimamente durante unha captura, **Wifite aínda pode observar o intercambio EAPOL** e gardar un handshake.

**Conclusión:** PMF limita a desautenticación falsificada utilizada para *forzar* unha reconexión, pero **non impide por si mesmo a captura pasiva dun handshake WPA2-PSK**.

**Reflexión:**  
- PMF **NON protexe o handshake** en si (segue sendo auditable se se captura durante conexión inicial ou reinicio do AP)  
- PMF protexe determinadas tramas robustas de xestión, incluídas desautenticación e desasociación, pero non resolve todos os ataques á rede Wi-Fi  
- A mellor defensa é **contrasinal forte** + **WPA3-SAE** (que elimina os ataques offline ao handshake)

---

## 6. Preguntas de reflexión

1. **Que diferenza hai entre `ieee80211w=0`, `ieee80211w=1` e `ieee80211w=2`?**  

    - `0`: PMF desactivado — vulnerable a desautenticación  
    - `1`: PMF opcional — clientes con e sen PMF poden conectarse  
    - `2`: PMF obrigatorio — só clientes con PMF, todos protexidos

2. **Por que pode fallar a obtención dun handshake mediante desautenticación forzada nesta práctica?**  

    - Wifite intenta provocar unha reconexión mediante tramas DeAuth falsificadas.  
    - Cunha asociación protexida por PMF, o cliente descarta as tramas non protexidas. Isto **non impide** observar un handshake se o cliente se conecta lexitimamente durante a captura.  

3. **PMF protexe o contrasinal WPA2?**  

    - **NON.** PMF só protexe as tramas de xestión. O handshake capturado durante a conexión inicial segue sendo auditable con `aircrack-ng`.

4. **Que tipo de ataques mitiga PMF?**  

    - Desautenticación e desasociación falsificadas dunha asociación protexida; dificulta técnicas de Evil Twin que dependen de forzar a desconexión  

5. **Que alternativas hai se se require seguridade total contra ataques offline ao handshake?**  

    - **WPA3-SAE** (elimina ataques offline ao handshake), **WPA2-EAP** (autenticación centralizada con RADIUS)  

6. **É posible desactivar PMF nunha rede WPA3?**  

    - **NON.** WPA3-SAE require `ieee80211w=2` por especificación.  

---

## 7. Limpeza do laboratorio

**Terminal 1:**

```bash
# Deter e eliminar o escenario completamente
sudo wifilabctl reset

# Verificar que non quedan namespaces
ip netns list
```

**Terminal 3** (se Wifite deixou a interface en modo monitor):

```bash
airmon-ng stop wlan2mon
```
