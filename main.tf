provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "./modules/vpc"
  aws_region     = var.aws_region
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  subnet_details = var.subnet_details
}

module "private_sg" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  subnet_details = {
    for k, v in var.subnet_details : k => v if v.public == false
  }
}

module "services" {
  for_each = var.services_map

  source             = "./modules/ec2_instance"
  service_name       = each.key
  instance_count     = each.value.instance_count
  ami_id             = data.aws_ami.amzlinux2.id
  instance_type      = each.value.instance_type
  subnet_id          = module.vpc.subnet_details["Auth"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Auth"]]
  common_tags        = var.common_tags
  services_map       = var.services_map
}

module "Auth_services" {
  for_each = var.services_map

  source             = "./modules/ec2_instance"
  service_name       = each.key
  instance_count     = each.value.instance_count
  ami_id             = data.aws_ami.amzlinux2.id
  instance_type      = each.value.instance_type
  subnet_id          = module.vpc.subnet_details["Auth"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Auth"]]
  common_tags        = var.common_tags
  services_map       = var.services_map
}

module "User_services" {
  for_each = var.services_map

  source             = "./modules/ec2_instance"
  service_name       = each.key
  instance_count     = each.value.instance_count
  ami_id             = data.aws_ami.amzlinux2.id
  instance_type      = each.value.instance_type
  subnet_id          = module.vpc.subnet_details["User"].id
  security_group_ids = [module.private_sg.private_security_group_ids["User"]]
  common_tags        = var.common_tags
  services_map       = var.services_map
}

module "Product_services" {
  for_each = var.services_map

  source             = "./modules/ec2_instance"
  service_name       = each.key
  instance_count     = each.value.instance_count
  ami_id             = data.aws_ami.amzlinux2.id
  instance_type      = each.value.instance_type
  subnet_id          = module.vpc.subnet_details["Product"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Product"]]
  common_tags        = var.common_tags
  services_map       = var.services_map
}
module "Order_services" {
  for_each = var.services_map

  source             = "./modules/ec2_instance"
  service_name       = each.key
  instance_count     = each.value.instance_count
  ami_id             = data.aws_ami.amzlinux2.id
  instance_type      = each.value.instance_type
  subnet_id          = module.vpc.subnet_details["Order"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Order"]]
  common_tags        = var.common_tags
  services_map       = var.services_map
}
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}