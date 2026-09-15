terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfhybridlz1023"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"

    use_azuread_auth = true
  }
}