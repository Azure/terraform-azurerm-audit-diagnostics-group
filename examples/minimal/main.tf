provider "azurerm" {
  version = "~>2.0"
  features {}
}

module "naming" {
  source = "git@github.com:Azure/terraform-azurerm-naming"
}

locals {
  unique_name_stub = substr(module.naming.unique-seed, 0, 5)
}

resource "azurerm_resource_group" "test_group" {
  name     = "${module.naming.resource_group.slug}-audit-diagnostics-min-${local.unique_name_stub}"
  location = "uksouth"
}

resource "azurerm_virtual_network" "diagnostics_virtual_network" {
  name                = module.naming.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test_group.location
  resource_group_name = azurerm_resource_group.test_group.name
}

resource "azurerm_subnet" "diagnostics_subnet" {
  name                                           = module.naming.subnet.name
  resource_group_name                            = azurerm_resource_group.test_group.name
  virtual_network_name                           = azurerm_virtual_network.diagnostics_virtual_network.name
  address_prefix                                 = "10.0.0.0/24"
  service_endpoints                              = ["Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
}

module "audit-diagnostics-group" {
  source                                     = "../../"
  storage_account_private_endpoint_subnet_id = azurerm_subnet.diagnostics_subnet.id
  use_existing_resource_group                = false
  resource_group_location                    = azurerm_resource_group.test_group.location
}
