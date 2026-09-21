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

module "route_table" {
  source = "../../modules/route-table"

  location            = var.location
  name                = var.route_table_name
  routes              = var.routes
  resource_group_name = module.resource_group.name
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

resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = module.networking.subnet_ids["snet-workload"]
  route_table_id = module.route_table.route_table_id
}

module "private_dns_zone" {
  source = "../../modules/private-dns-zone"

  name                = var.private_dns_zone_name
  resource_group_name = module.resource_group.name
  vnet_link_name      = var.private_dns_vnet_link_name
  virtual_network_id  = module.networking.vnet_id
  tags                = local.common_tags
}

module "storage_account" {
  source = "../../modules/storage-account"

  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.common_tags
}

module "private_endpoint" {
  source = "../../modules/private-endpoint"

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = module.resource_group.name

  subnet_id = module.networking.subnet_ids["snet-private-endpoint"]

  private_connection_resource_id = module.storage_account.id
  subresource_names              = ["blob"]

  private_dns_zone_ids = [
    module.private_dns_zone.id
  ]

  tags = local.common_tags
}

module "linux_vm" {
  source = "../../modules/linux-vm"

  name                = "vm-${local.naming_prefix}-01"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.networking.subnet_ids["snet-workload"]

  vm_size        = "Standard_DS2_v2_Promo"
  admin_username = "azureadmin"

  ssh_public_key = var.ssh_public_key

  tags = local.common_tags
}

module "windows_vm" {
  source = "../../modules/windows-vm"

  name                = "vm-${local.naming_prefix}-02"
  computer_name       = "win-dev-02"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.networking.subnet_ids["snet-workload"]

  vm_size        = "Standard_DS2_v2_Promo"
  admin_username = "azureadmin"
  admin_password = var.windows_admin_password

  tags = local.common_tags
}
