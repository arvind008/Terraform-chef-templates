# Specify provider and specifications
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  token      = "${var.session_token}"
}

# Configure the network
module "my_vpc" {
  source    = "modules/vpc"
  stackname = "${var.stackname}"
  vpc_id    = "${data.aws_vpc.selected_vpc.id}"
}

module "my_iam" {
  source = "modules/iam"
}

# Create Database instances
module "db_instance" {
  source                  = "modules/ec2"
  instance_count          = "${var.vm_count}"
  ami_id                  = "${local.mysql_ami}"
  instance_type           = "${var.vm_instance_type}"
  stackname               = "${var.stackname}"
  security_group_id       = "${module.my_vpc.security_group_id}"
  vm_disk_size            = "${var.vm_disk_size}"
  vm_disk_type            = "${var.vm_disk_type}"
  subnet_id               = "${data.aws_subnet.subnet_selected.id}"
  key_name                = "${var.ssh_key_name}"
  ssh_user                = "${var.ssh_user}"
  instance_profile        = "${module.my_iam.instance_profile_id}"
  availability_zone       = "${data.aws_subnet.subnet_selected.availability_zone}"
  ssh_key_path            = "${var.ssh_key_path}"
  central_chef_server_url = "${var.chef_server_url}"
  chef_organization_pem   = "${var.chef_org_pem}"
  chef_user_pem           = "${var.chef_user_pem}"
  cookbook_name           = "${var.cookbook_name}"
  app_version                 = "${var.version}"
}
