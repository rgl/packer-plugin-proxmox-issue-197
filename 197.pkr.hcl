packer {
  required_plugins {
    # see https://github.com/hashicorp/packer-plugin-proxmox
    proxmox = {
      version = "1.1.7"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/12.4.0/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
}

variable "proxmox_node" {
  type    = string
  default = env("PROXMOX_NODE")
}

source "proxmox-iso" "issue-197" {
  template_name            = "template-issue-197"
  template_description     = "See https://github.com/rgl/debian-vagrant"
  tags                     = "issue-197;template"
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node
  machine                  = "q35"
  bios                     = "ovmf"
  efi_config {
    efi_storage_pool = "local-lvm"
  }
  cpu_type = "host"
  cores    = 2
  memory   = 2 * 1024
  vga {
    type   = "qxl"
    memory = 16
  }
  iso_storage_pool = "local"
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  unmount_iso      = true
  additional_iso_files {
    device           = "ide0"
    iso_storage_pool = "local" # NB without this, packer build fails as described at https://github.com/hashicorp/packer-plugin-proxmox/issues/197.
    iso_url          = var.iso_url
    iso_checksum     = "none"
    unmount          = true
  }
  os           = "l26"
  ssh_username = "vagrant"
  ssh_password = "vagrant"
}

build {
  sources = [
    "source.proxmox-iso.issue-197",
  ]
}
