# 📘 Documento de Diseño de Software (SDD) — Laboratorio de Simulación de Movimiento Lateral

**Versión:** 1.0  
**Fecha:** 16 de Noviembre de 2026  
**Estado:** Aprobado para implementación

## 1. Introducción y Propósito

Este documento define el diseño técnico completo de un laboratorio de ciberseguridad reproducible y 100% definido como código (IaC). El objetivo principal es **validar si un agente ofensivo autónomo, potenciado por un LLM con API gratuita, puede comprometer una aplicación perimetral y escalar lateralmente hacia un Active Directory (Samba AD) y una base de datos internos**, todo dentro de una única máquina anfitriona con 20 GB de RAM.

## 2. Visión General del Sistema y Topología

La infraestructura se segmenta en cinco zonas de seguridad estrictas, gestionadas por un firewall **VyOS** que actúa como único punto de control entre ellas.

### 2.1. Lista de Equipos Participantes

| Componente | Tipo | Zona | Rol en el Laboratorio | RAM Estimada |
| :--- | :--- | :--- | :--- | :--- |
| **VyOS (Firewall)** | **VM** (libvirt/QEMU) | Borde | Segmentación de red, NAT, firewall por zonas y Suricata (IDS). | ~1.5 GB |
| **Nodo Docker** | **VM** (Linux ligero) | LAN Interna | Host de los contenedores. Aísla los servicios del hipervisor. | ~2 GB (base) |
| **Aplicación Web (Juice Shop)** | **Contenedor** | DMZ | Punto de entrada para el agente ofensivo. | ~0.5 GB |
| **Samba AD DC** | **Contenedor** | LAN Interna | Simula el Active Directory. Primer salto del movimiento lateral (SMB/LDAP). | ~1-1.5 GB |
| **Base de Datos (MySQL/PostgreSQL)** | **Contenedor** | LAN Interna | Objetivo final del movimiento lateral. Solo accesible desde la red interna `db-net`. | ~0.5-1 GB |
| **Kali Linux / PHANTOM** | **Contenedor** | Red de Ataque | Estación de lanzamiento del agente ofensivo autónomo. | ~1 GB |
| **Wazuh (SIEM)** | **Contenedor** | Gestión | Centraliza logs de VyOS, Samba AD y servicios para detectar el movimiento lateral. | ~1-1.5 GB |

## 3. Diseño de Seguridad y Detección

### 3.1. Matriz de Reglas de Firewall para VyOS

VyOS utiliza un firewall basado en zonas. La política por defecto es `drop`.

| # | Origen | Destino | Puerto/Protocolo | Acción | Justificación |
|---|---|---|---|---|---|
| 1 | Attacker | DMZ | TCP/80, TCP/443 | **Allow** | El agente necesita atacar la app web. |
| 2 | **DMZ** | **Internal** | **TCP/389, TCP/445** | **Deny & Log** | **Crítico**: bloquea el movimiento lateral directo desde la app comprometida hacia el AD. |
| 3 | DMZ | Internal | TCP/3306 | **Deny & Log** | Bloquea el intento de la web de hablar con la base de datos. |
| 4 | Internal | DMZ | TCP/80, TCP/443 | **Allow** | La red interna puede consumir servicios de la DMZ. |
| 5 | Internal | WAN | TCP/80, TCP/443, UDP/53 | **Allow** | La LAN necesita salir a internet para actualizaciones. |
| 6 | Attacker | Internal | Cualquiera | **Deny & Log** | Aislamiento del atacante. |
| 7 | Management | Todas | SSH (TCP/22), API | **Allow** | Solo la red de gestión administra. |
| 8 | Cualquiera | Management | Cualquiera | **Deny & Log** | Aislamiento total de la gestión. |

## 4. Diseño de Infraestructura como Código (IaC)

### 4.1. Estructura del Proyecto

```
/tu-proyecto-lab/
├── opencode.json        # Configuración de MCPs
├── AGENTS.md           # Reglas persistentes
├── docs/
│   └── SDD.md          # Este documento
├── terraform/
│   ├── modules/
│   │   ├── vyos-vm/
│   │   └── docker-node/
│   └── environments/lab/
├── ansible/
│   ├── site.yml
│   ├── inventory/
│   └── roles/
├── tests/
├── logs/
│   └── episodic/
└── scripts/
```

### 4.2. Terraform - Principios
- Usar `dmacvicar/libvirt` provider
- `cloud-init` para arranque desatendido
- `outputs` descriptivos y seguros
- Secretos fuera del código (variables de entorno o vault)
- State local seguro (no subir a Git)

### 4.3. Ansible - Principios
- Idempotencia obligatoria
- Variables en `defaults/main.yml`
- Playbook maestro limpio (`site.yml`)
- Secretos con `ansible-vault`
- Usar módulos `vyos.vyos` para firewall

## 5. Estrategia de Testing

| Nivel | Cuándo | Qué valida | Herramientas |
| :--- | :--- | :--- | :--- |
| 1. Estático | Antes de infra | Sintaxis, formato | `terraform fmt -check`, `terraform validate`, `ansible-lint` |
| 2. Plan | Antes de recursos | Qué va a pasar | `terraform plan -out=tfplan` |
| 3. Deploy | Mientras se desplaza | Servicios configurados | Molecule, Terratest |
| 4. Smoke | Post-despliegue | Sistema "vivo" | Scripts `curl`, `nc`, checks |

## 6. Flujo de Ejecución

1. `terraform apply` - Crea VMs de VyOS y Docker
2. `terraform output -json > inventory.json` - Genera inventario
3. `ansible-playbook -i inventory.json site.yml` - Configura todo

## 7. Memoria Episódica

- Archivo append-only: `logs/episodic/YYYY-MM-DD.md`
- Formato: `## [Timestamp] [tipo] Descripción y razón`

## 8. Checkpoint: No Avanzar sin Validación

Cada módulo/rol debe pasar validación antes de continuar.