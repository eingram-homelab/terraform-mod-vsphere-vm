terraform {
  required_version = ">= 1.5.0"
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.16.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.11.0"
    }
  }
}

provider "vsphere" {
  user                 = data.vault_generic_secret.vsphere_username.data["vsphere_username"]
  password             = data.vault_generic_secret.vsphere_password.data["vsphere_password"]
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

provider "vault" {
}
