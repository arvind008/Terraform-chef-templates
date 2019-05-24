# Specify provider and specifications
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  token      = "${var.session_token}"
}

# Push chef recipe to chef-server
resource "null_resource" "chef_mysql_push" {
  provisioner "local-exec"{
    command = "sh chef_oper/pet-clinic.sh ${var.pipeline_stage} ${var.version}"
    }
}

# Configure the network
module "my_vpc" {
  source              = "modules/vpc"
  stackname           = "${var.stackname}"
  vpc_id              = "${data.aws_vpc.selected_vpc.id}"
  # Wait for resources and associations to be created
  depends_on = [
      "${null_resource.chef_mysql_push.id}"
  ]
}

module "my_iam" {
  source = "modules/iam"
  stackname = "${var.stackname}"
}

# Create Database instances
module "db_instance" {
  source            = "modules/ec2"
  instance_count    = "${var.vm_count}"
  vpc_id            = "${data.aws_vpc.selected_vpc.id}"
  ami_id            = "${var.ami_id}"
  instance_type     = "${var.vm_instance_type}"
  stackname           = "${var.stackname}"
  create_lb         = "${var.create_lb}"
  security_group_id = "${module.my_vpc.security_group_id}"
  vm_disk_size = "${var.vm_disk_size}"
  vm_disk_type = "${var.vm_disk_type}"
  subnet_id = "${data.aws_subnet.subnet_selected.id}"
  key_name = "${var.ssh_key_name}"
  ssh_user = "${var.ssh_user}"
  instance_profile = "${module.my_iam.instance_profile_id}"
  availability_zone = "${data.aws_subnet.subnet_selected.availability_zone}"
  ssh_key_path = "${var.ssh_key_path}"
  pipeline_stage          = "${var.pipeline_stage}"
  project_name            = "${var.project_name}"
  mysql_app_name          = "${var.mysql_app_name}"
  central_chef_server_url = "${var.chef_server_url}"
  chef_organization_pem   = "${var.chef_org_pem}"
  chef_user_pem           = "${var.chef_user_pem}"
  cookbook_name           = "${var.cookbook_name}"
  s3_build_jar		  = "${var.s3_build_jar}"
  app_version             = "${var.version}"
  sf_app_name             = "${var.sf_app_name}"
}
