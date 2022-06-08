terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ksz-baxter-state-rg"
    storage_account_name = "kszbaxterstatesa"
    container_name       = "ksz-baxter-state-sc"
    key                  = "ksz.baxter.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
