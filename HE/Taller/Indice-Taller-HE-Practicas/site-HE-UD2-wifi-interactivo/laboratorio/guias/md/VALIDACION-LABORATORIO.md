# Comprobacións reproducibles de `vuln-wifi.lab`

!!! info "Alcance e evidencias"
    Unha configuración válida, unha asociación correcta e unha vulnerabilidade demostrada son evidencias diferentes. As saídas do laboratorio poden variar entre reinicios; **non reutilices MAC/BSSID de exemplos**. Traballa só en radios virtuais autorizadas.

## Correspondencia coas fontes docentes

| Manual PDF de referencia | Práctica | Escenario | Estado experimental |
|---|---|---|---|
| 1-Taller-HE-Practica-WiFi-1 | 1.1: WPA2-PSK | `psk` | EAPOL M1–M4 observado |
| 1-Taller-HE-Practica-WiFi-2 | 1.2: desautenticación | `psk` | Desconexión e reconexión observadas |
| 1-Taller-HE-Practica-WiFi-3 | 1.3: protección PMF | `psk_pmf` | MFPC/MFPR e rexeitamento de deauth sen protección observados |
| 1-Taller-HE-Practica-WiFi-4 | 1.4: PMKID | `psk` | 4 EAPOL, 1 WPA*02, **0 WPA*01**: resultado condicional válido |
| 2-Taller-HE-Practica-WiFi-1 | 2.1: EAP/RADIUS | Infraestrutura dos escenarios EAP | PEAP e Access-Accept observados |
| 2-Taller-HE-Practica-WiFi-2 | 2.2: Evil Twin EAP | `eap_evil_twin` | EAP lexítimo validado; contraste CA/servidor falso non repetido nesta auditoría |
| 2-Taller-HE-Practica-WiFi-3 | 2.3: MANA e MITM | `eap_mitm` | MANA AP-ENABLED e ponte operativa; cliente non migrou a MANA |
| 3-Taller-HE-Practica-WiFi-1 | 3.1: WPA3-SAE | `wpa3_sae` | SAE inicial, PMKSA e EAPOL confirmados nos logs |
| 3-Taller-HE-Practica-WiFi-2 | 3.2: KRACK | `wpa3_sae` | Configuración e análise, **non** explotación KRACK |
| 3-Taller-HE-Practica-WiFi-3 | 3.3: transición | `wpa3_sae_vulnerable` | PSK e SAE no AP corporativo; **non** DoS nin downgrade forzado |

## Topoloxías reais

| Escenarios | AP | Cliente | Radio de ataque | Captura recomendada |
|---|---|---|---|---|
| `psk`, `psk_pmf`, `psk` | `wifi_ap_wlan0` / `wlan0` | `wifi_cliente_wlan1` / `wlan1` | `wlan2` global | `wlan3` global |
| `eap_evil_twin` | `wifi_ap_wlan0` / `wlan0` | `wifi_cliente_wlan1` / `wlan1` | `evil_twin_wlan2` / `wlan2` | `wlan3` global |
| `eap_mitm` | `wifi_ap_wlan0` / `wlan0` | `wifi_cliente_wlan1` / `wlan1` | `mitm_wlan2` / `wlan2` | `wlan3` global |
| `wpa3_sae` | `phy0_wlan0` / `wlan0` | `phy1_wlan1` / `wlan1` | `wlan2` global | `wlan2` global |
| `wpa3_sae_vulnerable` | `phy0_wlan0` / `wlan0` | `phy1_wlan1` / `wlan1` | `evil_twin_wlan2` / `wlan2` | `wlan3` global |

!!! warning "Modo monitor"
    Nos ensaios empregouse `iw dev wlan3 set type monitor` (ou `wlan2` en SAE exclusivo). **Non supoñas a existencia de `wlan2mon`/`wlan3mon`**: `airmon-ng` pode crear unha interface con ese nome, pero o método con `iw` mantén o nome. Comproba sempre `sudo iw dev` e a canle antes de capturar. Non cambies a modo monitor unha radio que actúa como AP.

### Preparación xeral

```bash
sudo wifilabctl doctor
sudo wifilabctl list
sudo wifilabctl up psk   # substituír polo escenario da práctica
sudo wifilabctl status
sudo ip netns list
sudo iw dev
```

Exemplo para a interface global `wlan3` (só cando existe e non está en uso):

```bash
sudo ip link set wlan3 down
sudo iw dev wlan3 set type monitor
sudo ip link set wlan3 up
sudo iw dev wlan3 set channel 6
sudo iw dev wlan3 info
```

Captura pasiva reproducible:

```bash
sudo tshark -i wlan3 -a duration:60 -w /tmp/ud2-captura.pcapng
sudo tshark -r /tmp/ud2-captura.pcapng -Y eapol -T fields \
  -e frame.number -e wlan_rsna_eapol.keydes.msgnr
```

## Lectura correcta das evidencias

- **PMF:** `MFPC=1` declara capacidade; `MFPR=1` declara obrigatoriedade no BSS. En modo transición pode anunciarse `MFPC=1, MFPR=0` e esixirse PMF especificamente para SAE (`sae_require_mfp=1`).
- **SAE:** a autenticación inicial amosa `wlan.fixed.auth.alg=3`; unha reconexión que reutiliza PMKSA pode amosar `0` (Open System) **sen** cambiar a AKM SAE. Comproba `wpa_cli status` e os logs.
- **PMKID:** o formato Hashcat `WPA*01` representa PMKID; `WPA*02` representa EAPOL. Un PMKID calculado localmente ou extraído dun log SAE non é unha captura PMKID WPA2-PSK.
- **EAP/RADIUS:** `Access-Accept` observouse en `/var/log/freeradius/radius.log`, non no pequeno ficheiro de inicio `run/<escenario>/freeradius.log`. Consulta só eventos da execución actual e evita compartir identidades e segredos.
- **MANA:** `up eap_mitm` non inicia MANA; cómpre `AP-ENABLED` antes de `bridge-mitm`. `br-mitm` con `wlan2 + veth0`, IP `192.168.50.100/24` e ping a `192.168.50.1` confirma a infraestrutura, **non** un MITM extremo a extremo.

## Criterio de validación

Rexistra por separado: **configuración**, **servizos**, **asociación/autenticación**, **tramas ou logs**, **vulnerabilidade demostrada** e **limitacións**. Non deduzas unha CVE, unha recuperación de contrasinal nin unha degradación de seguridade só porque o escenario arranque.


## Verificación da VM finalizada (novembro de 2026)

O despregamento validado é `vagrant up` seguido de `vagrant reload` no anfitrión. A consola gráfica inicia automaticamente como `kali`, o teclado aplica a distribución española tras o reinicio e o servizo de finalización elimina a conta provisional `vagrant` ao cumprírense as condicións. **A sesión de traballo do alumnado non utiliza SSH de Vagrant**.

```bash
whoami
id vagrant
sudo wifilabctl doctor
sudo wifilabctl list
sudo cat /etc/wifilab/finalized
```

## Seguimento das prácticas

Consultar [Control de validación por práctica](SEGUIMENTO-PRACTICAS.md). As observacións recollidas non substitúen a comprobación paso a paso no teu laboratorio.
