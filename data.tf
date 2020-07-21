data "azurerm_resource_group" "current" {
  name  = var.resource_group_name
  count = var.use_existing_resource_group ? 1 : 0
}

data "azurerm_subscription" "current" {
}

