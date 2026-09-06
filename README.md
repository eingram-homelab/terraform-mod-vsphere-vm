# terraform-mod-vsphere-vm

A Terraform module for provisioning Windows or Linux virtual machines in vSphere from an existing template, using the [`vmware/vsphere`](https://registry.terraform.io/providers/vmware/vsphere/latest) provider.

The module clones one or more VMs from a template, customizes networking/domain join (Windows) or cloud-init/network settings (Linux), attaches additional data disks, and optionally assigns vSphere role-based permissions on the created VMs.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.15.0 |
| vsphere provider | ~> 2.16.0 |

## Usage

Reference the module from its git source and pin to a released tag (see [CHANGELOG.md](CHANGELOG.md) for available versions):

```hcl
module "vm" {
  source = "git::https://github.com/eingram-homelab/terraform-mod-vsphere-vm.git?ref=v0.1.0"

  # Required
  vm_name_list             = ["my-vm-01"]
  vm_ram                   = 8192
  vm_cpu                   = 4
  vsphere_datacenter       = "Datacenter1"
  vsphere_compute_cluster  = "Cluster1"
  vsphere_datastore_list   = ["datastore1"]
  vsphere_network_list     = ["VM Network"]
  vsphere_template         = "rocky9-template"
  vm_tag_categories        = ["environment"]
  vm_tags                  = ["prod"]
  ip_gateway_list          = ["10.0.0.1"]

  # Optional (commonly set)
  ip_address_list  = ["10.0.0.10"]
  dns_server_list  = ["10.0.0.2"]
  dns_suffix_list  = ["example.com"]
  is_windows_image = false
  vm_folder_name   = "vms/linux"
}
```

You can also reference the default branch instead of a tag with `?ref=main`, though pinning to a tag is recommended for reproducible builds.

## Inputs

### Required

| Name | Description |
|------|-------------|
| `vm_name_list` | List of VM names to create. One VM is created per list item. |
| `vm_ram` | Amount of RAM (MB) to assign to each VM. |
| `vm_cpu` | Number of vCPUs to assign to each VM. |
| `vsphere_datacenter` | Name of the vSphere datacenter to deploy into. |
| `vsphere_compute_cluster` | Name of the vSphere compute cluster to deploy into. |
| `vsphere_datastore_list` | List of datastore names to use, one per VM (by index). |
| `vsphere_network_list` | List of network/port group names to attach, one per VM (by index). |
| `vsphere_template` | Name of the source template to clone the VM(s) from. |
| `vm_tag_categories` | List of vSphere tag category names to apply to the VM(s). |
| `vm_tags` | List of vSphere tag names to apply to the VM(s). |
| `ip_gateway_list` | List of IPv4 gateway addresses, one per VM (by index). |

### Optional

| Name | Default | Description |
|------|---------|-------------|
| `vm_storage_policy` | `""` | Name of the vSphere storage policy to apply to the VM. |
| `vm_folder_name` | `""` | vSphere folder path to place the VM(s) in. |
| `ssh_key` | `""` | SSH public key to inject into Linux VMs. |
| `domain_user` | `""` | Username used to join the VM to a domain. |
| `domain_password` | `""` | Password used to join the VM to a domain. |
| `admin_password` | `""` | Local administrator/root password to set on the VM. |
| `ip_address_list` | `[]` | Per-VM IPv4 addresses. Use `"dhcp"` for any VM that should skip static IPv4 customization. |
| `dns_server_list` | `[]` | List of DNS server IP addresses to configure. |
| `dns_suffix_list` | `[]` | List of DNS search suffixes to configure. |
| `full_name` | `"Edward Ingram"` | Registered owner full name (Windows sysprep). |
| `organization_name` | `"HomeLab"` | Registered owner organization (Windows sysprep). |
| `time_zone` | `"004"` | Windows time zone index (sysprep). |
| `workgroup` | `""` | Windows workgroup name, used when not joining a domain. |
| `domain` | `""` | Domain name to join the VM to. |
| `domain_ou` | `""` | Organizational unit (OU) to place the VM in when domain-joining. |
| `vm_efi_secure` | `false` | Whether to enable EFI secure boot on the VM. |
| `is_windows_image` | `false` | Set to `true` when cloning a Windows template so Windows-specific customization is applied instead of Linux. |
| `data_disk` | `{}` | Map of additional data disk definitions (size, unit number, etc.) to attach beyond the template's disks. |
| `disk_label` | `[]` | Labels to assign to the template's disks, overriding the auto-generated `disk<n>` labels. |
| `vm_base_disk_size_gb` | `null` | List of disk sizes (GB) to override the template's disk sizes. Leave `null` to keep the template size. |
| `disk_datastore` | `""` | Name of a datastore to place the OS disk on, if different from the VM's primary datastore. |
| `scsi_controller` | `0` | SCSI controller number used for the main OS disk. |
| `run_once_command_list` | `[]` | List of commands to run once on first boot (Windows sysprep RunOnce). |
| `enable_disk_uuid` | `false` | Whether to expose the disk UUID to the guest OS. |
| `create_vm_permissions` | `true` | Whether to create a vSphere role assignment (permission) on the VM. |
| `vm_role_name` | `""` | Name of the vSphere role to assign. Permission is only created if this and `vm_user_id` are set. |
| `vm_user_id` | `""` | User or group to grant the role to, in the form `user@domain` or `domain\user`. |
| `vm_permissions_propagate` | `false` | Whether the granted permission propagates to child objects. |

## Outputs

| Name | Description |
|------|-------------|
| `name` | Names of the deployed VM(s). |
| `default_ip_address` | Default IP address of each deployed VM. |
| `guest_ip_addresses` | All registered guest IP addresses of each VM. |
| `uuid` | vSphere UUID of each VM. |
| `disk` | Disk configuration of each VM. |
| `domain` | DNS suffix configured on the first VM. |