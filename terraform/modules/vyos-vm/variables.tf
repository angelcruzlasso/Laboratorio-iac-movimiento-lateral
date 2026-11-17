variable "name" {
  description = "Name of the VyOS VM"
  type        = string
  default     = "vyos-firewall"
}

variable "memory_mb" {
  description = "Memory in megabytes for VyOS VM"
  type        = number
  default     = 1536
}

variable "vcpus" {
  description = "Number of vCPUs for VyOS VM"
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Disk size in GB for VyOS VM"
  type        = number
  default     = 8
}

variable "management_ip" {
  description = "Static IP for VyOS management interface"
  type        = string
  default     = "192.168.100.10"
}

variable "image_path" {
  description = "Path to VyOS QCOW2 image"
  type        = string
}

variable "network_name" {
  description = "Name of the libvirt network to attach"
  type        = string
  default     = "default"
}

variable "mac_address" {
  description = "MAC address for the VM network interface"
  type        = string
  default     = "52:54:00:12:34:56"
}