provider "azurerm" {
  features {}

  subscription_id = "f0efe35e-b5a6-42ef-9a7a-e11fa99a1f8f"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  client_id       = "b11e11d5-5348-4747-95c8-d499d5e8b3ee"
  client_secret   = "iJOWAd0R_4~l3.HFER.ZCSDr-8hyyosf1c"
}

locals {
  azure_location      = "japaneast"
  env                 = "demo"
  resource_group_name = "rg-cosmossample-${local.env}"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfakskohei3110str"
    container_name       = "tfstate"
    key                  = "cosmossample.tfstate"
  }
}

module "azure_rg" {
  source = "../../modules/rg"

  rg_name  = local.resource_group_name
  location = local.azure_location
}

module "cosmosdb" {
  source = "../../modules/cosmosdb"

  rg_name  = local.resource_group_name
  location = local.azure_location
}