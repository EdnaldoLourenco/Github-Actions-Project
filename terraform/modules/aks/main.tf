resource "azurerm_kubernetes_cluster" "aks-devops" {
  name                = var.aks_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix          = var.aks_dns

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_B2S"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Ambiente = "Sistema"
  }
}
