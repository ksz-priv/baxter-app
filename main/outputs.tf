
output "ksz_baxter_ai_name" {
  value = azurerm_application_insights.ksz_baxter_ai.name
}

output "ksz_baxter_ai_instrumentation_key" {
  value     = azurerm_application_insights.ksz_baxter_ai.instrumentation_key
  sensitive = true
}

output "ksz_baxter_ai_connection_string" {
  value     = azurerm_application_insights.ksz_baxter_ai.connection_string
  sensitive = true
}