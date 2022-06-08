resource "azurerm_resource_group" "ksz_baxter_state_rg" {
  name     = "ksz-baxter-state-rg"
  location = "North Europe"
  tags     = local.tags
}

resource "azurerm_storage_account" "ksz_baxter_state_sa" {
  name                     = "${var.initials}baxterstatesa"
  location                 = azurerm_resource_group.ksz_baxter_state_rg.location
  resource_group_name      = azurerm_resource_group.ksz_baxter_state_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "ksz_baxter_state_sc" {
  name                  = "ksz-baxter-state-sc"
  storage_account_name  = azurerm_storage_account.ksz_baxter_state_sa.name
  container_access_type = "private"
}