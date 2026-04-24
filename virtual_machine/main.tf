data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  count         = length(var.vsphere_datastore_list)
  name          = element(var.vsphere_datastore_list, count.index)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_storage_policy" "storage_policy" {
  name = var.vm_storage_policy
}
data "vsphere_datastore" "disk_datastore" {
  count         = var.disk_datastore != "" ? 1 : 0
  name          = var.disk_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  count         = length(var.vsphere_network_list)
  name          = element(var.vsphere_network_list, count.index)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_tag_category" "category" {
  count = length(var.vm_tag_categories)
  name  = element(var.vm_tag_categories, count.index)
}

data "vsphere_tag" "tag" {
  count = length(var.vm_tags)
  name  = element(var.vm_tags, count.index)
  category_id = data.vsphere_tag_category.category[count.index].id
}

locals {
  # interface_count     = length(var.ipv4submask) #Used for Subnet handling
  template_disk_count = length(data.vsphere_virtual_machine.template.disks)
}

resource "vsphere_virtual_machine" "vm" {

  count = length(var.vm_name_list)
  name  = element(var.vm_name_list, count.index)

  resource_pool_id        = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id            = data.vsphere_datastore.datastore[count.index].id
  storage_policy_id       = data.vsphere_storage_policy.storage_policy.id
  folder                  = "/HomeLab Datacenter/vm/${var.vm_folder_name}"
  firmware                = "efi"
  efi_secure_boot_enabled = var.vm_efi_secure
  tags                    = data.vsphere_tag.tag[*].id
  num_cpus                = var.vm_cpu
  memory                  = var.vm_ram
  memory_reservation      = var.vm_ram
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  scsi_type               = data.vsphere_virtual_machine.template.scsi_type
  hardware_version        = data.vsphere_virtual_machine.template.hardware_version
  enable_disk_uuid        = var.enable_disk_uuid ? "true" : "false"

  network_interface {
    network_id   = data.vsphere_network.network[count.index].id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label             = length(var.disk_label) > 0 ? var.disk_label[template_disks.key] : "disk${template_disks.key}"
      size              = var.vm_base_disk_size_gb != null ? var.vm_base_disk_size_gb[template_disks.key] : data.vsphere_virtual_machine.template.disks[template_disks.key].size
      unit_number       = var.scsi_controller != null ? var.scsi_controller * 15 + template_disks.key : template_disks.key
      thin_provisioned  = data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
      # datastore_id      = var.disk_datastore != "" ? data.vsphere_datastore.disk_datastore[0].id : null
      storage_policy_id = data.vsphere_storage_policy.storage_policy.id
    }
  }

  dynamic "disk" {
    for_each = var.data_disk
    iterator = terraform_disks
    content {
      label = terraform_disks.key
      size  = lookup(terraform_disks.value, "size_gb", null)
      unit_number = (
        lookup(
          terraform_disks.value,
          "unit_number",
          -1
          ) < 0 ? (
          lookup(
            terraform_disks.value,
            "data_disk_scsi_controller",
            0
            ) > 0 ? (
            (terraform_disks.value.data_disk_scsi_controller * 15) +
            index(keys(var.data_disk), terraform_disks.key) +
            (var.scsi_controller == tonumber(terraform_disks.value["data_disk_scsi_controller"]) ? local.template_disk_count : 0)
            ) : (
            index(keys(var.data_disk), terraform_disks.key) + local.template_disk_count
          )
          ) : (
          tonumber(terraform_disks.value["unit_number"])
        )
      )
      thin_provisioned  = lookup(terraform_disks.value, "thin_provisioned", "true")
      # eagerly_scrub     = lookup(terraform_disks.value, "eagerly_scrub", "false")
      # datastore_id      = lookup(terraform_disks.value, "datastore_id", null)
      storage_policy_id = lookup(terraform_disks.value, "vsphere_storage_policy_id", null)
      # io_reservation    = lookup(terraform_disks.value, "io_reservation", null)
      # io_share_level    = lookup(terraform_disks.value, "io_share_level", "normal")
      # io_share_count    = lookup(terraform_disks.value, "io_share_level", null) == "custom" ? lookup(terraform_disks.value, "io_share_count") : null
      # disk_mode         = lookup(terraform_disks.value, "disk_mode", null)
      # disk_sharing      = lookup(terraform_disks.value, "disk_sharing", null)
      # attach            = lookup(terraform_disks.value, "attach", null)
      # path              = lookup(terraform_disks.value, "path", null)
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      dynamic "windows_options" {
        for_each = var.is_windows_image ? [1] : []
        content {
          computer_name         = element(var.vm_name_list, count.index)
          admin_password        = var.admin_password
          full_name             = var.full_name
          organization_name     = var.organization_name
          auto_logon            = true
          time_zone             = var.time_zone
          join_domain           = var.domain != "" ? var.domain : null
          domain_admin_user     = var.domain_user != "" ? var.domain_user : null
          domain_admin_password = var.domain_password != "" ? var.domain_password : null
          workgroup             = var.workgroup != "" ? var.workgroup : null
          run_once_command_list = length(var.run_once_command_list) > 0 ? var.run_once_command_list : null
        }
      }

      dynamic "linux_options" {
        for_each = var.is_windows_image ? [] : [1]
        content {
          host_name = element(var.vm_name_list, count.index)
          domain = element(var.dns_suffix_list, count.index)
          script_text = <<-EOT
            #!/bin/sh
            if [ x$1 = x"precustomization" ]; then
              echo "Do Precustomization tasks"
              usermod -p $(openssl passwd -1 ${var.admin_password}) root
              useradd -p $(openssl passwd -1 ${var.admin_password}) ansible
              echo 'ansible ALL=(ALL:ALL) NOPASSWD: ALL' | tee /etc/sudoers.d/ansible
              mkdir /home/ansible/.ssh
              chown ansible:ansible /home/ansible/.ssh
              chmod 755 /home/ansible/.ssh
              touch /home/ansible/.ssh/authorized_keys
              chown ansible:ansible /home/ansible/.ssh/authorized_keys
              chmod 600 /home/ansible/.ssh/authorized_keys
              echo '${var.ssh_key}' >> /home/ansible/.ssh/authorized_keys
            elif [ x$1 = x"postcustomization" ]; then
              echo "Do Postcustomization tasks"
            fi
          EOT
        }
      }

      network_interface {
        ipv4_address = length(var.ip_address_list) > 0 ? element(var.ip_address_list, count.index) : null
        ipv4_netmask = length(var.ip_address_list) > 0 ? 24 : null
        dns_domain = length(var.ip_address_list) > 0 ? element(var.dns_suffix_list, count.index) : null
      }
      ipv4_gateway    = length(var.ip_address_list) > 0 ? element(var.ip_gateway_list, count.index) : null
      dns_server_list = length(var.dns_server_list) > 0 ? var.dns_server_list : null
      dns_suffix_list = var.dns_suffix_list
    }
  }

  lifecycle {
    ignore_changes = [
      clone[0].template_uuid,
      disk
    ]
  }
}

data "vsphere_role" "vm_role" {
  count = var.vm_role_name != "" ? 1 : 0
  label = var.vm_role_name
}

resource "vsphere_entity_permissions" "vm_permission" {
  count       = var.vm_user_id != "" && var.vm_role_name != "" ? length(var.vm_name_list) : 0
  entity_id   = vsphere_virtual_machine.vm[count.index].id
  entity_type = "VirtualMachine"
  permissions {
    user_or_group = var.vm_user_id
    is_group      = false
    role_id       = data.vsphere_role.vm_role[0].id
    propagate     = var.vm_permissions_propagate
  }
}
