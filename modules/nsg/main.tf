resource "azurerm_network_security_group" "this" {
  for_each = var.nsgs

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

locals {
  security_rules = flatten([
    for nsg_name, nsg in var.nsgs : [
      for rule_name, rule in nsg.rules : {
        key       = "${nsg_name}-${rule_name}"
        nsg_name  = nsg_name
        rule_name = rule_name
        rule      = rule
      }
    ]
  ])
}

resource "azurerm_network_security_rule" "this" {
  for_each = {
    for item in local.security_rules :
    item.key => item
  }

  name                        = each.value.rule_name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_name].name
}