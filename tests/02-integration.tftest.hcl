provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "Test"
    }
  }
}

variables {
  name = "efs-module-test"
  security_group_ingress = {
    default = {
      description = "NFS Inbound"
      from_port   = 2049
      protocol    = "tcp"
      to_port     = 2049
      self        = true
      cidr_blocks = null
    },
    ssh = {
      description = "ssh"
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      self        = false
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
}

run "setup_vpc" {
  command = apply
  module {
    source = "terraform-aws-modules/vpc/aws"
  }

  variables {
    cidr                         = "10.0.0.0/16"
    azs                          = ["us-west-2a", "us-west-2b"]
    private_subnets              = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets               = ["10.0.101.0/24", "10.0.102.0/24"]
    database_subnets             = ["10.0.201.0/24", "10.0.202.0/24"]
    create_database_subnet_group = true
    enable_nat_gateway           = true
    single_nat_gateway           = true
  }
}

run setup_efs {
  command = apply

  variables {
    vpc_id                 = run.setup_vpc.vpc_id
    subnet_ids             = run.setup_vpc.private_subnets
    lifecycle_policy       = [{ "transition_to_ia" = "AFTER_30_DAYS" }]
    backup_policy_status   = "ENABLED"

  }

}

run "efs_tests" {
  command = apply

  module {
    source = "./tests/final"
  }

  variables {
    file_system_id = run.setup_efs.id
  }

  assert {
    condition     = data.aws_efs_file_system.this.name == var.name
    error_message = "Something is not quite right with the database"
  }
}
