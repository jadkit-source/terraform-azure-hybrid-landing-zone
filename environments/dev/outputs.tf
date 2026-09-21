output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}

output "windows_vm_id" {
  value = module.windows_vm.vm_id
}

output "windows_vm_name" {
  value = module.windows_vm.vm_name
}

output "windows_vm_private_ip" {
  value = module.windows_vm.private_ip_address
}

output "windows_vm_principal_id" {
  value = module.windows_vm.principal_id
}

output "linux_vm_id" {
  value = module.linux_vm.vm_id
}

output "linux_vm_private_ip" {
  value = module.linux_vm.private_ip_address
}

output "linux_vm_principal_id" {
  value = module.linux_vm.principal_id
}
