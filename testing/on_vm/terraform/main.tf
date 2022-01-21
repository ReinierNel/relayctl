# Setup Network

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-testing"
  location            = var.location
  resource_group_name = var.rg
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "testing"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  name                = "${var.name}testing"
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-testing"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = azurerm_subnet.name.id
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.name}-testing"
  resource_group_name = var.rg
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "pi"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "pi"
    public_key = var.SSH_PUB_KEY
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "pi"
    private_key = file("ssh-pri-key")
    host        = azurerm_public_ip.pubip.ip_address
  }

  provisioner "file" {
    source      = "../../../setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/setup.sh",
      "sudo bash /tmp/setup.sh --silent",
    ]
  }
}

