# Scripts de Utilidad

## smoke-test.sh

Script de validación que verifica:

- VyOS firewall accesible
- Juice Shop responde HTTP 200
- Contenedores Docker corriendo (samba, mysql, kali)
- Puertos de base de datos NO expuestos al host
- Firewall reglas cargadas

**Uso:**
```bash
./scripts/smoke-test.sh
# Salida: PASS/FAIL count, exit 0 si todo OK
```

## create_networks.sh

Crea las redes libvirt necesarias para el lab:

| Red | CIDR | Propósito |
|-----|------|-----------|
| mgmt_net | 192.168.100.0/24 | VyOS Management |
| dmz_net | 10.0.10.0/24 | Juice Shop |
| attacker_net | 10.0.30.0/24 | Kali/Phantom |
| internal_net | 10.0.20.0/24 | Samba AD + MySQL |

**Uso:**
```bash
sudo ./scripts/create_networks.sh
# Crea y activa todas las redes
```

## vault_pass.sh

Script para gestionar la contraseña del vault (opcional):
```bash
# Generate vault password file
echo "my_secure_password" > ~/.vault_pass
chmod 600 ~/.vault_pass

# Then use with ansible-playbook
ansible-playbook -i inventory.json site.yml --vault-password-file ~/.vault_pass
```