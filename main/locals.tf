locals {
  trusted_ip_addresses = {
    Bielsko  = "185.78.75.135"
    Katowice = "188.117.157.11"
  }

  tags = {
    Environment = "Dev"
    Project     = title(var.project_name)
    Management  = "Terraform"
    Owner       = "iteo"
    State       = "Remote"
  }

  rg_suffix                   = "rg"
  service_plan_suffix         = "plan"
  web_app_suffix              = "app"
  application_insights_suffix = "ai"
  law_suffix                  = "law"
  storage_account_suffix      = "sa"
  mssql_server_suffix         = "sqlsrv"
  mssql_database_suffix       = "sqldb"
  container_registry_suffix   = "acr"
  kubernetes_cluster_suffix   = "aks"
  firewall_rule_suffix        = "firewall-rule"
}