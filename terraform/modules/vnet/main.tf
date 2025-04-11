resource "azurerm_virtual_network" "vnet-project" {
  name                = var.vnet_name
  address_space       = var.vnet_cidr
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "sub-vm" {
  name                 = var.sub_vm_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet-project.name
  address_prefixes     = var.sub_vm_cidr
}


resource "azurerm_public_ip" "pip-terraform" {
  name                = var.pip_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "pip-sonar" {
  name                = var.pip_sonar_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic-terraform" {
  name                = var.nic_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-terraform.id
  }
}

resource "azurerm_network_interface" "nic-sonar" {
  name                = var.nic_name_sonar
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-sonar.id
  }
}

resource "azurerm_network_security_group" "nsg-terraform" {
  name                = var.nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg-associate" {
  for_each = {
    vms = azurerm_subnet.sub-vm.id
  }

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg-terraform.id
}