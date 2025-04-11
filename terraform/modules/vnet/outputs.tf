output "vm_public_ip" {
  value = azurerm_public_ip.pip-terraform.ip_address
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet-project.id
}

output "nic_id" {
  value = azurerm_network_interface.nic-terraform.id
}

output "vm_sonar_public_ip" {
  value = azurerm_public_ip.pip-sonar.ip_address
}

output "nic_sonar_id" {
  value = azurerm_network_interface.nic-sonar.id
}