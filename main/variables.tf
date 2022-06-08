variable "initials" {
  type = string
}
variable "project_name" {
  type = string
}
variable "location" {
  type = string
}
variable "service_plan_sku_name" {
  type = string
}
/*variable "web_app_count" {
  type = number
}
variable "web_app_dotnet_version" {
  type = string
}*/
/*variable "law_sku" {
  type = string
}
variable "law_retention_in_days" {
  type = number
}*/

variable "web_app_settings" {
  type = object({
    count          = number
    dotnet_version = string
  })
}
variable "law_settings" {
  type = object({
    sku               = string
    retention_in_days = number
  })
}
variable "storage_account_settings" {
  type = object({
    account_tier             = string
    account_replication_type = string
  })
}
variable "mssql_settings" {
  type = object({
    location                     = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
    sku_name                     = string
    max_size_gb                  = number
  })
}
variable "container_registry_settings" {
  type = object({
    sku           = string
    admin_enabled = bool
  })
}
variable "aks_settings" {
  type = object({
    node_resource_group_core_name = string
    node_pool = object({
      node_count = number
      vm_size    = string
    })
  })
}
