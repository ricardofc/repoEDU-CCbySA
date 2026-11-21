# Laboratorio Vulnerable Wi-Fi (vuln-wifi.lab) con Vagrant e mac80211_hwsim

!!! important "Despregamento do laboratorio"
    No anfitrión, executa `vagrant up` e despois `vagrant reload`. O reinicio activa o acceso gráfico automático como usuario `kali` e a eliminación controlada de `vagrant`. Para traballar, abre a consola de VirtualBox como `kali` e utiliza `sudo wifilabctl`. **Non empregues `make ssh` nin `vagrant ssh` unha vez finalizada a VM.** Os comandos de conexión SSH mediante Vagrant só son aplicables antes da finalización da VM.


!!! important "[![Licenza](https://img.shields.io/badge/Licenza-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/){target='_blank'} [![Kali Linux](https://img.shields.io/badge/Kali-Rolling-557C94.svg)](https://www.kali.org/){target='_blank'} [![VirtualBox](https://img.shields.io/badge/VirtualBox-7.0%2B-blue.svg)](https://www.virtualbox.org/){target='_blank'} [![Vagrant](https://img.shields.io/badge/Vagrant-2.3%2B-1868F2.svg)](https://www.vagrantup.com/){target='_blank'}"

    **Laboratorio automatizado para prácticas de Hacking Ético Wi-Fi baseado en Vagrant, VirtualBox e mac80211_hwsim**

    Este laboratorio está estruturado para coincidir cos manuais PDF do repositorio [repoEDU-CCbySA - HE - Wi-Fi](https://github.com/ricardofc/repoEDU-CCbySA/tree/main/HE/Taller/Wi-Fi/){target="_blank"}

## Aviso Legal

!!! warning "**IMPORTANTE:** Este laboratorio é **EXCLUSIVAMENTE** para fins educativos."
    O autor do presente documento **declina calquera responsabilidade** asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa información exposta no mesmo. Por tanto, non se fai responsable en ningún caso, nin pode ser considerado legalmente responsable en ningún caso, das consecuencias que poidan derivarse da información contida nel, incluíndo os posibles erros e información incorrecta existentes, información difamatoria, así como das consecuencias que se poidan derivar sobre a súa aplicación en sistemas de información reais e/ou virtuais. Este documento foi xerado para uso didáctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.

    **NON EXPOÑAS ESTA MÁQUINA A INTERNET.** 

    Usos permitidos e non permitidos:

    - ✅ Permitido: uso en contornas virtuais controladas con permiso do administrador  

    - ✅ Permitido: aprendizaxe e formación en ciberseguridade  

    - ❌ PROHIBIDO: uso contra redes reais sen autorización explícita e por escrito  

    - ❌ PROHIBIDO: distribución de ferramentas ou técnicas con fins maliciosos  

---

## Táboa de Contidos

- [Características Principais](#caracteristicas-principais)  

- [Requisitos Previos](#requisitos-previos)  

- [Instalación Rápida](#instalacion-rapida)  

- [Índice de Prácticas](#indice-de-practicas)  

- [Uso Básico](#uso-basico)  

- [Comandos de wifilabctl](#comandos-de-wifilabctl)  

- [Makefile](#makefile)  

- [Comparación de Prácticas](#comparacion-de-practicas)  

- [Estrutura do Laboratorio](#estrutura-do-laboratorio)  

- [Resolución de Problemas](#resolucion-de-problemas)  

- [Aviso Legal](#aviso-legal)  

- [Referencias](#referencias)  

---

## Características Principais

- Automatización completa mediante `vagrant up`  

- 6 escenarios preconfigurados listos para usar  

- Simulación realista con `mac80211_hwsim` (sen hardware físico)  

- Namespaces de rede para illamento total  

- Ferramentas preinstaladas: `aircrack-ng`, `hostapd`, `hostapd-wpe`, `hostapd-mana`, `FreeRADIUS`, `dragondrain`, `hcxdumptool`  

- Dúas modalidades de guías por práctica: manual detallada e versión automatizada con `wifite`  

- Compatible con PDFs oficiais do repositorio HE  

---

## Comprobación de Hashcat e OpenCL

O laboratorio incorpora `hashcat`, `pocl-opencl-icd` e `clinfo`. En VirtualBox,
**PoCL utiliza a CPU da máquina virtual para executar OpenCL**; non se precisa unha GPU.
É un requisito para as comprobacións de contrasinais que Wifite executa mediante Hashcat.

```bash
clinfo -l
hashcat -I
```

Se aparece `CL_PLATFORM_NOT_FOUND_KHR` ou non se detecta unha plataforma de cálculo:

```bash
sudo apt update
sudo apt install -y pocl-opencl-icd clinfo
```

Comproba de novo `hashcat -I`. Sen dispositivo de cálculo, a captura WPA2 pode ser válida aínda que Wifite indique `key unknown`.

---

## Requisitos Previos

### Software Necesario

| Software | Versión Mínima | Enlace de Descarga |
|----------|----------------|-------------------|
| **VirtualBox** | 7.0+ | [virtualbox.org](https://www.virtualbox.org/wiki/Downloads){target="_blank"} |
| **Vagrant** | 2.3+ | [vagrantup.com](https://www.vagrantup.com/downloads){target="_blank"} |
| **Git** | 2.0+ | [git-scm.com](https://git-scm.com/downloads){target="_blank"} |

### Hardware Recomendado

- RAM: 8 GB (mínimo 6 GB libres para a VM)  

- CPU: 4 cores (2 cores para a VM)  

- Disco: 20 GB libres  

- OS: Windows 10/11, macOS 11+, GNU/Linux (Debian 12+)  

---

## Instalación Rápida

### 1. Clonar o Repositorio

```bash
git clone https://github.com/ricardofc/vuln-wifi.lab.git
cd vuln-wifi.lab
```

### 2. Iniciar a Máquina Virtual

```bash
make up
```

Tempo estimado: 15-20 minutos (primeira execución).

### 3. Acceder á VM

```bash
# Abrir a consola gráfica de VirtualBox (autologin de kali)
```

### 4. Primeira Execución

```bash
# Verificar instalación
sudo wifilabctl doctor

# Listar escenarios dispoñibles
sudo wifilabctl list
```

Saída esperada:

```
ID                   Descrición
------------------------------------------------------------
psk                  WPA2-PSK: Ataque de dicionario offline
psk_pmf              WPA2-PSK con PMF: Protección básica contra deauth
eap_evil_twin        WPA2-EAP: Evil Twin sen validación de certificados
eap_mitm             WPA2-EAP: Man-in-the-Middle con hostapd-mana
wpa3_sae             WPA3-SAE: Auditoría de contrasinal (resistente a ataques offline)
wpa3_sae_vulnerable  WPA3-SAE vulnerable (hostapd 2.7) + Evil Twin WPA2-PSK + Dragondrain DoS
```

---

## Índice de Prácticas

### Correspondencia entre Manuais PDF e Escenarios

Cada práctica dispón de **dúas guías complementarias**: a guía manual detallada (paso a paso, como o PDF) e a guía con `wifite` (ferramenta automatizada). Ambas traballan co mesmo escenario `wifilabctl`.

#### Bloque 1: WPA2-PSK

> 4 PDFs → 3 guías manuais + 3 guías Wifite. Os PDFs 1.3 e 1.4 comparten guía manual (`1.3`) porque cobren o mesmo ataque PMKID: o PDF-1.3 usa o escenario `psk` (sen PMF) e o PDF-1.4 usa `psk_pmf` (con `ieee80211w=2`), demostrando que PMF **non protexe** contra PMKID.

| Manual PDF | Escenario | Guía Manual | Guía Wifite | Descrición |
|---|---|---|---|---|
| **1-Taller-HE-Practica-WiFi-1.pdf** | `psk` | `1.1-ATAQUE_WPA2_PSK.md` | `wifite-1.1-ATAQUE_WPA2_PSK.md` | Captura de handshake 4-Way + cracking offline con `aircrack-ng` |
| **1-Taller-HE-Practica-WiFi-2.pdf** | `psk_pmf` | `1.3-ATAQUE_WPA2_PSK_PMF.md` | `wifite-1.3-ATAQUE_WPA2_PSK_PMF.md` | PMF (`ieee80211w=2`): as tramas de deauth van cifradas, o ataque falla |
| **1-Taller-HE-Practica-WiFi-3.pdf** | `psk` | `1.4-ATAQUE_WPA2_PSK_PMKID.md` | `wifite-1.4-ATAQUE_WPA2_PSK_PMKID.md` | PMKID silencioso con `hcxdumptool` + `hashcat -m 22000` (AP sen PMF) |
| **1-Taller-HE-Practica-WiFi-4.pdf** | `psk_pmf` | `1.4-ATAQUE_WPA2_PSK_PMKID.md` | `wifite-1.4-ATAQUE_WPA2_PSK_PMKID.md` | PMKID con `ieee80211w=2` activo: PMF **non** protexe contra PMKID |

As catro prácticas do Bloque 1 diferéncianse polo método de captura e o escenario:

- **PDF 1.1** (`psk`): deautenticación con `aireplay-ng` → captura do handshake 4-Way → cracking offline con `aircrack-ng`

- **PDF 1.2** (`psk_pmf`): o AP ten `ieee80211w=2` → as tramas de deauth van **cifradas** e son descartadas polo cliente; o ataque falla; verifícase con `tshark` e logs de `wpa_supplicant`

- **PDF 1.3** (`psk`): `hcxdumptool` envía Association Requests e captura o PMKID en 15-30 s → cracking offline con `hashcat -m 22000`; non require deautenticar ao cliente; AP **sen** PMF

- **PDF 1.4** (`psk_pmf`): mesmo ataque PMKID co AP e cliente en `ieee80211w=2` → demostra que **PMF non protexe contra PMKID**; `hcxdumptool` captura o PMKID igualmente

#### Bloque 2: WPA2-Enterprise (EAP)

 > 3 PDFs → 2 guías manuais + 1 guía Wifite (a práctica 2.1 é demostración de limitacións de Wifite). O PDF 2.1 (setup e funcionamento de FreeRADIUS) só ten guía Wifite, que demostra que Wifite descarta automaticamente obxectivos `WPA-E` sen realizar ningún ataque.

| Manual PDF | Escenario | Guía Manual | Guía Wifite | Descrición |
|---|---|---|---|---|
| **2-Taller-HE-Practica-WiFi-1.pdf** | `eap_mitm` | — | `wifite-2.1-ATAQUE_WPA2_EAP.md` | Setup FreeRADIUS + AP WPA2-EAP + cliente; Wifite detecta `WPA-E` e descarta o obxectivo automaticamente |
| **2-Taller-HE-Practica-WiFi-2.pdf** | `eap_evil_twin` | `2.2-ATAQUE_WPA2_EAP_EVIL_TWIN.md` | `—` | Evil Twin con `hostapd-wpe`: captura hash MSCHAPv2 + cracking con `hashcat -m 5500` |
| **2-Taller-HE-Practica-WiFi-3.pdf** | `eap_mitm` | `2.3-ATAQUE_WPA2_EAP_MITM.md` | `—` | MITM con `hostapd-mana`: relay RADIUS + captura de tráfico con `mitmproxy` |

#### Bloque 3: WPA3-SAE

> 3 PDFs → 3 guías manuais + 2 guías Wifite. A limitación de Wifite fronte a KRACK explícase na práctica 3.2, sen unha guía independente.

| Manual PDF | Escenario | Guía Manual | Guía Wifite | Descrición |
|---|---|---|---|---|
| **3-Taller-HE-Practica-WiFi-1.pdf** | `wpa3_sae` | `3.1-ATAQUE_WPA3_SAE.md` | `wifite-3.1-ATAQUE_WPA3-SAE.md` | SAE resistente a cracking offline; Dragonblood (timing); forza bruta online con `wacker` |
| **3-Taller-HE-Practica-WiFi-2.pdf** | `wpa3_sae` | `3.2-ATAQUE_WPA3_KRACK.md` | Integrado na guía manual | Análise do 4-Way Handshake e límites da comprobación de KRACK con `tshark`; PMF non demostra inmunidade |
| **3-Taller-HE-Practica-WiFi-3.pdf** | `wpa3_sae_vulnerable` | `3.3-ATAQUE_WPA3_DoS_WPA2_EVIL_TWIN.md` | `wifite-3.3-ATAQUE_WPA3_DoS_WPA2_EVIL_TWIN.md` | Dragondrain DoS + downgrade WPA2-PSK/EAP; Wifite é inútil para este ataque multi-etapa |

---

## Uso Básico

### Como Comezar unha Práctica

#### Método 1: Seguindo o Manual PDF

1. Abre o manual PDF correspondente ([ver sección Manuais PDF do Taller](#manuais-pdf-do-taller))  

2. Consulta a táboa de correspondencia anterior para identificar o escenario  

3. Inicia o escenario dende dentro da VM:  

```bash
# Exemplo para Práctica 1.1 (WPA2-PSK básico)
sudo wifilabctl up psk
```

4. Consulta a guía de ataque proporcionada polo profesorado (sección `Ataques específicos`)  

5. Segue os pasos do PDF e da guía markdown en paralelo  

#### Método 2: Exploración Libre

```bash
# Ver todos os escenarios dispoñibles
sudo wifilabctl list

# Iniciar un escenario
sudo wifilabctl up <nome_escenario>

# Ver estado actual
sudo wifilabctl status

# Ver logs en tempo real
sudo wifilabctl logs <nome_escenario>

# Deter e limpar
sudo wifilabctl reset
```

---

## Comandos de wifilabctl

### Listar Escenarios

```bash
sudo wifilabctl list
```

### Iniciar un Escenario

```bash
sudo wifilabctl up <escenario>
```

Exemplos:

```bash
# Prácticas 1.1 e 1.3 (WPA2-PSK handshake e PMKID)
sudo wifilabctl up psk

# Práctica 1.3 (PMF / ieee80211w)
sudo wifilabctl up psk_pmf

# Prácticas 2.1 e 2.2 (WPA2-EAP Evil Twin)
sudo wifilabctl up eap_evil_twin

# Práctica 2.3 (WPA2-EAP MITM)
sudo wifilabctl up eap_mitm

# Prácticas 3.1 e 3.2 (WPA3-SAE + wacker + KRACK)
sudo wifilabctl up wpa3_sae

# Práctica 3.3 (Dragondrain DoS + Downgrade WPA2-PSK/EAP)
sudo wifilabctl up wpa3_sae_vulnerable
```

### Ver Estado do Laboratorio

```bash
sudo wifilabctl status
```

Saída esperada:

```
[*] Informe de Estado do Laboratorio
============================================================
Namespaces activos:
  wifi_ap_wlan0
  wifi_cliente_wlan1

Interfaces por namespace:
  wifi_ap_wlan0:
    wlan0: UP (AP)
  wifi_cliente_wlan1:
    wlan1: UP (Cliente)
```

### Ver Logs en Tempo Real

```bash
sudo wifilabctl logs <escenario>
# Ctrl+C para saír
```

### Deter e Limpar

```bash
sudo wifilabctl reset
```

### Diagnosticar Problemas

```bash
sudo wifilabctl doctor
```

---

## Makefile

O `Makefile` proporciona atallos para as operacións máis comúns dende o host, sen necesidade de entrar na VM manualmente.

### Comandos Dispoñibles

```bash
# Levantar e aprovisionar a VM
make up

# Conectar á VM por SSH
# Abrir a consola gráfica de VirtualBox (autologin de kali)

# Suspender a VM
make halt

# Destruír a VM completamente
make destroy

# Destruír e limpar (alias de destroy)
make clean
```

### Exemplo de Fluxo Completo

```bash
# 1. Levantar a VM
make up

# 2. Conectar e traballar
# Abrir a consola gráfica de VirtualBox (autologin de kali)

# 3. Dentro da VM: iniciar o escenario desexado
sudo wifilabctl up eap_evil_twin

# 4. Ao rematar: suspender ou destruír
make halt      # Suspender (conserva o estado)
make destroy   # Destruír completamente
```

---

## Comparación de Prácticas

### Táboa Comparativa de Vulnerabilidades

| Práctica | Escenario | Tecnoloxía | Tipo de Ataque | Vulnerable? | Tempo Estimado |
|----------|-----------|------------|----------------|-------------|----------------|
| PDF 1.1 | `psk` | WPA2-PSK | Deauth + handshake 4-Way + dicionario offline (`aircrack-ng`) | SI | 30 min |
| PDF 1.2 | `psk_pmf` | WPA2-PSK + PMF | Intento deauth — bloqueado por `ieee80211w=2` | NON (deauth) | 20 min |
| PDF 1.3 | `psk` | WPA2-PSK | PMKID con `hcxdumptool` + `hashcat -m 22000`, AP sen PMF | SI | 20 min |
| PDF 1.4 | `psk_pmf` | WPA2-PSK + PMF | PMKID con `ieee80211w=2` activo — PMF **non** protexe contra PMKID | SI | 25 min |
| PDF 2.1 | `eap_mitm` | WPA2-EAP | Setup FreeRADIUS + cliente; Wifite descarta `WPA-E` | Referencia | 30 min |
| PDF 2.2 | `eap_evil_twin` | WPA2-EAP | Evil Twin (`hostapd-wpe`) + `hashcat -m 5500` | SI | 45 min |
| PDF 2.3 | `eap_mitm` | WPA2-EAP | MITM (`hostapd-mana`) + relay RADIUS + `mitmproxy` | SI | 60 min |
| PDF 3.1 | `wpa3_sae` | WPA3-SAE | Dragonblood timing; forza bruta online con `wacker` | NON offline / SI online | 45 min |
| PDF 3.2 | `wpa3_sae` | WPA3-SAE + PMF | Verificación inmunidade KRACK con `tshark` | NON | 30 min |
| PDF 3.3 | `wpa3_sae_vulnerable` | WPA3-SAE (≤2.7) | Dragondrain DoS + downgrade WPA2-PSK ou WPA2-EAP | SI (modo transición) | 60 min |

### Resumo por Tecnoloxía

#### WPA2-PSK

| Protección | Estado | Observacións |
|------------|--------|--------------|
| Handshake Capture | Vulnerable | Require cliente conectado; cracking offline con `aircrack-ng` (PDF 1.1) |
| PMKID Attack | Vulnerable | Require cliente lexítimo con sesión activa; AP cachea PMK tras 1º handshake (PDF 1.3 e 1.4) |
| PMF (`ieee80211w=2`) | **Protexe só contra deauth** | Bloquea frames de deauth non cifrados (PDF 1.2) pero **non protexe contra PMKID** (PDF 1.4) |
| Dicionario Offline | Vulnerable | Afecta tanto a handshake como a PMKID; contrasinais longos e aleatorios resisten |

#### WPA2-EAP

| Protección | Estado | Observacións |
|------------|--------|--------------|
| Evil Twin | Vulnerable | Se o cliente non valida o certificado do servidor RADIUS |
| MITM | Vulnerable | `hostapd-mana` captura credenciais MSCHAPv2 |
| Validación Certificado | Protexe | Se `ca_cert` está correctamente configurado en `wpa_supplicant` |

#### WPA3-SAE

| Protección | Estado | Observacións |
|------------|--------|--------------|
| Dicionario Offline | Protexido | SAE non expón hash crackeable; `aircrack-ng` non é aplicable |
| Forza Bruta Online (`wacker`) | Parcialmente vulnerable | Posible se o contrasinal é débil; limitado pola velocidade de resposta do AP |
| KRACK | Protexido | PMF obrigatorio + implementación correcta |
| Dragonblood DoS | Vulnerable | En hostapd < 2.10 |
| Downgrade a WPA2 | Vulnerable | Se o modo transición está activo |

---

## Estrutura do Laboratorio

### Dentro da VM (`/home/kali/wifiLab/`)

O `bootstrap.sh` copia unicamente o mínimo necesario para o funcionamento do laboratorio. 

```
/home/kali/wifiLab/
├── scenarios/                     # Definicións YAML dos escenarios
│   ├── eap_evil_twin.yaml
│   ├── eap_mitm.yaml
│   ├── psk.yaml
│   ├── psk_pmf.yaml
│   ├── wpa3_sae.yaml
│   └── wpa3_sae_vulnerable.yaml
├── scripts/
│   └── wifilabctl                 # Xestor de escenarios (tamén en /usr/local/bin/)
└── run/                           # Creado por wifilabctl ao iniciar un escenario
    └── <escenario>/
        ├── hostapd.log            # Logs do AP lexítimo
        ├── wpa_supplicant.log     # Logs do cliente simulado
        ├── freeradius.log         # Logs de RADIUS (só escenarios EAP)
        ├── hostapd_wpe.log        # Logs do AP falso (só eap_evil_twin)
        └── *.cap                  # Ficheiros de captura de tráfico
```

---

## Resolución de Problemas

### Problemas Comúns

#### 1. "Non hai namespaces wifi activos"

Causa: O escenario non está iniciado ou fallou ao cargar o módulo `mac80211_hwsim`.

Solución:

```bash
# Verificar módulo
lsmod | grep mac80211_hwsim

# Se non está cargado
sudo modprobe mac80211_hwsim radios=4

# Reiniciar escenario
sudo wifilabctl reset
sudo wifilabctl up psk
```

#### 2. "RADIUS server not responding"

Causa: FreeRADIUS non está en execución ou problema de certificados.

Solución:

```bash
# Verificar FreeRADIUS
sudo systemctl status freeradius

# Comprobar certificados
ls -la /etc/freeradius/3.0/certs/

# Rexenerar certificados
cd /etc/freeradius/3.0/certs/
sudo make

# Reiniciar RADIUS
sudo systemctl restart freeradius
```

#### 3. "hostapd-mana: not found"

Causa: `hostapd-mana` non está compilado.

Solución:

```bash
# Compilar hostapd-mana
cd /opt/hostapd-mana
make -C hostapd

# Verificar binario
ls -la /opt/hostapd-mana/hostapd/hostapd

# Crear enlace simbólico
sudo ln -sf /opt/hostapd-mana/hostapd/hostapd /usr/local/bin/hostapd-mana
```

#### 4. "airodump-ng: interface wlan2mon not found"

Causa: A interface non está en modo monitor.

Solución:

```bash
# Matar procesos que interfiren
sudo airmon-ng check kill

# Poñer en modo monitor
sudo airmon-ng start wlan2

# Verificar
iwconfig
```

#### 5. "Vagrant SSH not working"

Causa: SSH non está escoitando.

Solución:

```bash
# Dende o host
make destroy
make up

# Ou dende a VM (consola GUI)
sudo systemctl restart ssh
sudo systemctl status ssh
```

### Comandos de Diagnóstico

```bash
# Verificar estado completo
sudo wifilabctl doctor

# Comprobar interfaces de rede
ip link show

# Comprobar namespaces
ip netns list

# Comprobar módulo mac80211_hwsim
lsmod | grep mac80211

# Ver procesos relacionados
ps aux | grep -E 'hostapd|wpa_supplicant|freeradius'

# Verificar logs do sistema
journalctl -xeu freeradius
journalctl -xeu ssh
```

### Reinicio Completo

Se todo falla, reinicia completamente:

```bash
# Dende o host (fóra da VM)
make destroy
make up
```

---

## Actualización e Mantemento

### Actualizar o Laboratorio

```bash
# No host, actualizar o repositorio
git pull origin main

# Destruír e recrear a VM
make destroy
make up
```

### Desinstalación Completa

```bash
make destroy
cd ..
rm -rf vuln-wifi.lab
```

---

## Referencias

### Documentación Oficial

- [WPA2 Specification - IEEE 802.11i](https://standards.ieee.org/standard/802_11i-2004.html){target="_blank"}  

- [WPA3 Specification - Wi-Fi Alliance](https://www.wi-fi.org/discover-wi-fi/security){target="_blank"}  

- [IEEE 802.11w - Protected Management Frames](https://standards.ieee.org/standard/802_11w-2009.html){target="_blank"}  

- [RFC 7664 - Dragonfly Key Exchange](https://tools.ietf.org/html/rfc7664){target="_blank"}  

- [hostapd documentation](https://w1.fi/hostapd/){target="_blank"}  

- [wpa_supplicant documentation](https://w1.fi/wpa_supplicant/){target="_blank"}  

- [FreeRADIUS documentation](https://freeradius.org/documentation/){target="_blank"}  

### Investigación e Vulnerabilidades

- [KRACK Attack Website](https://www.krackattacks.com/){target="_blank"} (2017)  

- [Dragonblood Website](https://wpa3.mathyvanhoef.com/){target="_blank"} (2019)  

- [CVE-2017-13077 (KRACK)](https://nvd.nist.gov/vuln/detail/CVE-2017-13077){target="_blank"}  

- [CVE-2019-9494 (Dragonblood)](https://nvd.nist.gov/vuln/detail/CVE-2019-9494){target="_blank"}  

- [CVE-2019-13377 (Dragonblood SAE)](https://nvd.nist.gov/vuln/detail/CVE-2019-13377){target="_blank"}  

### Ferramentas

- [aircrack-ng](https://www.aircrack-ng.org/){target="_blank"}  

- [wifite2](https://github.com/derv82/wifite2){target="_blank"}  

- [hostapd-wpe (OpenSecurityResearch)](https://github.com/OpenSecurityResearch/hostapd-wpe){target="_blank"}  

- [hostapd-mana (SensePost)](https://github.com/sensepost/hostapd-mana){target="_blank"}  

- [dragondrain (vanhoefm)](https://github.com/vanhoefm/dragondrain-and-time){target="_blank"}  

- [hcxtools (ZerBea)](https://github.com/ZerBea/hcxtools){target="_blank"}  

- [hcxdumptool (ZerBea)](https://github.com/ZerBea/hcxdumptool){target="_blank"}  

### Manuais PDF do Taller

- [1-Taller-HE-Practica-WiFi-1.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-1.pdf){target="_blank"}  

- [1-Taller-HE-Practica-WiFi-2.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-2.pdf){target="_blank"}  

- [1-Taller-HE-Practica-WiFi-3.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-3.pdf){target="_blank"}  

- [1-Taller-HE-Practica-WiFi-4.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/1-Taller-HE-Practica-WiFi-4.pdf){target="_blank"}  

- [2-Taller-HE-Practica-WiFi-1.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/2-Taller-HE-Practica-WiFi-1.pdf){target="_blank"}  

- [2-Taller-HE-Practica-WiFi-2.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/2-Taller-HE-Practica-WiFi-2.pdf){target="_blank"}  

- [2-Taller-HE-Practica-WiFi-3.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/2-Taller-HE-Practica-WiFi-3.pdf){target="_blank"}  

- [3-Taller-HE-Practica-WiFi-1.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-1.pdf){target="_blank"}  

- [3-Taller-HE-Practica-WiFi-2.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-2.pdf){target="_blank"}  

- [3-Taller-HE-Practica-WiFi-3.pdf](https://raw.githubusercontent.com/ricardofc/repoEDU-CCbySA/main/HE/Taller/Wi-Fi/3-Taller-HE-Practica-WiFi-3.pdf){target="_blank"}  
