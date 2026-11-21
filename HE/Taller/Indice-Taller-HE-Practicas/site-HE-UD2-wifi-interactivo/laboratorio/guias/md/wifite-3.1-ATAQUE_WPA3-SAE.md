# Práctica Wifite 3.1 — Intento de recuperación do contrasinal WPA3-SAE

!!! warning "Ámbito de execución autorizado"
    Esta práctica debe realizarse exclusivamente no laboratorio virtual `vuln-wifi.lab` ou sobre redes propias expresamente autorizadas. A auditoría consiste en tentar recuperar o contrasinal do AP simulado mediante Wifite e analizar o resultado.

---

## 1. Obxectivos da práctica

O obxectivo principal é **intentar obter o contrasinal dunha rede Wi-Fi WPA3-Personal (SAE) empregando Wifite** e determinar, a partir da saída real da ferramenta, se a tentativa é viable.

Ao rematar, o alumnado deberá ser capaz de:

1. Preparar un punto de acceso **WPA3-SAE** e un cliente lexítimo nun escenario illado.
2. Detectar e seleccionar o obxectivo `EMPRESA-XYZ` mediante **Wifite**.
3. Executar os intentos automáticos de captura **PMKID** e **WPA handshake**, sen interromper os procesos.
4. Determinar se Wifite consegue material utilizable para iniciar a recuperación do contrasinal.
5. Explicar o resultado empregando os conceptos **SAE Commit/Confirm**, **PMK**, **4-way handshake** e **PMF**.

**Referencia docente:** [PDF «Auditar contrasinal Wi-Fi WPA3 (SAE)» — Práctica 3.1](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-1.pdf){:target="_blank"}. As páxinas **2–4** introducen WPA3-SAE; as **5–8** desenvolven a montaxe, a captura e a limitación dos ataques offline; as **9–11** tratan unha técnica de dicionario *online* distinta da captura automatizada. Nesta práctica aplicaremos **Wifite** ao mesmo tipo de rede e interpretaremos o comportamento observado.

!!! info "Finalidade do intento"
    A tarefa é **tentar recuperar o contrasinal con Wifite**, non asumir anticipadamente que o obteremos. O resultado negativo dunha técnica tamén é un resultado de auditoría que debe xustificarse con evidencias.

---

## 2. Material necesario e escenario

- Máquina virtual **Kali Linux** de `vuln-wifi.lab`.
- Escenario automatizado **`wpa3_sae`** con catro radios simuladas mediante `mac80211_hwsim`.
- Ferramentas instaladas: `wifilabctl`, `iw`, `ip`, `wifite`.
- Dúas terminais abertas en Kali.

### 2.1. Distribución das interfaces

| Interface | Función | Namespace |
|---|---|---|
| `wlan0` | Punto de acceso WPA3-SAE | `phy0_wlan0` |
| `wlan1` | Cliente lexítimo WPA3-SAE | `phy1_wlan1` |
| `wlan2` | Radio adicional sen empregar | Global |
| `wlan3` | Radio atacante empregada por Wifite | Global |

**Parámetros de referencia do punto de acceso:**

```ini
ssid=EMPRESA-XYZ
channel=6
wpa=2
wpa_key_mgmt=SAE
rsn_pairwise=CCMP
ieee80211w=2
sae_require_mfp=1
```

- `wpa_key_mgmt=SAE` identifica a autenticación **WPA3-Personal**.
- `wpa=2` activa **RSN**, non unha autenticación WPA2-PSK.
- `ieee80211w=2` require **PMF (Protected Management Frames)**.
- O contrasinal está configurado no AP para que exista unha credencial de laboratorio, pero **non se introduce en Wifite**: preténdese tentar descubrilo desde a posición do atacante.

O **BSSID** e os enderezos MAC dos participantes poden cambiar cada vez que se inicia o escenario. Non deben copiarse enderezos de exemplos como se fosen fixos.

### 2.2. Función das terminais

| Terminal | Función | Relación co PDF 3.1 |
|---|---|---|
| **Terminal 1** | Iniciar o AP, o cliente e comprobar as interfaces | Preparación do AP e do cliente (páxs. 5–7) |
| **Terminal 2** | Detectar a rede e intentar recuperar a clave con Wifite | Rol de atacante e análise de captura (páx. 8) |

Nesta práctica **non é necesario crear manualmente os namespaces, iniciar outro `hostapd` nin executar `airmon-ng check kill`**: o escenario automatizado xa prepara os elementos necesarios.

---

## 3. Fundamento técnico: que intenta recuperar Wifite?

En **WPA2-PSK**, determinadas capturas do *4-way handshake* ou dun PMKID poden proporcionar material para probar candidatos de contrasinal **offline**, sen necesidade de comunicarse de novo co AP.

En **WPA3-SAE**, a autenticación baséase en **Simultaneous Authentication of Equals**:

