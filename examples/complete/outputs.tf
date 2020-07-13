output "resource_group" {
  value = module.audit-diagnostics-group.resource_group
}

output "log_analytics_workspace" {
  value = module.audit-diagnostics-group.log_analytics_workspace
}

output "event_hub_namespace" {
  value = module.audit-diagnostics-group.event_hub_namespace
}

output "event_hubs" {
  value = module.audit-diagnostics-group.event_hubs
}

output "storage_account" {
  value = module.audit-diagnostics-group.storage_account
}

output "private_endpoint" {
  value = module.audit-diagnostics-group.private_endpoint
}

output "private_dns_zone" {
  value = module.audit-diagnostics-group.private_dns_zone
}
