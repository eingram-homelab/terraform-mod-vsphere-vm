variable "vm_name_list" {
    type=list(any)
}

variable "vm_ram" {
}

variable "vm_cpu" {
}

variable "vsphere_datacenter" {
  default = "HomeLab Datacenter"
}

variable "vsphere_compute_cluster" {
  default = "Intel NUC10 Cluster"
}

variable "vsphere_datastore_list" {
    type = list(any)
}

variable "vm_storage_policy" {
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
  default = ""
}

variable "vm_disks_list" {
  default = []
}

variable "esxi_hosts" {
  default = []
}

variable "network_interfaces" {
  description = "vmnics to be used"
  default     = []
}

variable "vsphere_network_list" {
    type = list(any)
}

variable "port_group_name" {
  default = ""
}

variable "vsphere_dvs" {
  default = ""
}

variable "iso_path" {
  default = ""
}

variable "vsphere_hardware_version" {
  default = ""
}

variable "ssh_username" {
  default   = ""
  type      = string
  sensitive = true
}

variable "ssh_password" {
  default   = ""
  type      = string
  sensitive = true
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
  type    = list(any)
  default = []
}

variable "ip_gateway_list" {
  type = list(any)
}

variable "dns_server_list" {
  type = list(any)
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
  default = ""
}

variable "domain" {
  default = ""
}

variable "vm_efi_secure" {
  default = false
}

variable "is_windows_image" {
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

variable "scsi_type" {
  description = "scsi_controller type, acceptable values lsilogic,pvscsi."
  type        = string
  default     = "pvscsi"
}

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
  type        = list
  default     = []
}

variable "enable_disk_uuid" {
  default = false
}

variable "vm_role_name" {
  description = "The name of the vSphere role to assign to the user"
  type        = string
  default     = ""  # Empty default, permission will only be created if a value is provided
}

variable "vm_user_id" {
  description = "The user ID to grant permissions to (format: user@domain or domain\\user)"
  type        = string
  default     = ""  # Empty default, permission will only be created if a value is provided
}

variable "vm_permissions_propagate" {
  description = "Whether to propagate the permission to child objects"
  type        = bool
  default     = false
}
