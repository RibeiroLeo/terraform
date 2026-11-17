# CI-only provider: exercises Terraform's complete plan graph without reaching AWS.
mock_provider "aws" {
  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }
}

run "offline_plan" {
  command = plan
}

