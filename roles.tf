data "vsphere_role" "vm_role" {
  count = var.create_vm_permissions && var.vm_role_name != "" ? 1 : 0
  label = var.vm_role_name
}
