provider "azurerm" {
  version = "~>2.0"
  features {}
}

locals {
  unique_name_stub = substr(module.naming.unique-seed, 0, 5)
}

module "naming" {
  source = "git@github.com:Azure/terraform-azurerm-naming"
}

resource "azurerm_resource_group" "test_group" {
  name     = "${module.naming.resource_group.slug}-audit-diagnostics-max-${local.unique_name_stub}"
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
  prefix                                     = [local.unique_name_stub]
  suffix                                     = [local.unique_name_stub]
  event_hub_namespace_sku                    = "Standard"
  event_hub_namespace_capacity               = "1"
  event_hubs = {
    "eh-default" = {
      name              = module.naming.event_hub.name
      partition_count   = 1
      message_retention = 1
      authorisation_rules = {
        "ehra-default" = {
          name   = module.naming.event_hub_authorization_rule.name
          listen = true
          send   = false
          manage = false
        }
      }
    }
  }
  log_analytics_workspace_sku           = "PerGB2018"
  log_analytics_retention_in_days       = 730
  automation_account_alternate_location = azurerm_resource_group.test_group.location
  automation_account_sku                = "Basic"
  storage_account_name                  = module.naming.storage_account.name_unique
  storage_account_tier                  = "Standard"
  storage_account_replication_type      = "LRS"
  allowed_ip_ranges                     = [data.external.test_client_ip.result.ip]
  permitted_virtual_network_subnet_ids  = [azurerm_subnet.diagnostics_subnet.id]
  bypass_internal_network_rules         = true
}










