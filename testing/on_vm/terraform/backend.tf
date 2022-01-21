terraform {
  backend "azurerm" {
    resource_group_name  = "relayctl"
    storage_account_name = "relayctl"
    container_name       = "terraform"
    key                  = "relayctl.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}

provider "azurerm" {
    features{}
}