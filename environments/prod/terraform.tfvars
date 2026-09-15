location     = "qatarcentral"
project_name = "hybrid-lz"
environment  = "prod"
owner        = "InfrastructureArchitecture"
cost_center  = "IT-PROD"

vnet_address_space = ["10.20.0.0/16"]

subnets = {
  "snet-management"       = ["10.20.1.0/24"]
  "snet-workload"         = ["10.20.2.0/24"]
  "snet-private-endpoint" = ["10.20.3.0/24"]
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
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "*"
      }

      "allow-ssh-management" = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.20.1.0/24"
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
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "*"
      }
    }
  }
}