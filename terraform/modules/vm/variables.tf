variable "vm_name" {}
variable "subnet_id" {}
variable "location" {}
variable "resource_group" {}
variable "public_ip_dns" {}
variable "enable_http" {
  description = "Allow port 80 in NSG"
  type        = bool
  default     = false
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "admin_username" {}
