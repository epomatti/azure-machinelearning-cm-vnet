resource "azurerm_public_ip" "main" {
  name                = "pip-proxy"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "nic-proxy"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "proxy"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  username = "azureuser"
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-proxy"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = local.username
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.main.id]

  custom_data = filebase64("${path.module}/init.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = local.username
    public_key = file("${path.module}/../../keys/ssh_key.pub")
  }

  os_disk {
    name                 = "osdisk-proxy"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [custom_data]
  }
}

resource "azurerm_private_dns_cname_record" "squid" {
  name                = "squid"
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = "${azurerm_linux_virtual_machine.main.name}.${var.zone_name}"
}
