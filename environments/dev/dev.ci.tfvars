location     = "qatarcentral"
project_name = "hybrid-lz"
environment  = "dev"
owner        = "InfrastructureArchitecture"
cost_center  = "IT-LAB"

vnet_address_space = ["10.10.0.0/16"]
subnets = {
  "snet-management"       = ["10.10.1.0/24"]
  "snet-workload"         = ["10.10.2.0/24"]
  "snet-private-endpoint" = ["10.10.3.0/24"]
}

nsgs = {
  "nsg-management" = {
    rules = {
      "allow-rdp-management" = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "10.10.1.0/24"
        destination_address_prefix = "*"
      }

      "allow-ssh-management" = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.10.1.0/24"
        destination_address_prefix = "*"
      }
    }
  }

  "nsg-workload" = {
    rules = {
      "allow-https-from-management" = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.10.1.0/24"
        destination_address_prefix = "*"
      }
    }
  }
}

route_table_name = "rt-workload-dev"

routes = {
  internet = {
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

private_dns_zone_name      = "privatelink.blob.core.windows.net"
private_dns_vnet_link_name = "link-vnet-hybrid-lz-dev"

storage_account_name  = "sthybridlzdev1023"
private_endpoint_name = "pep-blob-hybrid-lz-dev"

ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQ9nuUv811zddfG33YEYyAY5V4DCVdLldDVhyrx7+P/ terraform-lab"

key_vault_name                       = "kv-hybrid-lz-dev-1023"
key_vault_private_dns_zone_name      = "privatelink.vaultcore.azure.net"
key_vault_private_dns_vnet_link_name = "link-kv-hybrid-lz-dev"
key_vault_private_endpoint_name      = "pep-kv-hybrid-lz-dev"
