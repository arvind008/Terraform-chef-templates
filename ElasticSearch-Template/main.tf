# Update application version to data bag
resource "null_resource" "chef-databag-update_version" {
  count = "${var.master_node_count}"

  provisioner "local-exec" {
    command = "python modules/templates/push_data_to_data_bag.py itclouds ElasticSearch ${var.pipeline_stage} version ${var.version}"
  }
}

# Specify provider and specifications
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
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

module "ec2_instances" {
  source                  = "modules/ec2"
  master_node_count       = "${var.master_node_count}"
  data_node_count         = "${var.data_node_count}"
  central_chef_server_url = "${var.central_chef_server_url}"
  chef_organization_pem   = "${var.chef_organization_pem}"
  chef_user_pem           = "${var.chef_user_pem}"
  cookbook_name           = "${var.cookbook_name}"
  ami_id                  = "${local.esc_ami}"
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
  pipeline_stage          = "${var.pipeline_stage}"
}
