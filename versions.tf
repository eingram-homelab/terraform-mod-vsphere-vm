terraform {
  required_version = ">= 1.14.0"

  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = ">= 2.16.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.10.1"
    }
  }
}
