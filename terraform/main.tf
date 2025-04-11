resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "westus2"
}

resource "azurerm_resource_group" "rg-aks" {
  name     = "rg-aks"
  location = "westus"
}

module "vnet" {
  source = "./modules/vnet"

  rg_name        = azurerm_resource_group.rg.name
  rg_location    = azurerm_resource_group.rg.location
  vnet_name      = var.vnet_name
  vnet_cidr      = var.vnet_cidr
  sub_vm_name    = var.sub_vm_name
  sub_vm_cidr    = var.sub_vm_cidr
  pip_name       = var.pip_name
  pip_sonar_name = var.pip_sonar_name
  nic_name       = var.nic_name
  nic_name_sonar = var.nic_name_sonar
  nsg_name       = var.nsg_name
  nsg_rules      = var.nsg_rules

}


module "vm" {
  source = "./modules/vm"

  rg_name       = azurerm_resource_group.rg.name
  rg_location   = azurerm_resource_group.rg.location
  nic_id        = module.vnet.nic_id
  nic_sonar_id  = module.vnet.nic_sonar_id
  vm_name       = var.vm_name
  vm_name_sonar = var.vm_name_sonar
  vm_sku_size   = var.vm_sku_size
  depends_on    = [module.vnet]

}

module "aks" {
  source = "./modules/aks"

  rg_name     = azurerm_resource_group.rg-aks.name
  rg_location = azurerm_resource_group.rg-aks.location
  aks_name    = var.aks_name
  aks_dns     = var.aks_dns
  depends_on  = [module.vnet]
}