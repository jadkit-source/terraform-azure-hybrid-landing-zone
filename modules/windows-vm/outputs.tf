output "vm_id" {
  value = azurerm_windows_virtual_machine.this.id
}

output "vm_name" {
  value = azurerm_windows_virtual_machine.this.name
}

output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}

output "principal_id" {
  value = azurerm_windows_virtual_machine.this.identity[0].principal_id
}

output "tenant_id" {
  value = azurerm_windows_virtual_machine.this.identity[0].tenant_id
}
