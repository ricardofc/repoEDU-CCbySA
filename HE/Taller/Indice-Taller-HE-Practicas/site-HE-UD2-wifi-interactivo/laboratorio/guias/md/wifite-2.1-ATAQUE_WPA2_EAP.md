# Guía da práctica Wifite 2.1 — WPA2-Enterprise (EAP)


!!! warning "**LIMITACIÓN DE RESPONSABILIDADE**" 
    O autor do presente documento declina calquera responsabilidade asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa información exposta no mesmo. Este documento foi xerado para uso didáctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.  
    O uso de Wifite ou calquera outra ferramenta de auditoría en redes Wi-Fi sen autorización expresa é **ILEGAL**.

## 1. Resumo

Esta práctica introduce **WPA2-Enterprise (WPA2-EAP)**, unha modalidade de autenticación Wi-Fi baseada en IEEE 802.1X, protocolos EAP e un servidor RADIUS. A diferenza de WPA2-PSK, o acceso non se basea nun único contrasinal compartido por todos os clientes.

O obxectivo é comprobar **o comportamento real de Wifite fronte a unha rede WPA2-Enterprise**: a ferramenta detecta `EMPRESA-XYZ`, clasifícaa como `WPA2-E` e, cando se selecciona, **descarta o obxectivo** porque non incorpora o procedemento de ataque WPA-Enterprise que se estudará con outras ferramentas.

Esta limitación **é de Wifite**, non unha demostración de que WPA2-Enterprise sexa invulnerable. Nas prácticas [2.2 — Evil Twin](2.2-ATAQUE_WPA2_EAP_EVIL_TWIN.md) e [2.3 — MITM](2.3-ATAQUE_WPA2_EAP_MITM.md) estúdanse outros modelos de auditoría EAP/RADIUS.

**Obxectivos de aprendizaxe:**

- Identificar os compoñentes do laboratorio WPA2-Enterprise: AP, cliente e FreeRADIUS.
- Diferenciar a autenticación WPA2-PSK da autenticación IEEE 802.1X/EAP/PEAP.
- Recoñecer o identificador `WPA2-E` na saída de Wifite.
- Comprobar experimentalmente a mensaxe coa que Wifite descarta a rede.
- Comprender por que a captura do *4-way handshake* de WPA2-Enterprise non equivale a unha proba de dicionario WPA2-PSK.

---

## 2. Material necesario

**Hardware/Software:**  
- Host alumnado · Máquina virtual GNU/Linux Kali amd64  
- RAM ≥ 2048 MB · CPU ≥ 2 cores · PAE/NX habilitado  

**Ferramentas** (xa instaladas en Kali):  
`wifite`, `hostapd`, `freeradius`, `wpa_supplicant`, `mac80211_hwsim`, `aircrack-ng`, `tshark`

