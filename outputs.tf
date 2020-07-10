output "resource_group" {
  value = data.azurerm_resource_group.current
}

output "log_analytics_workspace" {
  value = module.log_analytics.log_analytics_workspace
}

output "event_hub_namespace" {
  value = module.event_hub.event_hub_namespace
}

output "event_hubs" {
  value = module.event_hub.event_hubs
}

output "storage_account" {
  value = module.storage_account.storage_account
}

output "automation_account" {
  value = module.log_analytics.automation_account
}
