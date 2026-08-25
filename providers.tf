terraform {
  required_version = ">= 1.15.0"

  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.16.0"
    }
  }
}
