variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "owner" {
  description = "Resource owner"
  type        = string
}

variable "cost_center" {
  description = "Cost center for resource tracking"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Subnet configuration"
  type        = map(list(string))
}

variable "nsgs" {
  description = "NSGs and their security rules"

  type = map(object({
    rules = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "route_table_name" {
  type = string
}

variable "routes" {
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
}

variable "private_dns_zone_name" {
  type = string
}

variable "private_dns_vnet_link_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}
