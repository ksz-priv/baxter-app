resource "azurerm_resource_group" "ksz_baxter_rg" {
  name     = "${var.initials}-${var.project_name}-${local.rg_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_service_plan" "ksz_baxter_plan" {
  name                = "${var.initials}-${var.project_name}-${local.service_plan_suffix}"
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  location            = azurerm_resource_group.ksz_baxter_rg.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name
  tags                = local.tags
}

resource "azurerm_linux_web_app" "ksz_baxter_app" {
  count               = var.web_app_settings.count
  name                = "${var.initials}-${var.project_name}-${count.index + 1}-${local.web_app_suffix}"
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  location            = azurerm_resource_group.ksz_baxter_rg.location
  service_plan_id     = azurerm_service_plan.ksz_baxter_plan.id

  site_config {
    application_stack {
      dotnet_version = var.web_app_settings.dotnet_version
    }
  }

  app_settings = {
    /*    APPINSIGHTS_INSTRUMENTATIONKEY                  = "aa6e0aa9-1bb2-444d-8d48-a0cb06545149"*/
    APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.ksz_baxter_ai.instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = azurerm_application_insights.ksz_baxter_ai.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }

  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }
  tags = local.tags
}

resource "azurerm_application_insights" "ksz_baxter_ai" {
  name                = "${var.initials}-${var.project_name}-${local.application_insights_suffix}"
  location            = azurerm_resource_group.ksz_baxter_rg.location
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.ksz_baxter_law.id
  tags                = local.tags
}

resource "azurerm_log_analytics_workspace" "ksz_baxter_law" {
  name                = "${var.initials}-${var.project_name}-${local.law_suffix}"
  location            = azurerm_resource_group.ksz_baxter_rg.location
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  sku                 = var.law_settings.sku
  retention_in_days   = var.law_settings.retention_in_days
  tags                = local.tags
}

resource "azurerm_storage_account" "ksz_baxterweb_sa" {
  name                     = "${var.project_name}web${var.initials}${local.storage_account_suffix}"
  location                 = azurerm_resource_group.ksz_baxter_rg.location
  resource_group_name      = azurerm_resource_group.ksz_baxter_rg.name
  account_tier             = var.storage_account_settings.account_tier
  account_replication_type = var.storage_account_settings.account_replication_type
  min_tls_version          = "TLS1_2"

  static_website {
    index_document = "index.html"
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }
  tags = local.tags
}

resource "azurerm_mssql_server" "ksz_baxter_sqlsrv" {
  name                         = "${var.initials}-${var.project_name}-sqlsrv"
  resource_group_name          = azurerm_resource_group.ksz_baxter_rg.name
  location                     = var.mssql_settings.location
  version                      = var.mssql_settings.version
  administrator_login          = var.mssql_settings.administrator_login
  administrator_login_password = var.mssql_settings.administrator_login_password
  minimum_tls_version          = "1.2"
  tags                         = local.tags
}

resource "azurerm_mssql_database" "ksz_baxter_sqldb" {
  name        = "${var.initials}-${var.project_name}-${local.mssql_database_suffix}"
  server_id   = azurerm_mssql_server.ksz_baxter_sqlsrv.id
  sku_name    = var.mssql_settings.sku_name
  max_size_gb = var.mssql_settings.max_size_gb
  tags        = local.tags
}

resource "azurerm_mssql_firewall_rule" "ksz_internal_firewall_rule" {
  name             = "${var.initials}-internal-${local.firewall_rule_suffix}"
  server_id        = azurerm_mssql_server.ksz_baxter_sqlsrv.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "ksz_firewall_rule" {
  for_each         = local.trusted_ip_addresses
  name             = "${var.initials}-${lower(each.key)}-${local.firewall_rule_suffix}"
  server_id        = azurerm_mssql_server.ksz_baxter_sqlsrv.id
  start_ip_address = each.value
  end_ip_address   = each.value
}

resource "azurerm_container_registry" "ksz_baxter_acr" {
  name                = "${var.initials}${var.project_name}${var.initials}${local.container_registry_suffix}"
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  location            = azurerm_resource_group.ksz_baxter_rg.location
  sku                 = var.container_registry_settings.sku
  admin_enabled       = var.container_registry_settings.admin_enabled
  tags                = local.tags
}

resource "azurerm_kubernetes_cluster" "ksz_baxter_spot_aks" {
  name                = "${var.initials}-${var.project_name}-spot-${local.kubernetes_cluster_suffix}"
  resource_group_name = azurerm_resource_group.ksz_baxter_rg.name
  location            = azurerm_resource_group.ksz_baxter_rg.location
  dns_prefix          = "${var.project_name}-spot-${local.kubernetes_cluster_suffix}"

  default_node_pool {
    name       = "default"
    node_count = var.aks_settings.node_pool.node_count
    vm_size    = var.aks_settings.node_pool.vm_size
    tags       = local.tags
  }

  node_resource_group = "${var.initials}-${var.project_name}-aks-${var.aks_settings.node_resource_group_core_name}-${local.rg_suffix}"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.ksz_baxter_law.id
  }
  role_based_access_control_enabled = true
}

resource "azurerm_role_assignment" "baxter_aks_role_acrpull" {
  scope                            = azurerm_container_registry.ksz_baxter_acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.ksz_baxter_spot_aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

#test123