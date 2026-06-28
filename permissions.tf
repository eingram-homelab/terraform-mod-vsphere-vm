resource "vsphere_entity_permissions" "vm_permission" {
  count       = var.create_vm_permissions && var.vm_user_id != "" && var.vm_role_name != "" ? length(var.vm_name_list) : 0
  entity_id   = vsphere_virtual_machine.vm[count.index].id
  entity_type = "VirtualMachine"
  permissions {
    user_or_group = var.vm_user_id
    is_group      = false
    role_id       = data.vsphere_role.vm_role[0].id
    propagate     = var.vm_permissions_propagate
  }
}
