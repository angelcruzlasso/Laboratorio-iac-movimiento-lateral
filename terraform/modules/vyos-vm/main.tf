# VyOS VM Module for Lateral Movement Lab
# This module creates a VyOS firewall VM with cloud-init
# Provider: dmacvicar/libvirt 0.7.1

locals {
  cloud_init_user_data = <<-EOT
    #cloud-config
    hostname: ${var.name}
    fqdn: ${var.name}.mgmt.lab
    manage_etc_hosts: true
    
    users:
      - name: admin
        groups: [wheel, sudo]
        shell: /bin/bash
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
        lock_passwd: false
        passwd: ""
    
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
    
    runcmd:
      - [systemctl, enable, networking]
  EOT
}

resource "libvirt_volume" "vyos_os" {
  name   = "${var.name}-os"
  pool   = "default"
  source = var.image_path
}

resource "libvirt_volume" "vyos_disk" {
  name           = "${var.name}-disk"
  pool           = "default"
  base_volume_id = libvirt_volume.vyos_os.id
}

resource "libvirt_cloudinit_disk" "common" {
  name      = "${var.name}-cloudinit.iso"
  pool      = "default"
  user_data = local.cloud_init_user_data
}

resource "libvirt_domain" "vyos" {
  name   = var.name
  memory = var.memory_mb
  vcpu   = var.vcpus

  cloudinit = libvirt_cloudinit_disk.common.id

  disk {
    volume_id = libvirt_volume.vyos_disk.id
  }

  network_interface {
    network_name = var.network_name
    mac          = var.mac_address
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "management_ip" {
  description = "Management IP address for SSH access"
  value       = var.management_ip
  sensitive   = false
}

output "vm_name" {
  description = "Name of the VyOS VM"
  value       = libvirt_domain.vyos.name
  sensitive   = false
}