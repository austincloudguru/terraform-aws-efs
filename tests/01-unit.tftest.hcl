provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "Test"
    }
  }
}

variables {
  name = "ecs-module-test"
  vpc_id = "vpc-0156c7c6959ba5858"
  subnet_ids = ["subnet-05b1a3ffd786709d5", "subnet-0a35212c972a2af05", "subnet-0d0e78f696428aa28"]
}

run "validate_variables" {
  command = plan

  variables {
    backup_policy_status = "disabled"
  }

  expect_failures = [
    var.backup_policy_status
  ]

}
