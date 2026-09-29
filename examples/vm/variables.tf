variable "vault_vsphere_secret_path" {
  description = "Vault path containing vSphere credentials."
  type        = string
  default     = "secret/vsphere/vcsa"
}

variable "vault_ssh_secret_path" {
  description = "Vault path containing SSH credentials and keys."
  type        = string
  default     = "secret/ssh/ansible"
}

variable "vault_win_secret_path" {
  description = "Vault path containing Windows administrator credentials."
  type        = string
  default     = "secret/win/administrator"
}

variable "vault_domain_admin_secret_path" {
  description = "Vault path containing domain admin credentials."
  type        = string
  default     = "secret/win/ycdisp.com"
}

variable "vsphere_server" {
  description = "vSphere server endpoint."
  type        = string
  default     = "vcsa-1.local.lan"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter name."
  type        = string
  default     = ""
}

variable "vsphere_compute_cluster" {
  description = "vSphere compute cluster name."
  type        = string
  default     = "AMD R7 Cluster"
}

variable "allow_unverified_ssl" {
  description = "Allow insecure TLS when connecting to vSphere."
  type        = bool
  default     = true
}

variable "vsphere_datastore_list" {
  description = "Datastore per VM (must align with vm_name_list order)."
  type        = list(string)
  default     = []
}

variable "vsphere_network_list" {
  description = "List of network name lists, one entry per VM (must align with vm_name_list order). Each inner list defines the networks, in order, attached as virtual NICs to that VM."
  type        = list(list(string))
  default     = []
}

variable "vm_name_list" {
  description = "VM names to deploy."
  type        = list(string)
  default     = []
}

variable "ip_address_list" {
  description = "IP addresses per VM (must align with vm_name_list order)."
  type        = list(string)
  default     = []
}

variable "ip_gateway_list" {
  description = "Default gateway per VM (must align with vm_name_list order)."
  type        = list(string)
  default     = []
}

variable "dns_suffix_list" {
  description = "DNS suffixes applied to guests."
  type        = list(string)
  default     = []
}

variable "vm_tag_categories" {
  description = "Tag categories to apply to deployed VMs."
  type        = list(string)
  default     = ["Environment"]
}

variable "vm_tags" {
  description = "Tags to apply to deployed VMs."
  type        = list(string)
  default     = []
}

variable "vsphere_template" {
  description = "Template name used to clone VMs."
  type        = string
  default     = ""
}

variable "is_windows_image" {
  description = "Set true when using a Windows template."
  type        = bool
  default     = false
}

variable "vm_folder_name" {
  description = "VM folder in vSphere inventory."
  type        = string
  default     = ""
}

variable "workgroup" {
  description = "Workgroup name to use for Windows VMs (leave empty for domain)."
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain name to join (or leave empty if using workgroup behavior in module)."
  type        = string
  default     = ""
}

variable "domain_ou" {
  description = "Domain OU to join (or leave empty if using workgroup behavior in module)."
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "Optional override for admin password. If null, value is read from Vault."
  type        = string
  default     = null
  sensitive   = true
}

variable "domain_user" {
  description = "Domain user to join domain (leave empty if using workgroup behavior in module)."
  type        = string
  default     = ""
}

variable "domain_password" {
  description = "Domain user password to join domain (leave empty if using workgroup behavior in module)."
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_key" {
  description = "Optional override for SSH public key. If null, value is read from Vault."
  type        = string
  default     = null
  sensitive   = true
}

variable "run_once_command_list" {
  description = "Windows first-boot command list (workgroup use case)."
  type        = list(string)
  default     = []
}

variable "vm_ram" {
  description = "VM memory size in MB."
  type        = number
}

variable "vm_cpu" {
  description = "Number of vCPUs per VM."
  type        = number
}

variable "vm_base_disk_size_gb" {
  description = "OS disk size in GB. Use empty list to keep template disk size if supported by module."
  type        = list(number)
  default     = [62]
}

variable "vm_efi_secure" {
  description = "Enable EFI secure boot."
  type        = bool
  default     = false
}

variable "enable_disk_uuid" {
  description = "Enable disk UUID, often required for Kubernetes CSI."
  type        = bool
  default     = false
}

variable "create_vm_permissions" {
  description = "Enable creation of VM entity permissions in vSphere."
  type        = bool
  default     = false
}

variable "vm_user_id" {
  description = "vSphere principal to assign VM role permissions."
  type        = string
  default     = "vsphere.local\\csi"
}

variable "vm_role_name" {
  description = "vSphere role to assign to vm_user_id."
  type        = string
  default     = "CNS-VM"
}

variable "vm_permissions_propagate" {
  description = "Whether assigned permissions propagate to child objects."
  type        = bool
  default     = false
}

variable "vm_storage_policy" {
  description = "Storage policy name for VM disks."
  type        = string
  default     = ""
}

variable "dns_server_list" {
  description = "DNS server list used by guest customization."
  type        = list(string)
  default = [
    "192.168.1.251",
    "192.168.1.250"
  ]
}

variable "data_disk" {
  description = "Optional additional disk map consumed by the vm module."
  type        = map(map(string))
  default     = {}
}

variable "nested_hv_enabled" {
  description = "Enable nested virtualization for VMs."
  type        = bool
  default     = false
}

variable "sata_controller_count" {
  description = "Number of SATA controllers to create for the VM. Each controller can support up to 30 disks."
  type        = number
  default     = 1
}
