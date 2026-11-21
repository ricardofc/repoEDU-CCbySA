# Seguimento das prácticas na VM do laboratorio

**Método:** seguir literalmente cada guía MkDocs na VM Kali finalizada, anotar comandos, saída e evidencia; decidir `PASS`, `WARN`, `FAIL` ou `SKIP`. Cómpre comprobar cada resultado na propia sesión.

| Práctica | Escenario | Comprobación mínima | Estado da práctica |
|---|---|---|---|
| 1.1 — WPA2-PSK | `psk` | Conexión e EAPOL M1–M4 | FUNCIONAL (comprobado) |
| 1.2 — Desautenticación | `psk` | Desconexión, reconexión, tramas non protexidas | PENDENTE |
| 1.3 — PMF | `psk_pmf` | MFPC/MFPR, comportamento ante deauth | PENDENTE |
| 1.4 — PMKID | `psk` | EAPOL e clasificación `WPA*01`/`WPA*02` | PENDENTE, resultado condicional |
| 2.1 — WPA2-Enterprise | `eap_evil_twin` | PEAP, FreeRADIUS Access-Accept, EAPOL | PENDENTE |
| 2.2 — Evil Twin | `eap_evil_twin` | CA válida vs CA desactivada, sesión controlada | PENDENTE |
| 2.3 — MITM | `eap_mitm` | MANA AP-ENABLED, ponte, cliente e límites | PENDENTE |
| 3.1 — SAE | `wpa3_sae` | SAE Commit/Confirm, 4-way, PMF | PENDENTE |
| 3.2 — KRACK | `wpa3_sae` | Análise de protocolo e limitacións; non inferir CVE | PENDENTE |
| 3.3 — Transición | `wpa3_sae_vulnerable` | SAE/PSK, Beacon AKM e MFPC/MFPR | PENDENTE |

A primeira guía para executar é [Práctica 1.1](1.1-ATAQUE_WPA2_PSK.md). Gardar as evidencias e revisar as diferenzas coa documentación antes de pasar á seguinte.
