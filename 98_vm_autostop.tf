# Add an auto-shutdown schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "auto-shutdown-am1" {
  virtual_machine_id = azurerm_linux_virtual_machine.am1.id
  location           = data.azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "Central Europe Standard Time"
  notification_settings {
    enabled = false
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "auto-shutdown-am2" {
  virtual_machine_id = azurerm_linux_virtual_machine.am2.id
  location           = data.azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "Central Europe Standard Time"
  notification_settings {
    enabled = false
  }
}