variable "lab_name" {
  description = "Name of the lab environment"
  type        = string
  default     = "lateral-movement-lab"
}

variable "vyos_image_path" {
  description = "Path to VyOS QCOW2 image"
  type        = string
  default     = "/var/lib/libvirt/images/vyos-qemu.qcow2"
}

variable "vyos_memory" {
  description = "Memory in MB for VyOS VM"
  type        = number
  default     = 1536
}

variable "docker_node_memory" {
  description = "Memory in MB for Docker node"
  type        = number
  default     = 3072
}

variable "management_node_memory" {
  description = "Memory in MB for Management node"
  type        = number
  default     = 2048
}