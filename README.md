This is repo contains a packer template that reproduces the `501 for data too large` error while uploading a iso file with `additional_iso_files`.

See https://github.com/hashicorp/packer-plugin-proxmox/issues/197

# Steps

Set your proxmox details:

```bash
cat >secrets-proxmox.sh <<EOF
export PROXMOX_URL='https://192.168.1.21:8006/api2/json'
export PROXMOX_USERNAME='root@pam'
export PROXMOX_PASSWORD='vagrant'
export PROXMOX_NODE='pve'
EOF
source secrets-proxmox.sh
```

Create the template:

```bash
packer init 197.pkr.hcl
packer build -on-error=abort -timestamp-ui 197.pkr.hcl
```