1. **SAE Commit:** AP e cliente intercambian valores públicos para establecer un segredo sen enviar o contrasinal.
2. **SAE Confirm:** os participantes verifican o resultado do acordo criptográfico.
3. **4-way handshake EAPOL:** a PMK obtida do acordo SAE emprégase para derivar e instalar as claves de tráfico.

O *handshake* posterior **existe**, pero non ofrece o mesmo verificador para probar de maneira libre contrasinais offline que o intercambio clásico WPA2-PSK. Esa é a distinción central explicada no PDF 3.1 (páxs. 2–4 e 8).

**PMKID** identifica material de clave nun contexto de asociación ou reutilización de claves; a súa eventual presenza nunha conexión SAE **non significa automaticamente** que permita recuperar o contrasinal co ataque PMKID clásico de WPA2-PSK.

Wifite automatiza procedementos de descubrimento e captura. Executaremos os seus intentos e **verificaremos se consegue ou non chegar á fase de recuperación do contrasinal**.

---

## 4. Procedemento de auditoría

### 4.1. Terminal 1 — Iniciar WPA3-SAE

```bash
sudo wifilabctl up wpa3_sae
sudo wifilabctl status
```

Comprobar o AP, o cliente e as radios globais:

```bash
sudo ip netns exec phy0_wlan0 iw dev wlan0 info
sudo ip netns exec phy1_wlan1 iw dev wlan1 link
iw dev
```

**Comprobacións:**

- O AP anuncia o SSID `EMPRESA-XYZ` na canle 6.
- O cliente `wlan1` está conectado ao AP WPA3-SAE.
- A radio `wlan3` aparece no namespace global e está dispoñible.

Non empregues unha shell interactiva con `ip netns exec ... bash`: os comandos anteriores regresan á mesma terminal cando rematan.

### 4.2. Terminal 2 — Comprobar Wifite

```bash
command -v wifite
dpkg-query -W -f='${Version}\n' wifite
wifite --help | grep -i wpa3
```

**Exemplo de saída da VM utilizada:**

```text
/usr/sbin/wifite
2.8.2-1
--wpa3    Show only WPA3-encrypted networks (SAE/OWE)
```

A opción `--wpa3` permite **filtrar** redes anunciadas como WPA3; isto non garante que todos os ataques automatizados sexan aplicables a SAE.

### 4.3. Terminal 2 — Iniciar o intento de recuperación

```bash
mkdir -p ~/wifite-wpa3
cd ~/wifite-wpa3
sudo wifite -i wlan3 --wpa3 --no-wps
```

Significado das opcións:

- `-i wlan3`: radio do atacante.
- `--wpa3`: seleccionar redes de protección WPA3 (SAE/OWE) no escaneo.
- `--no-wps`: desactivar os métodos WPS, alleos ao obxectivo desta práctica.

Non usar `--kill` nin `airmon-ng check kill`, pois poden interromper os procesos necesarios do laboratorio.

**Selección do obxectivo:**

1. Deixa que apareza `EMPRESA-XYZ` na listaxe.
2. Preme **`Ctrl+C` exclusivamente para rematar o escaneo inicial** e abrir a selección de obxectivos.
3. Introduce o número correspondente a `EMPRESA-XYZ` (na saída de exemplo: `1`).
4. Deixa que **Wifite complete automaticamente todos os intentos de captura**, sen interromper a fase PMKID nin a fase de *handshake*.

**Exemplo real da selección:**

```text
NUM                      ESSID   CH  ENCR     PWR   WPS  CLIENT
---  -------------------------  ---  -----    ----  ---  ------
  1               EMPRESA-XYZ     6  WPA3-S    72db    no

[+] Select target(s) (1-1) separated by commas, dashes or all: 1
[+] (1/1) Starting attacks against DE:B4:2A:FB:BF:1E (EMPRESA-XYZ)
```

A clasificación `WPA3-S` indica que Wifite **detecta unha rede con SAE**. A detección non é unha recuperación do contrasinal.

### 4.4. Terminal 2 — Intento de captura PMKID

Wifite inicia primeiro o procedemento automático de procura dun PMKID. **Non o interrompas**: permite que a ferramenta conclúa.

**Saída real obtida:**

```text
[+] EMPRESA-XYZ (72db) PMKID CAPTURE: Failed to capture PMKID
```

**Interpretación:** Wifite non conseguiu capturar material PMKID aproveitable nesta execución. Polo tanto, **non pode pasar deste intento a unha comprobación de contrasinais baseada nesa captura**.

Isto non permite concluír que SAE nunca empregue PMKID; significa que **o intento concreto de Wifite fallou**.

### 4.5. Terminal 2 — Intento de captura do *handshake*

A continuación, Wifite busca unha captura de *handshake* WPA que considere válida para o seu procedemento automatizado. Deixa que finalice.

**Saída real obtida:**

