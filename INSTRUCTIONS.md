# Instrucciones de Despliegue

## Paso 1: Preparar las Imágenes

### Descargar VyOS
```bash
# Descargar VyOS QCOW2
wget -O /var/lib/libvirt/images/vyos-qemu.qcow2 https://cloud.vyos.io/release/vyos-1.5-rolling-202611150107-amd64.qcow2

# Verificar checksum si disponible
sha256sum /var/lib/libvirt/images/vyos-qemu.qcow2
```

### Verificar libvirt está instalado
```bash
virsh list --all
```

## Paso 2: Configurar Credenciales

```bash
# Copiar ejemplo de vault
cp ansible/group_vars/vault.yml.example ansible/group_vars/vault.yml

# Editar contraseñas
nano ansible/group_vars/vault.yml

# Cifrar el archivo
ansible-vault encrypt ansible/group_vars/vault.yml
```

## Paso 3: Validar Antes de Desplegar

```bash
# Validar sintaxis Terraform
cd terraform/environments/lab
terraform fmt -check
terraform validate

# Validar sintaxis Ansible
cd ../../ansible
ansible-lint site.yml --exclude rules/dependency.yml
```

## Paso 4: Planificar y Aplicar Terraform

```bash
# En terraform/environments/lab
terraform init

# GENERAR PLAN Y REVISAR MANUALMENTE
terraform plan -out=tfplan

# Leer el plan antes de aplicar
terraform show tfplan

# Si está correcto, aplicar
terraform apply tfplan

# Obtener IPs para Ansible
terraform output -json > inventory.json
```

## Paso 5: Ejecutar Ansible

```bash
cd ansible
ansible-playbook -i inventory.json site.yml --ask-vault-pass
# O si ya está cifrado:
# ansible-playbook -i inventory.json site.yml --vault-password-file ~/.vault_pass
```

## Paso 6: Ejecutar Smoke Test

```bash
cd tests
./smoke-test.sh
```

## 🛑 Parada de Seguridad

**ANTES DE EJECUTAR `terraform apply`:**
1. Revisa `terraform plan` manualmente
2. Verifica que no se destruirán recursos existentes
3. Asegúrate de tener backup si es necesario

## Destrucción Controlada

```bash
# Previsualizar destrucción
terraform plan -destroy -out=tfplan.destroy

# Aplicar destrucción controlada
terraform apply tfplan.destroy
```

## Solución de Problemas

### Problemas con libvirt provider
- Asegúrate de usar Terraform 1.6+
- Reinicia libvirt si hay errores de conexión
- Verifica permisos de usuario libvirtd

### Problemas con Ansible
- Verifica SSH acceso a las VMs
- Asegúrate de que `inventory.json` está actualizado
- Usa `--check` para dry-run

### Problemas con Docker
- Verifica Docker está instalado en el nodo
- Límite de RAM: 12-14 GB recomendado
- Usa `docker system prune` si hay problemas de espacio