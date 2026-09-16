module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${local.naming_prefix}"
  location = var.location
  tags     = local.common_tags
}

# Development virtual network and subnet configuration
module "networking" {
  source = "../../modules/networking"

  vnet_name           = "vnet-${local.naming_prefix}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.common_tags
}

module "nsg" {
  source = "../../modules/nsg"

  location            = var.location
  resource_group_name = module.resource_group.name
  nsgs                = var.nsgs
  tags                = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    "snet-management" = "nsg-management"
    "snet-workload"   = "nsg-workload"
  }

  subnet_id                 = module.networking.subnet_ids[each.key]
  network_security_group_id = module.nsg.nsg_ids[each.value]
}