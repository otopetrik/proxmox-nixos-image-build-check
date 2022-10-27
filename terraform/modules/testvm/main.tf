terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.6.4"
    }
    http = {
    }
    null = {
    }
  }
}

data "proxmox_virtual_environment_nodes" "available_nodes" {}

resource "proxmox_virtual_environment_vm" "test_vm" {
  node_name   = data.proxmox_virtual_environment_nodes.available_nodes.names[0]
  name        = var.vm_name
  description = "Test VM for template ${var.template_id}"

  started = true

  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 768
  }

  vga {
    type = "serial0"
  }

  network_device {
    bridge = var.network_bridge
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "virtio0"
    size         = 10
  }

  connection {
    type = "ssh"
    host = element(element(self.ipv4_addresses, index(self.network_interface_names, "eth0")), 0)
  }

  initialization {
    datastore_id = var.datastore_id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }
    user_account {
      username = "root"
      keys = var.ssh_keys
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/bin",
      "mkdir -p /root/.config/systemd/user"
    ]
  }
  provisioner "file" {
    source      = "${path.module}/webserver.sh"
    destination = "/root/bin/webserver.sh"
  }
  provisioner "file" {
    source      = "${path.module}/webserver.service"
    destination = "/root/.config/systemd/user/webserver.service"
  }

  # hacky way to start webserver even after reboot
  # (using user unit because '/etc/systemd' is readonly)
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/bin/webserver.sh",
      "systemctl --user enable --now webserver",
      "loginctl enable-linger root"
    ]
  }
}

locals {
  vm_ip = element(element(proxmox_virtual_environment_vm.test_vm.ipv4_addresses, index(proxmox_virtual_environment_vm.test_vm.network_interface_names, "eth0")), 0)
}

data "http" "vminfo" {
  depends_on = [proxmox_virtual_environment_vm.test_vm]
  url        = "http://${local.vm_ip}"
}

# fail if there is not http server running...
resource "null_resource" "guard" {
  provisioner "local-exec" {
    command = contains([200], data.http.vminfo.status_code)
  }
}

locals {
  vm_info = data.http.vminfo.response_body
}

