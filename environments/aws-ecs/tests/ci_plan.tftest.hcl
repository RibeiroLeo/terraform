# CI-only provider: exercises Terraform's complete plan graph without reaching AWS.
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = {
      region = "us-east-1"
    }
  }
}

run "offline_plan" {
  command = plan
}

