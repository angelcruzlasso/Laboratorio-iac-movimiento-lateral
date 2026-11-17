# Laboratorio de Movimiento Lateral

[![Terraform](https://img.shields.io/badge/terraform-%232b2b2b^?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/ansible-%232b2b2b^?logo=ansible)](https://www.ansible.com/)

Laboratorio de ciberseguridad reproducible para validar agentes ofensivos autónomos y detección de movimiento lateral.

## 📋 Arquitectura

### Zonas de Seguridad
- **Management**: Hipervisor, Ansible, SIEM (Wazuh)
- **Attacker**: Kali/Phantom - punto de partida del agente
- **DMZ**: Juice Shop - punto de entrada vulnerable
- **Internal**: Samba AD + Base de Datos - objetivo final
- **WAN**: Salida a internet

### Matriz de Firewall (SDD Section 3.1)
| Origen | Destino | Puerto | Acción |
|--------|---------|--------|--------|
| Attacker | DMZ | 80,443 | ALLOW |
| DMZ | Internal | 389,445 | DENY & LOG |
| DMZ | Internal | 3306 | DENY & LOG |
| Attacker | Internal | * | DENY & LOG |

## 🚀 Quick Start

### Prerequisitos
- Terraform 1.6+
- Ansible 2.14+
- libvirt/QEMU
- VyOS QCOW2 image

### Despliegue

```bash
# 1. Inicializar Terraform
cd terraform/environments/lab
terraform init

# 2. Validar plan (REVIEW MANUALMENTE antes de aplicar)
terraform plan -out=tfplan

# 3. Aplicar solo si plan está correcto
terraform apply tfplan

# 4. Generar inventario para Ansible
terraform output -json > inventory.json

# 5. Ejecutar playbook
cd ../../ansible
ansible-playbook -i inventory.json site.yml

# 6. Verificar con smoke test
cd ../scripts
./smoke-test.sh
```

## 📁 Estructura del Proyecto

```
├── opencode.json        # Configuración OpenCode
├── AGENTS.md           # Reglas persistentes del agente
├── docs/
│   └── SDD.md          # Documento de diseño
├── terraform/
│   ├── modules/        # Módulos reutilizables
│   └── environments/lab/  # Configuración del lab
├── ansible/
│   ├── site.yml        # Playbook maestro
│   └── roles/          # Roles de configuración
├── tests/              # Validaciones
├── scripts/            # Scripts de utilidad
└── logs/episodic/      # Memoria episódica del agente
```

## 🔒 Seguridad

⚠️ **IMPORTANTE**: Este laboratorio está diseñado para fines educativos y de prueba.

- Las contraseñas están en `ansible/group_vars/vault.yml` (cifradas)
- El archivo `terraform.tfstate` NO debe subirse a Git
- Usar siempre `ansible-vault` para secretos

## 🧪 Testing Strategy

1. **Static Validation**: `terraform fmt -check`, `terraform validate`
2. **Plan Review**: Revisión manual del plan antes de aplicar
3. **Incremental Deploy**: Usar `-target` para recursos individuales
4. **Molecule Tests**: Para roles Ansible críticos
5. **Smoke Test**: Validar HTTP 200, puertos, contenedores

## 📚 Documentación

- [SDD.md](docs/SDD.md) - Software Design Document
- [AGENTS.md](AGENTS.md) - Reglas del agente de IA
- [SDD Section 3](docs/SDD.md#31-matriz-de-reglas-de-firewall-para-vyos) - Firewall Rules

## 🐛 Reportar Issues

Usar el comando con `mcp:report` o crear un issue en GitHub con:
1. Descripción del problema
2. Pasos para reproducir
3. Logs relevantes