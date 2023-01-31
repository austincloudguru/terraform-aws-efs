#------------------------------------------------------------------------------
# Provider
#------------------------------------------------------------------------------
provider "aws" {
  region = var.region
}

terraform {
  required_version = "~> 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_availability_zones" "available" {
}
locals {
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

#------------------------------------------------------------------------------
# Setup the VPC
#------------------------------------------------------------------------------
module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "terratest-vpc"
  cidr               = "10.0.0.0/16"
  azs                = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "mark"
    Environment = "terratest"
  }
}

#------------------------------------------------------------------------------
# Deploy the EFS
#------------------------------------------------------------------------------
module "efs" {
  source                 = "../../"
  vpc_id                 = module.vpc.vpc_id
  name                   = "terratest-efs"
  subnet_ids             = module.vpc.private_subnets
  security_group_ingress = local.security_group_ingress
  lifecycle_policy       = [{ "transition_to_ia" = "AFTER_30_DAYS" }]
  backup_policy_status   = "ENABLED"
  tags = {
    Terraform   = "true"
    Environment = "terratest"
  }
}
