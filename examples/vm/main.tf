data "vault_generic_secret" "vsphere_username" {
  path = var.vault_vsphere_secret_path
}

data "vault_generic_secret" "vsphere_password" {
  path = var.vault_vsphere_secret_path
}

data "vault_generic_secret" "win_password" {
  path = var.vault_win_secret_path
}

data "vault_generic_secret" "ssh_pub_key" {
  path = var.vault_ssh_secret_path
}

data "vault_generic_secret" "password" {
  path = var.vault_domain_admin_secret_path
}

locals {
  win_admin_password  = var.admin_password != null ? var.admin_password : data.vault_generic_secret.win_password.data["win_password"]
  ssh_public_key      = var.ssh_key != null ? var.ssh_key : data.vault_generic_secret.ssh_pub_key.data["ssh_pub_key"]
  win_domain_password = var.domain_password != null ? var.domain_password : data.vault_generic_secret.password.data["password"]

  default_run_once_command_list = var.workgroup != null ? [
    "cmd /c powershell.exe New-LocalUser -Name 'ansible' -Password (ConvertTo-SecureString '${replace(local.win_admin_password, "'", "''")}' -AsPlainText -Force) -FullName 'Ansible' -Description 'Ansible service account'",
    "cmd /c powershell.exe Add-LocalGroupMember -Group 'Administrators' -Member 'ansible'"
  ] : []

  effective_run_once_command_list = length(var.run_once_command_list) > 0 ? var.run_once_command_list : local.default_run_once_command_list
}

module "vm" {
  source                   = "../../" # github.com/eingram-homelab/terraform-mod-vsphere-vm?ref=v0.3.0
  vsphere_datacenter       = var.vsphere_datacenter
  vsphere_compute_cluster  = var.vsphere_compute_cluster
  vsphere_datastore_list   = var.vsphere_datastore_list
  vsphere_network_list     = var.vsphere_network_list
  vm_name_list             = var.vm_name_list
  ip_address_list          = var.ip_address_list
  ip_gateway_list          = var.ip_gateway_list
  dns_suffix_list          = var.dns_suffix_list
  vm_tag_categories        = var.vm_tag_categories
  vm_tags                  = var.vm_tags
  vsphere_template         = var.vsphere_template
  is_windows_image         = var.is_windows_image
  vm_folder_name           = var.vm_folder_name
  domain                   = var.domain
  domain_ou                = var.domain_ou
  domain_user              = var.domain_user
  domain_password          = local.win_domain_password
  admin_password           = local.win_admin_password
  ssh_key                  = local.ssh_public_key
  run_once_command_list    = local.effective_run_once_command_list
  vm_ram                   = var.vm_ram
  vm_cpu                   = var.vm_cpu
  vm_base_disk_size_gb     = var.vm_base_disk_size_gb # Comment to use template size | minumum 62
  vm_efi_secure            = var.vm_efi_secure
  enable_disk_uuid         = var.enable_disk_uuid
  create_vm_permissions    = var.create_vm_permissions
  vm_user_id               = var.vm_user_id
  vm_role_name             = var.vm_role_name
  vm_permissions_propagate = var.vm_permissions_propagate
  vm_storage_policy        = var.vm_storage_policy
  dns_server_list          = var.dns_server_list
  data_disk                = var.data_disk
  nested_hv_enabled        = var.nested_hv_enabled
  sata_controller_count    = var.sata_controller_count
}
