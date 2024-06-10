# Провайдер Azure
provider "azurerm" {
  features {}
}

# Група ресурсів
resource "azurerm_resource_group" "k8s_rg" {
  name     = "dev-team-k8s-rg"
  location = "westus2"

  tags = {
    Environment = "dev"
    Team        = "dev-team"
  }
}

# Віртуальна мережа
resource "azurerm_virtual_network" "k8s_vnet" {
  name                = "dev-team-k8s-vnet"
  location            = azurerm_resource_group.k8s_rg.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.k8s_rg.name

  tags = {
    Environment = "dev"
    Team        = "dev-team"
  }
}

# Підмережа для Kubernetes
resource "azurerm_subnet" "k8s_subnet" {
  name                 = "dev-team-k8s-subnet"
  virtual_network_name = azurerm_virtual_network.k8s_vnet.name
  resource_group_name  = azurerm_resource_group.k8s_rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Публічна IP-адреса
resource "azurerm_public_ip" "k8s_public_ip" {
  name                = "k8s-public-ip"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  allocation_method   = "Dynamic"

  tags = {
    Environment = "dev"
    Team        = "dev-team"
  }
}

# Мережевий інтерфейс
resource "azurerm_network_interface" "k8s_nic" {
  name                = "k8s-nic"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s_public_ip.id
  }

  tags = {
    Environment = "dev"
    Team        = "dev-team"
  }
}

# Віртуальна машина Kubernetes
resource "azurerm_linux_virtual_machine" "k8s_vm" {
  name                  = "dev-team-k8s-vm"
  location              = azurerm_resource_group.k8s_rg.location
  resource_group_name   = azurerm_resource_group.k8s_rg.name
  network_interface_ids = [azurerm_network_interface.k8s_nic.id]
  size                  = "Standard_D2_v2"
  admin_username        = "adminuser"
  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo59wVAdZP4oepKlfU7pEd7PhJb2BK2apMp/1XuYh+n0RrtqAv1qyM0OG/YA7ZHlQoh2QhFTKuGw/nMBjK5adGXrBZATMt6gxSsqpct9gfNMuw568/MH0Jf+XccqcaIMzb8cHKWv3h6sDTJRmJg2UgMhu0FfbEuzLD2PjIZZ39+eAKvZq/ovp4R4RAnG+5yHO6s98kgI4PxXop+wCMJOa3M4FxSFNDDQiW4Ohhs+qKx5cHelX8N73r5lAdFwf95l1xwnbE9KPUjDp2K83eZMHueyFWyEITaDVOB98E9dJHgUiBvsMKOWkA/dDexfABXo3Ra+Xb3bKss7m8WEEpy2+zCvH/VWjzhGaB4NeR+K90PUgREIumAHS2FiiUD3ZwTuRg82BumqBNep/Y9RqMth04hPftHrhSIXI5YyFzlFzBtVxDTozwTgmQhvQwXxkSgGPCuKPfvjAPGHHPOUJC7lTxhnmb1vxhhZHBYcgrhmpNO/981I9s2cuZevcIHlvLT6YTJt0dculyQt/kUq0oa0osXd27BFLSS9XLk5h3LaPitUx6cGP9f7R390U9hwKWqw8YdYVOrHzC2N2NL9teTEOWD1WC7aQZ6wKKdklAUjM37Dj8Vcqabdan7KZgHo0dB/L+HFxRZWBqrbVV2ZmFf2vPuq71gWkbxm8IivRkA9yrnw== vadimcorporateukr@gmail.com"
  }

  custom_data = filebase64("init-script.sh")

  tags = {
    Environment = "dev"
    Team        = "dev-team"
  }
}
