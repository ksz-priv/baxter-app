/*
initials               = "ksz"
project_name           = "baxter"
location               = "North Europe"
service_plan_sku_name  = "B2"
web_app_count          = 3
web_app_dotnet_version = "6.0"
law_settings           = {
  sku               = "PerGB2018"
  retention_in_days = 30
  location     = "North Europe"
  service_plan_sku_name = "B2"
  web_app_settings = {
    count          = 3
    dotnet_version = "6.0"
  }
  law_settings = {
    sku               = "PerGB2018"
    retention_in_days = 30
  }
  storage_account_settings = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
  mssql_settings = {
    location                     = "Germany West Central"
    version                      = "12.0"
    administrator_login          = "baxter"
    administrator_login_password = "4-v3ry-53cr37-P455w0rd"
    sku_name                     = "Basic"
    max_size_gb                  = 2
  }
  container_registry_settings = {
    sku           = "Basic"
    admin_enabled = false
  }
  aks_settings = {
    node_resource_group_core_name = "internal"
    node_pool                     = {
      node_count = 1
      vm_size    = "Standard_B2s"
    }
  }  
}*/


initials              = "ksz"
project_name          = "baxter"
location              = "North Europe"
service_plan_sku_name = "B2"
web_app_settings = {
  count          = 3
  dotnet_version = "6.0"
}
law_settings = {
  sku               = "PerGB2018"
  retention_in_days = 30
}
storage_account_settings = {
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
mssql_settings = {
  location                     = "Germany West Central"
  version                      = "12.0"
  administrator_login          = "baxter"
  administrator_login_password = "4-v3ry-53cr37-P455w0rd"
  sku_name                     = "Basic"
  max_size_gb                  = 2
}
container_registry_settings = {
  sku           = "Basic"
  admin_enabled = false
}
aks_settings = {
  node_resource_group_core_name = "internal"
  node_pool = {
    node_count = 1
    vm_size    = "Standard_D2as_v5"
  }
}
