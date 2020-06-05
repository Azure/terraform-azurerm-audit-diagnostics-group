data "azurerm_resource_group" "current" {
  name = local.resource_group_name
}

data "azurerm_subscription" "current" {
}

