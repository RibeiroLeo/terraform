# CI uses the provider schema with simulated values and no GCP authentication.
mock_provider "google" {}

run "offline_plan" {
  command = plan

  variables {
    project_id = "terraform-portfolio-ci"
  }
}
