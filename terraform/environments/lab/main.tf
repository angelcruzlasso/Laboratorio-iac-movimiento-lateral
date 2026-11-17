terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "= 0.7.1"
    }
  }
  backend "local" {}
}

# Nota: Para redes aisladas con CIDR específicos, se requiere network XML definitions
# Aquí usamos redes existentes o las definiremos manualmente

# VyOS Firewall - red management
module "vyos_firewall" {
  source = "../../modules/vyos-vm"

  name          = "vyos-firewall"
  memory_mb     = var.vyos_memory
  vcpus         = 1
  disk_size_gb  = 8
  management_ip = "192.168.100.10"
  image_path    = var.vyos_image_path
  network_name  = "default"
}

# Output IPs for Ansible inventory
output "management_network" {
  value = "192.168.100.0/24"
}

output "dmz_network" {
  value = "10.0.10.0/24"
}

output "internal_network" {
  value = "10.0.20.0/24"
}

output "attacker_network" {
  value = "10.0.30.0/24"
}

output "vyos_management_ip" {
  value = "192.168.100.10"
  description = "IP de gestión del firewall VyOS para SSH"
  sensitive   = false
}