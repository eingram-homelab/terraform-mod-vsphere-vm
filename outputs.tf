output "name" {
  description = "VM Names"
  value       = vsphere_virtual_machine.vm.*.name
}

output "default_ip_address" {
  description = "default ip address of the deployed VM"
  value       = vsphere_virtual_machine.vm.*.default_ip_address
}

output "guest_ip_addresses" {
  description = "all the registered ip address of the VM"
  value       = vsphere_virtual_machine.vm.*.guest_ip_addresses
}


output "uuid" {
  description = "UUID of the VM in vSphere"
  value       = vsphere_virtual_machine.vm.*.uuid
}

output "disk" {
  description = "Disks of the deployed VM"
  value       = vsphere_virtual_machine.vm.*.disk
}

output "domain" {
  description = "Domain suffix of the VM in vSphere"
  value       = vsphere_virtual_machine.vm[0].clone[0].customize[0].dns_suffix_list[0]
}