```text
[+] EMPRESA-XYZ (72db) WPA Handshake capture: Discovered new client: CA:E2:9E:19:BB:48
[+] EMPRESA-XYZ (72db) WPA Handshake capture: Listening. (clients:1, deauth:14s, timeout:0s)
[!] WPA handshake capture FAILED: Timed out after 300 seconds
[+] Finished attacking 1 target(s), exiting
```

A ferramenta identifica un cliente, pero **non consegue completar a captura que precisa** e esgota o tempo establecido (300 segundos). A indicación `deauth:14s` non é, por si soa, unha proba de que unha desautenticación afectase ao cliente.

Un AP e un cliente WPA3-SAE poden realizar correctamente o seu propio intercambio EAPOL aínda que **Wifite non consiga unha captura aproveitable** para o seu método de auditoría.

### 4.6. Terminal 2 — Comprobación do contrasinal recuperado

Ao rematar Wifite, comproba o seu resultado:

- **Se aparece un contrasinal recuperado**, anótao e describe que procedemento permitiu obtelo.
- **Se non aparece ningún contrasinal**, indica cal das fases de captura fallou e achega as mensaxes da ferramenta.

**Resultado deste laboratorio:** non se recuperou o contrasinal. Non se iniciou unha fase eficaz de ataque de dicionario porque os métodos de captura anteriores non proporcionaron o material necesario. Por ese motivo, **non se require introducir `rockyou.txt` nesta execución**: unha lista de palabras non resolve a ausencia dunha captura utilizable nin converte un intercambio SAE nun verificador offline de WPA2-PSK.

---

## 5. Rexistro dos resultados

| Proba | Evidencia observada | Resultado |
|---|---|---|
| Identificación do AP | `EMPRESA-XYZ`, canle 6 | Correcta |
| Tipo de protección | `WPA3-S` | Correcta |
| Selección do obxectivo | Wifite inicia ataques contra o BSSID | Correcta |
| Captura PMKID | `Failed to capture PMKID` | **Fallida** |
| Captura de *handshake* | `Timed out after 300 seconds` | **Fallida** |
| Recuperación do contrasinal | Non se presenta unha clave obtida | **Non conseguida** |

!!! success "Conclusión do intento"
    **Wifite permitiu identificar e seleccionar o AP WPA3-SAE, pero non conseguiu recuperar o contrasinal.** A procura de PMKID rematou sen captura válida e a captura de *handshake* rematou por tempo esgotado. O resultado é coherente coa resistencia do intercambio SAE ordinario aos ataques de dicionario offline baseados no material típico de WPA2-PSK.

Esta conclusión refírese **ao procedemento executado**. Non debe interpretarse como demostración de que todas as implementacións WPA3-SAE sexan invulnerables ou de que non existan outros vectores de auditoría.

---

## 6. Interpretación e relación coa práctica 3.1 do PDF

### 6.1. Por que non se recuperou a clave cunha captura convencional?

A autenticación SAE estabelece material criptográfico mediante un acordo entre o cliente e o AP. Un observador non pode empregar os valores públicos do intercambio ordinario como se fosen un *hash* WPA2-PSK para verificar candidatos arbitrarios offline.

O *4-way handshake* EAPOL **non desaparece en WPA3**; prodúcese despois de SAE, cando xa existe unha PMK derivada do acordo autenticado. Confundir a existencia dese *handshake* coa posibilidade de recuperarlle o contrasinal levaría a unha conclusión incorrecta.

### 6.2. Cal é a función de PMF?

A configuración `ieee80211w=2` fai **obrigatorias as tramas de xestión protexidas (PMF)**. Isto protexe determinadas tramas robustas, incluídas desautenticación e desasociación, unha vez establecido o contexto de seguridade. Non significa que todas as tramas de xestión vaian cifradas nin exclúe todas as formas de denegación de servizo.

### 6.3. Significa isto que un contrasinal WPA3-SAE nunca se pode adiviñar?

Non. O PDF 3.1 (páxs. 9–11) distingue a **captura para análise offline** das **tentativas online contra o AP**, nas que cada candidato require interacción co protocolo SAE. O éxito dunha tentativa online depende, entre outros factores, da fortaleza do contrasinal e das defensas do AP.

**A ferramenta empregada nesta práctica é Wifite.** O propósito non é executar ese outro método, senón comprobar se o seu fluxo de captura e recuperación de contrasinais funciona contra o AP WPA3-SAE do laboratorio.

---

## 7. Finalización

Cando Wifite amose `Finished attacking 1 target(s), exiting`, a ferramenta rematou. Podes conservar o escenario activo para continuar coas actividades ou limpalo desde a terminal 1 mediante:

```bash
sudo wifilabctl reset
```

**Referencia:** PDF «Auditar contrasinal Wi-Fi WPA3 (SAE)», práctica 3.1 (páxs. 2–4: autenticación; 5–8: captura e limitación offline; 9–11: distinción coas tentativas online).
