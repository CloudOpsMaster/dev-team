# Outputs
output "resource_group_name" {
  value = azurerm_resource_group.k8s_rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.k8s_vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.k8s_subnet.name
}

output "network_interface_id" {
  value = azurerm_network_interface.k8s_nic.id
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.k8s_vm.id
}

output "virtual_machine_public_ip" {
  value = azurerm_public_ip.k8s_public_ip.ip_address
}