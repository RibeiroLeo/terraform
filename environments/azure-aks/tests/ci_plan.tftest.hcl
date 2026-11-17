# CI-only provider: exercises Terraform's complete plan graph without reaching Azure.
mock_provider "azurerm" {}

run "offline_plan" {
  command = plan

  variables {
    subscription_id = "00000000-0000-0000-0000-000000000000"
  }
}