**Referencias:**  
- [0] [2-Taller-HE-Practica-WiFi-1.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/2-Taller-HE-Practica-WiFi-1.pdf){:target="_blank"}  
- [1] [FreeRADIUS documentation](https://www.freeradius.org/documentation/freeradius-server/3.2.9/tutorials/eap-peap.html){:target="_blank"}  
- [2] [IEEE 802.1X-2010](https://standards.ieee.org/ieee/802.1X/4389/){:target="_blank"}  
- [3] [RFC 4017 - EAP para WLANs](https://www.ietf.org/rfc/rfc4017.txt){:target="_blank"}  

---

## 3. Escenario e topoloxía

Para esta práctica empregamos o escenario **`eap_mitm`**, pero só a súa infraestrutura lexítima: AP corporativo, cliente e servidor RADIUS. **Non arrincaremos MANA nin crearemos `br-mitm`**, porque o obxectivo aquí é examinar o comportamento de Wifite, non executar a práctica MITM.

| Rol | Interface ou ponte | *Namespace* | Enderezo / estado |
|---|---|---|---|
| AP WPA2-Enterprise | `wlan0` e `br0` | `wifi_ap_wlan0` | `br0`: `192.168.50.10/24`; AP activo |
| Servidor FreeRADIUS | `br-radius` | Principal | `192.168.50.1:1812` |
| Cliente PEAP | `wlan1` | `wifi_cliente_wlan1` | IP por DHCP na rede `192.168.50.0/24` |
| Elementos reservados para MITM | `wlan2`, `veth0` | `mitm_wlan2` | Preparados; MANA e `br-mitm` sen activar |
| Wifite / monitorización | `wlan3` (pode pasar a `wlan3mon`) | Principal | Interface dispoñible para Wifite |

**SSID:** `EMPRESA-XYZ` · **Canle:** 6 · **Autenticación:** WPA2-Enterprise/PEAP · **FreeRADIUS:** `192.168.50.1:1812`.

O cliente do escenario utiliza **un certificado de CA configurado** (`ca_cert`), como comprobamos no laboratorio:

```ini
ssid="EMPRESA-XYZ"
eap=PEAP
ca_cert="/etc/freeradius/3.0/certs/ca.pem"
```

Esquema simplificado da rede utilizada nesta práctica:

```text
                    REDE CORPORATIVA WPA2-ENTERPRISE

  Cliente PEAP             AP lexítimo                  FreeRADIUS
  wlan1  ~~~ ondas Wi-Fi ~~~  wlan0 -- br0 -- br-radius -- 192.168.50.1:1812
  wifi_cliente_wlan1        wifi_ap_wlan0                namespace principal

  Kali / Wifite: wlan3 (monitor) -- observación do SSID EMPRESA-XYZ
  MANA / br-mitm: NON se poñen en marcha nesta práctica
```

O **BSSID e a IP do cliente cambian entre execucións**; os valores que aparecen nas saídas seguintes son exemplos reais dunha sesión validada, non datos para copiar literalmente.

---

## 4. Procedemento

Para realizar a práctica, abre **dúas terminais na sesión gráfica de Kali**. A terceira é opcional, para comprobar os rexistros de autenticación do AP.

| Terminal | Función |
|---|---|
| **Terminal 1** | Iniciar o escenario e verificar a asociación do cliente. |
| **Terminal 2** | Executar Wifite, seleccionar `EMPRESA-XYZ` e observar o descarte. |
| **Terminal 3 (opcional)** | Consultar os rexistros EAP/RADIUS do laboratorio. |

### Terminal 1 — Preparar a infraestrutura WPA2-Enterprise

Executa **esta secuencia**, empregando o mesmo inicio de escenario que na práctica 2.3:

```bash
sudo env WIFILAB_ENABLE_NAT=1 wifilabctl up eap_mitm
sudo wifilabctl status
sudo ip netns exec wifi_cliente_wlan1 iw dev wlan1 link
```

Exemplo real do estado despois de iniciar o escenario:

```text
NAMESPACE                 INTERFACE       IP                   ESTADO
---------------------------------------------------------------------------
wifi_cliente_wlan1        wlan1           192.168.50.81/24     UP
mitm_wlan2                wlan2           -                    UP
mitm_wlan2                veth0@if12      -                    UP
wifi_ap_wlan0             br0             192.168.50.10/24     UP
wifi_ap_wlan0             wlan0           -                    UP
wifi_ap_wlan0             veth0@if10      -                    UP
---------------------------------------------------------------------------
Interfaces GLOBAIS / ATACANTE:
(global)                  wlan3           (host/monitor)       LISTO
```

A asociación do cliente debe indicar `SSID: EMPRESA-XYZ`, na canle 6 (`2437 MHz`). Se aparece `Not connected`, agarda uns segundos e repite a comprobación.

Para confirmar que FreeRADIUS está dispoñible e que o cliente valida unha CA:

```bash
sudo ss -lunp | grep ':1812'
sudo grep -E 'ssid=|eap=|ca_cert=' \
  /home/kali/wifiLab/run/eap_mitm/wpa_supplicant.conf
```

**Nesta práctica non executes** `mana-start`, `bridge-mitm` nin `select-mitm`: son operacións da [práctica 2.3](2.3-ATAQUE_WPA2_EAP_MITM.md).

### Terminal 2 — Wifite e descarte automático de WPA2-Enterprise

Abre unha segunda terminal gráfica. Antes de lanzar Wifite, comproba que Rockyou está dispoñible:

```bash
ls -lh /usr/share/wordlists/rockyou.txt*
```

Se só existe `rockyou.txt.gz`, podes descomprimilo:

```bash
sudo gzip -dk /usr/share/wordlists/rockyou.txt.gz
```

Aínda que **Wifite non chegará a utilizar o dicionario contra esta rede Enterprise**, empregamos o mesmo comando que nas prácticas WPA2-PSK para comparar o comportamento:

```bash
sudo wifite --no-wps --dict /usr/share/wordlists/rockyou.txt
```

#### Paso 1 — Procesos en conflito

Wifite pode advertir da presenza de `NetworkManager`, `hostapd`, `wpa_supplicant` ou `dhclient`.

!!! warning "Non deter os servizos do laboratorio"
    Non empregues `--kill` nin `airmon-ng check kill`: poderían deter o AP, o cliente ou os servizos necesarios para esta simulación. Continúa coa interface de monitorización dispoñible.

#### Paso 2 — Interface de monitorización

Wifite debe utilizar a interface libre `wlan3`; pode habilitar o modo monitor e pasar a chamala `wlan3mon`. Se solicita unha selección, escolle a interface correspondente a `wlan3`.

Non é necesario mover `wlan0` nin `wlan1` fóra dos seus *namespaces*.

#### Paso 3 — Recoñecer a rede WPA2-Enterprise

Agarda a que apareza `EMPRESA-XYZ` na canle 6 e preme **Ctrl+C** para terminar o escaneo e seleccionar a rede.

**Saída real obtida na VM Kali:**

```text
NUM                      ESSID   CH  ENCR     PWR   WPS  CLIENT
---  -------------------------  ---  -----    ----  ---  ------
  1               EMPRESA-XYZ     6  WPA2-E    72db    no
[+] Select target(s) (1-1) separated by commas, dashes or all: 1
```

O campo `WPA2-E` identifica **WPA2-Enterprise**, non WPA2-PSK. A intensidade do sinal e o BSSID poden variar.

#### Paso 4 — Comprobar que Wifite descarta o obxectivo

Tras introducir o número da rede, **a saída real da sesión validada** foi:

```text
[+] (1/1) Starting attacks against B6:EE:A1:E0:7A:D4 (EMPRESA-XYZ)

[!]Skipping. Target is using WPA-Enterprise and can not be cracked.
[+] Finished attacking 1 target(s), exiting
```

Esta é a **evidencia principal da práctica**: Wifite identifica WPA2-Enterprise e salta o obxectivo, sen iniciar unha proba de dicionario WPA2-PSK. O BSSID `B6:EE:A1:E0:7A:D4` pertence unicamente ao exemplo amosado.

!!! success "Resultado esperado"
    O alumno debe identificar a rede como `WPA2-E` e obter a mensaxe `Skipping. Target is using WPA-Enterprise and can not be cracked.`. É o comportamento previsto desta versión de Wifite para este escenario.

### Terminal 3 (opcional) — Observar os rexistros EAP

Se queres relacionar a detección coa autenticación Enterprise que mantén operativo o laboratorio, podes consultar os rexistros sen interromper ningún servizo:

```bash
sudo grep -Ei 'EAP|AP-STA|authenticat' \
  /home/kali/wifiLab/run/eap_mitm/hostapd_ok.log | tail -n 20
```

Estes rexistros corresponden á **asociación lexítima do cliente**, non a un ataque realizado por Wifite. Para información adicional de FreeRADIUS, consulta `/var/log/freeradius/radius.log` cando estea dispoñible.

---

## 5. Limitacións de Wifite con WPA2-EAP

**Resultado comprobado:** Wifite detectou `EMPRESA-XYZ` como `WPA2-E`, permitiu seleccionala e respondeu:

```text
[!]Skipping. Target is using WPA-Enterprise and can not be cracked.
```

Isto significa que **Wifite non aplica os ataques automatizados WPA2-PSK (handshake/PMKID e dicionario) a unha rede WPA2-Enterprise**. A comprobación fíxose coa versión instalada na VM Kali deste laboratorio.

Non debemos confundilo con que WPA2-Enterprise sexa intrinsecamente inatacable, nin con que a ferramenta sexa exclusivamente pasiva: **Wifite tamén automatiza técnicas activas** sobre protocolos compatibles, como a desautenticación en escenarios WPA2-PSK sen PMF.

### Por que non serve o mesmo método que en WPA2-PSK?

En WPA2-PSK, o segredo compartido permite calcular candidatos á PMK e contrastalos cun *handshake* capturado. En WPA2-Enterprise, a PMK procede do proceso de autenticación EAP; capturar o intercambio EAPOL de catro mensaxes **non proporciona unha PSK compartida contra a que aplicar Rockyou da mesma forma**.

A seguridade de WPA2-Enterprise tamén depende do método EAP empregado e da correcta validación dos certificados. Por exemplo:

- Un **Evil Twin** cun servidor EAP falso pode resultar perigoso para clientes que non validen adecuadamente a identidade do servidor. Estúdase na [práctica 2.2](2.2-ATAQUE_WPA2_EAP_EVIL_TWIN.md).
- Un AP intermediario pode **reenviar a autenticación cara ao RADIUS lexítimo** e permitir observar tráfico de aplicación non cifrado, tal como se comprobou na [práctica 2.3](2.3-ATAQUE_WPA2_EAP_MITM.md). Iso **non implica romper TLS nin obter as credenciais PEAP**.

Na configuración actual de `eap_mitm`, o cliente **si ten `ca_cert` configurado**. A CA e a comprobación adecuada da identidade do servidor dificultan a suplantación dun servidor EAP, pero non cifran por si mesmas o tráfico HTTP de aplicación unha vez conectado o cliente.

---

## 6. Preguntas de reflexión

1. **Que diferenzas ofrece WPA2-Enterprise respecto de WPA2-PSK?**

    - **Autenticación individual:** os usuarios poden ter credenciais propias.
    - **Xestión centralizada:** un servidor RADIUS pode controlar e rexistrar os accesos.
    - **Revogación:** pódese retirar o acceso a un usuario sen substituír unha PSK compartida.
    - **A seguridade depende da configuración EAP:** débense validar os certificados e empregar métodos axeitados.

2. **Como se obtén a clave de sesión nos dous casos?**

    - **WPA2-PSK:** o contrasinal compartido intervén na derivación da PMK, polo que poden comprobarse candidatos offline a partir dun intercambio apto.
    - **WPA2-Enterprise:** o proceso EAP produce material de claves (MSK) a partir do cal se deriva a PMK. O *4-way handshake* tamén existe, pero non equivale a unha captura de PSK recuperable con Rockyou.

3. **Que observamos cando Wifite selecciona `EMPRESA-XYZ`?**

    - O identificador `WPA2-E` durante o escaneo.
    - A mensaxe `Skipping. Target is using WPA-Enterprise and can not be cracked.`.
    - O descarte do obxectivo sen iniciar o ataque automatizado de dicionario WPA2-PSK.

4. **Que riscos de configuración poden afectar a WPA2-Enterprise?**

    - Falta de validación correcta do certificado e da identidade do servidor EAP.
    - Uso de métodos de autenticación inadecuados ou credenciais febles.
    - Configuración incorrecta de clientes, AP ou servidores RADIUS.
    - Tráfico de aplicación enviado sen protección, por exemplo mediante HTTP.

5. **Que medidas son recomendables?**

    - Configurar e verificar a CA e a identidade do servidor de autenticación.
    - Utilizar métodos robustos, como EAP-TLS cando corresponda.
    - Aplicar boas políticas de credenciais e rexistro de accesos.
    - Protexer tamén o tráfico das aplicacións con HTTPS/TLS.

6. **Que demostra a práctica MITM 2.3 malia que o cliente valida a CA?**

    - Que un AP intermediario pode retransmitir a autenticación cara ao servidor RADIUS lexítimo no laboratorio controlado.
    - Que o cliente pode asociarse e autenticarse a través dese AP.
    - Que se pode observar **HTTP en claro** na ponte do atacante; non se demostrou descifrado de PEAP nin recuperación de credenciais.

---

## 7. Limpeza do laboratorio

Ao rematar, pecha Wifite na **Terminal 2**. Se deixou a interface en modo monitor, restáuraa **antes de reiniciar o escenario**:

```bash
# Executar só se a interface wlan3mon existe
sudo airmon-ng stop wlan3mon
```

Desde a **Terminal 1**, para finalizar o laboratorio:

```bash
sudo wifilabctl reset
ip netns list
```

O escenario non debe quedar con servizos de AP ou cliente activos cando se prepare outra práctica.
