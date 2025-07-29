output "appvm_public_id" {
  value = module.app_vm.public_ip
}

output "dbvm_public_ip" {
  value = module.db_vm.public_ip
}