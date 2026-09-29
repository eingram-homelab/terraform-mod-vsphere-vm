vsphere_server          = "vcsa-2.company.ycdisp.com"
vsphere_datacenter      = "HomeLab Datacenter 2"
vsphere_compute_cluster = "AMD R7 Cluster"
allow_unverified_ssl    = true

vsphere_datastore_list = ["vsanDatastore"] # must align with vm_name_list order
vm_storage_policy      = "vSAN - No Fault Tolerance"
vsphere_network_list = [ # must align with vm_name_list order; 
  ["DPG-Lab-LAN2"]
]
vm_name_list         = ["vm1", "vm2"]
vm_ram               = 4096
vm_cpu               = 2
vm_base_disk_size_gb = [62]
vm_efi_secure        = false

ip_address_list = ["10.20.0.203", "10.20.0.204"] # must align with vm_name_list order
ip_gateway_list = ["10.20.0.1", "10.20.0.1"]     # must align with vm_name_list order

# Set for ALL VMs
dns_suffix_list = ["ycdisp.net"]
dns_server_list = ["192.168.1.251", "192.168.1.250"]

# Set domain or workgroup
# domain    = "company.ycdisp.com"
# domain_ou = "OU=Hyper-V,OU=Clusters,OU=Servers,OU=Computers,OU=Company,DC=company,DC=ycdisp,DC=com"
workgroup = "WORKGROUP"

# Uncomment domain_* for domain only
# domain_user = "admin"
# domain_password = data.vault_generic_secret.password.data["password"]

# Optional overrides (leave null to use Vault-backed defaults from main.tf)
admin_password = null
ssh_key        = null

# Enable nested virtualization
nested_hv_enabled = false

vm_tag_categories = ["Environment"]
vm_tags           = ["stg"]

vsphere_template = "TMP-Rocky10_Packer"
is_windows_image = false
vm_folder_name   = "Linux"

# Optional override. Leave empty to use default commands from main.tf
# run_once_command_list = []

# data_disk = {
#   disk1 = {
#     size_gb          = 100,
#     thin_provisioned = true
#     controller_type  = "sata"
#   }
# disk2 = {
#   size_gb          = 100,
#   thin_provisioned = true
#   controller_type  = "sata"
# }
# disk3 = {
#   size_gb          = 100,
#   thin_provisioned = true
#   controller_type  = "sata"
# }
# disk4 = {
#   size_gb          = 100,
#   thin_provisioned = true
#   controller_type  = "sata"
# }
# }

enable_disk_uuid = true

# Set this options to true for k8s nodes using vSphere CSI
create_vm_permissions = false

# If enabling the above, must set these options to create a user and role for the VM to use for CSI
# vm_user_id               = "company\\vsphere-csi"
# vm_role_name             = "CNS-VM"
# vm_permissions_propagate = false
