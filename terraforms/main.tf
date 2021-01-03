terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  map_public_ip_on_launch = true
  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}


module "master_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "master-sg"
  description = "SG for master"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "${chomp(data.http.myip.body)}/32"
    }
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = module.worker_sg.this_security_group_id
    }
  ]
}


module "worker_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "worker-sg"
  description = "SG for worker"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "${chomp(data.http.myip.body)}/32"
    }
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = module.master_sg.this_security_group_id
    }
  ]
}

resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu"
  public_key = file("key.pub")
}

module "master_ec2s" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "master"
  count = 1

  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.master_sg.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[count.index]
  
  key_name = "ubuntu"

  tags = {
    Master   = "true"
  }
}

module "worker_ec2s" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"
  
  name           = "worker"
  count = 2

  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.worker_sg.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[count.index]

  key_name = "ubuntu"

  tags = {
    Master   = "false"
  }
}


