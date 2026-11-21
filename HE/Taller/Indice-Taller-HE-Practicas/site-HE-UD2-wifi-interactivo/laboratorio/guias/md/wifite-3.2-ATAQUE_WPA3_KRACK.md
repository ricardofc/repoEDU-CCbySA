# Práctica Wifite 3.2 — WPA3-SAE e KRACK (non soportado por Wifite)

!!! warning "Uso autorizado"
    Realizar este procedemento exclusivamente na rede Wi-Fi simulada e autorizada do laboratorio `vuln-wifi.lab`.

!!! important "Documento de referencia"
    [3-Taller-HE-Practica-WiFi-2.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-2.pdf), especialmente as páxinas **8 e 9**. O PDF explica o *4-Way Handshake*, a mensaxe M3 e o problema da reinstalación de claves. Para unha análise práctica desas mensaxes utilízase a [práctica 3.2 — WPA3-SAE e KRACK](./3.2-ATAQUE_WPA3_KRACK.md).

## 1. Obxectivo

**Comprobar se Wifite permite avaliar ou executar un ataque KRACK (*Key Reinstallation Attack*) contra unha rede WPA3-SAE.**

O procedemento consiste en iniciar unha rede WPA3-SAE, identificar a súa autenticación con Wifite e consultar as funcións de auditoría dispoñibles. O resultado esperado é distinguir entre **detectar unha rede WPA3-SAE** e **probar unha reinstalación de claves**.

Esta práctica é un procedemento de laboratorio autónomo. Non require ter realizado a práctica 3.1 previamente.

## 2. Fundamentos técnicos

WPA3-Personal usa **SAE** para autenticar AP e cliente e continúa utilizando un **4-Way Handshake EAPOL-Key** para establecer as claves de tráfico. As súas mensaxes denomínanse **M1, M2, M3 e M4**.

**KRACK** non é un ataque de dicionario contra o contrasinal. Explota unha implementación vulnerable que reinstala unha clave xa utilizada, por exemplo cando procesa unha retransmisión de **M3**. Esta reinstalación pode provocar reutilización de *nonces*.

**PMF (`ieee80211w=2`)** protexe determinadas tramas robustas de xestión, pero **non protexe EAPOL-Key nin garante inmunidade a KRACK**.

Wifite automatiza detección de redes e ataques orientados á recuperación de contrasinais, como a captura de **PMKID** e de *handshakes*. Estes procedementos **non equivalen a comprobar KRACK**: para iso sería preciso provocar unha situación controlada de retransmisión e analizar se o cliente reinstala indebidamente a clave.

## 3. Organización do laboratorio

| Terminal Kali | Función | Interface |
|---|---|---|
| **Terminal 1** | Iniciar e comprobar o AP WPA3-SAE | `wlan0` no *namespace* `phy0_wlan0` |
| **Terminal 2** | Comprobar Wifite e detectar a rede | `wlan3`, no *namespace* global |

O escenario `wpa3_sae` utiliza catro radios simuladas: `wlan0` (AP), `wlan1` (cliente), e `wlan2`/`wlan3` (interfaces globais). Non é necesario entrar en *namespaces* interactivos.

## 4. Procedemento

### 4.1. Terminal 1 — Iniciar o escenario

Tras arrancar Kali, executar:

```bash
sudo wifilabctl up wpa3_sae
sudo wifilabctl status
```

Comprobar o AP e a conexión do cliente:

```bash
sudo ip netns exec phy0_wlan0 iw dev wlan0 info
sudo ip netns exec phy1_wlan1 iw dev wlan1 link
iw dev
```

Debe aparecer o SSID **`EMPRESA-XYZ`** na canle 6 e a interface atacante **`wlan3`**. Os enderezos MAC poden cambiar entre arranques.

### 4.2. Terminal 2 — Consultar as capacidades de Wifite

```bash
command -v wifite
dpkg-query -W -f='${Version}\n' wifite
wifite --help | grep -iE 'wpa3|sae|krack|reinstall|nonce' || true
```

Na instalación utilizada no laboratorio, **Wifite 2.8.2-1**, a axuda presenta a opción:

```text
--wpa3    Show only WPA3-encrypted networks (SAE/OWE)
```

Esta opción serve para **filtrar redes**, non para provocar reinstalacións de claves. Non hai unha opción documentada para executar unha proba KRACK nesta versión. A simple ausencia dun texto na axuda non demostraría por si soa que nunca puidese existir tal funcionalidade; a conclusión apóiase tamén nos procedementos que implementa a ferramenta.

### 4.3. Terminal 2 — Detectar a rede WPA3-SAE

```bash
sudo wifite -i wlan3 --wpa3 --no-wps --no-deauths
```

- `-i wlan3`: selecciona a interface de observación.
- `--wpa3`: mostra as redes WPA3.
- `--no-wps`: desactiva os ataques WPS.
- `--no-deauths`: evita as desautenticacións automáticas.

Cando apareza `EMPRESA-XYZ`, finaliza o escaneo con `Ctrl+C`. **Non é necesario seleccionar a rede para lanzar capturas PMKID ou *handshake***: esas operacións auditan contrasinais, non reinstalacións KRACK. Sae de Wifite sen iniciar ataques.

Saída orientativa da detección (o sinal e os enderezos poden variar):

```text
NUM  ESSID          CH  ENCR    PWR   WPS
  1  EMPRESA-XYZ     6  WPA3-S  72db  no
```

## 5. Interpretación do resultado

| Comprobación | Resultado na versión Wifite do laboratorio |
|---|---|
| Identificar a rede `EMPRESA-XYZ` | Si |
| Detectar a autenticación `WPA3-S` | Si |
| Filtrar redes WPA3 con `--wpa3` | Si |
| Capturar PMKID ou *handshakes* como auditoría de contrasinais | Dispoñibilidade de intentos de captura; non son KRACK |
| Retransmitir M3 para comprobar reinstalación de PTK | **Non hai procedemento KRACK específico en Wifite** |
| Verificar que un cliente é vulnerable ou inmune a KRACK | **Non** |

!!! note "Conclusión"
    **Wifite recoñece WPA3-SAE, pero non ofrece neste laboratorio un ataque nin un comprobador KRACK.** A identificación de WPA3 e as funcións de captura para auditoría de contrasinais non demostran vulnerabilidade ou resistencia á reinstalación de claves. Para observar M1–M4, os contadores e o indicador `Install` de M3, segue o procedemento da [práctica 3.2](./3.2-ATAQUE_WPA3_KRACK.md), que tampouco pretende certificar a resistencia a KRACK.

## 6. Finalización

Se remataches as prácticas sobre este escenario, podes desmontalo:

```bash
sudo wifilabctl reset
```

**Referencias:** [PDF da práctica 3.2](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-2.pdf) (páxinas 8–9) e [Wifite2 — funcionalidades documentadas](https://github.com/derv82/wifite2).
