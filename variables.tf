variable "vm_name_list" {
  type = list(any)
}

variable "vm_ram" {
  type = number
}

variable "vm_cpu" {
  type = number
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_compute_cluster" {
  type = string
}

variable "vsphere_datastore_list" {
  type = list(any)
}

variable "vm_storage_policy" {
  type    = string
  default = ""
}

variable "vm_tag_categories" {
  type = list(string)
}
variable "vm_tags" {
  type = list(string)
}
variable "vsphere_template" {
  type = string
}

variable "vm_folder_name" {
  type    = string
  default = ""
}

variable "vsphere_network_list" {
  description = "List of network name lists, one entry per VM (matching vm_name_list order). Each inner list defines the networks, in order, attached as virtual NICs to that VM."
  type        = list(list(string))
}

variable "ssh_key" {
  default   = ""
  type      = string
  sensitive = true
}

variable "domain_user" {
  default   = ""
  type      = string
  sensitive = true
}

variable "domain_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "admin_password" {
  default   = ""
  type      = string
  sensitive = true
}

variable "ip_address_list" {
  description = "Per-VM IPv4 addresses. Use \"dhcp\" for any VM that should skip static IPv4 customization."
  type        = list(any)
  default     = []
}

variable "ip_gateway_list" {
  type = list(any)
}

variable "dns_server_list" {
  type    = list(any)
  default = []
}

variable "dns_suffix_list" {
  type    = list(any)
  default = []
}

variable "full_name" {
  type    = string
  default = "Edward Ingram"
}

variable "organization_name" {
  type    = string
  default = "HomeLab"
}

variable "time_zone" {
  type    = string
  default = "004"
}

variable "workgroup" {
  type    = string
  default = ""
}

variable "domain" {
  type    = string
  default = ""
}

variable "domain_ou" {
  type    = string
  default = ""
}

variable "vm_efi_secure" {
  type    = bool
  default = false
}

variable "is_windows_image" {
  type    = bool
  default = false
}

variable "data_disk" {
  description = "Storage data disk parameter, example"
  type        = map(map(string))
  default     = {}
}

variable "disk_label" {
  description = "Storage data disk labels."
  type        = list(any)
  default     = []
}

variable "vm_base_disk_size_gb" {
  description = "List of disk sizes to override template disk size."
  type        = list(any)
  default     = null
}

variable "disk_datastore" {
  description = "Define where the OS disk should be stored."
  type        = string
  default     = ""
}

# variable "template_storage_policy_id" {
#   description = "List of UUIDs of the storage policy to assign to the template disk."
#   type        = list(any)
#   default     = []
# }

variable "scsi_controller" {
  description = "scsi_controller number for the main OS disk."
  type        = number
  default     = 0
  # validation {
  #   condition     = var.scsi_controller < 4 && var.scsi_controller > -1
  #       error_message = "The scsi_controller must be between 0 and 3"
  # }
}

variable "run_once_command_list" {
  type    = list(any)
  default = []
}

variable "enable_disk_uuid" {
  type    = bool
  default = false
}

variable "create_vm_permissions" {
  description = "Enable creation of VM entity permissions."
  type        = bool
  default     = true
}

variable "vm_role_name" {
  description = "The name of the vSphere role to assign to the user"
  type        = string
  default     = "" # Empty default, permission will only be created if a value is provided
}

variable "vm_user_id" {
  description = "The user ID to grant permissions to (format: user@domain or domain\\user)"
  type        = string
  default     = "" # Empty default, permission will only be created if a value is provided
}

variable "vm_permissions_propagate" {
  description = "Whether to propagate the permission to child objects"
  type        = bool
  default     = false
}

variable "nested_hv_enabled" {
  description = "Enable nested virtualization for VMs."
  type        = bool
  default     = false
}

variable "sata_controller_count" {
  description = "Number of SATA controllers to add to the VM."
  type        = number
  default     = 0
}