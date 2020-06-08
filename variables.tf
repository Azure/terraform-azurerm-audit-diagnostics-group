#Module Required Variables

variable "use_existing_resource_group" {
  type        = string
  description = "Boolean flag to determine whether or not to deploy services to an existing Azure Resource Group. When false specify a resource_group_location, when true specify the resource_group_name."
  default     = false
}

variable "storage_account_private_endpoint_subnet_id" {
  type        = string
  description = "The Subnet id for the subnet private endpoint to be deployed to."
}

#Module Optional variables
variable "resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group to deploy the Audit and Diagnostics resources into."
  default     = ""
}

variable "resource_group_location" {
  type        = string
  description = "The location in which to put the Audit and Diagnostics resources."
  default     = ""
}

variable "prefix" {
  type        = list(string)
  description = "A naming prefix to be used in the creation of unique names for Azure resources."
  default     = []
}

variable "suffix" {
  type        = list(string)
  description = "A naming suffix to be used in the creation of unique names for Azure resources."
  default     = []
}

#Event Hub Optional Variables
variable "event_hub_namespace_sku" {
  type        = string
  description = "The Event Hub Namespace SKU, either Standard or Basic"
  default     = "Standard"
}

variable "event_hub_namespace_capacity" {
  type        = number
  description = "The capacity for the Event Hub Namespace, measured in throughput units (1-20)"
  default     = 1
}

variable "event_hubs" {
  type = map(object({
    name              = string
    partition_count   = number
    message_retention = number
    authorisation_rules = map(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  description = "A complex type that define Azure Event Hubs and their associated Authorisation Rules."
  default = {
    "eh-default" = {
      name              = ""
      partition_count   = 1
      message_retention = 1
      authorisation_rules = {
        "ehra-default" = {
          name   = ""
          listen = true
          send   = false
          manage = false
        }
      }
    }
  }
}

#Log Analytics Optional Variables
variable "log_analytics_workspace_sku" {
  type        = string
  description = "The Azure Log Analytics Workspace SKU to create."
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  type        = number
  description = "The number of days to retain Azure Log Analytics Workspace information."
  default     = 730
}

variable "automation_account_alternate_location" {
  type        = string
  description = "An alternate Azure region to deploy the Azure Automation Account to in the event it is not available in the same Azure Region as the Resource Group."
  default     = ""
}

variable "automation_account_sku" {
  type        = string
  description = "The Azure Automation SKU to create."
  default     = "Basic"
}

#Storage Account Optional variables
variable "storage_account_name" {
  type        = string
  description = "Storage Account name to create."
  default     = ""
}

variable "storage_account_tier" {
  type        = string
  description = "The Storage Account tier, either 'Standard' or 'Premium'."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "The type of replication to use for this Storage Account. Valid options are LRS, GRS, RAGRS and ZRS"
  default     = "LRS"
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "List of IP Address CIDR ranges to allow access to Storage Account."
  default     = []
}

variable "permitted_virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of the Subnet IDs to allow to access the Storage Account."
  default     = []
}

variable "bypass_internal_network_rules" {
  type        = bool
  description = "Bypass internal traffic to enable metrics and logging."
  default     = true
}



