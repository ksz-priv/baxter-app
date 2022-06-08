output "backend" {
  value = <<-EOT
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.ksz_baxter_state_rg.name}"
    storage_account_name = "${azurerm_storage_account.ksz_baxter_state_sa.name}"
    container_name       = "${azurerm_storage_container.ksz_baxter_state_sc.name}"
    key                  = "ksz.baxter.tfstate"
  }
EOT
}