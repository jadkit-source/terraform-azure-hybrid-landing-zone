variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet names and address prefixes"
  type        = map(list(string))
}

variable "tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
}