# Reglas Persistentes para el Agente de IA - Laboratorio Movimiento Lateral

## 🎯 Objetivo del Proyecto
Validar si un agente ofensivo autónomo puede:
1. Comprometer una aplicación perimetral (Juice Shop DVWA)
2. Ejecutar movimiento lateral hacia Active Directory (Samba AD)
3. Escalarse hacia la base de datos interna
4. Todo dentro de un host con 20GB RAM

## 🏗️ Arquitectura por Zonas (VyOS Firewall)
- **Management**: Hipervisor, Ansible, SIEM (Wazuh)
- **Attacker**: Kali/Phantom - punto de partida del agente
- **DMZ**: Juice Shop - punto de entrada
- **Internal**: Samba AD + Base de Datos - objetivo final
- **WAN**: Salida a internet

## 🔒 Reglas de Firewall Prioritarias (Ver SDD.md sección 3.1)
1. Attacker → DMZ: ALLOW (HTTP/HTTPS)
2. DMZ → Internal: DENY & LOG (SMB/LDAP, MySQL)
3. Attacker → Internal: DENY & LOG
4. Management: SOLO acceso SSH/API desde esta zona

## 🧪 Estrategia de Testing - "Fail Fast"
1. **Validación Estática**: `terraform fmt -check`, `terraform validate`, `ansible-lint`
2. **Plan Review**: Revisar manualmente `terraform plan` - NO ejecutar sin revisión
3. **Deploy por Targets**: Usar `-target` para recursos individuales
4. **Molecule Tests**: Para roles Ansible críticos
5. **Smoke Test**: Validar HTTP 200, puertos abiertos, contenedores up

## 📋 Reglas de Implementación
- **Nunca** usar secretos hardcodeados - usar `ansible-vault`
- **Nunca** exponer puertos de Base de Datos/Docker a host
- **SIEM debe** correlacionar logs de VyOS + Samba AD
- **Reglas de deny** deben tener logging habilitado

## 🚀 Comandos Estándar
```bash
# Validación
terraform fmt -check && terraform validate
ansible-lint ansible/roles/*/tasks/*.yml

# Deploy incremental
terraform apply -target=libvirt_network.<name>
terraform apply -target=libvirt_domain.<name>

# Verificación
./scripts/smoke-test.sh
```

## 📝 Memoria Episódica
- Cada sesión crea: `logs/episodic/YYYY-MM-DD.md`
- Formato: `## [Timestamp] [tipo: decision|error|feedback] Descripción`
- NO borrar, solo append

## ✅ Checkpoint: No Avanzar sin Validación
- Cada módulo/rol debe pasar validación antes de continuar
- No crear archivos `.tfstate` ni contenedores sin revisión previa
- El agente debe detenerse y reportar si algo falla la validación