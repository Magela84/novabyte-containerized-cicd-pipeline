terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-novabyte"
    storage_account_name = "sttfstatenovabyte"
    container_name       = "tfstate"
    key                  = "novabyte.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
