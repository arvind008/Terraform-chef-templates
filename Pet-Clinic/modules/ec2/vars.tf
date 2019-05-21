variable "stackname" {
}
variable "subnet_id" {
}
variable "ami_id" {
}
variable "vm_disk_size" {
}
variable "vm_disk_type" {
}
variable "key_name" {
}
variable "availability_zone" {
  default = "us-west-2a"
}
variable "instance_type" {
}
variable "instance_count" {
}
variable "instance_profile" {
}
variable "security_group_id" {
}
variable "ssh_key_path" {
}
variable "ssh_user" {
}
variable "create_lb" {
}
variable "vpc_id" {
}
data "template_file" "install_script" {
  template = "${file("modules/ec2/install.sh.tpl")}"
  vars { 
    pipeline_stage          = "${var.pipeline_stage}"
    project_name            = "${var.project_name}"
    mysql_app_name          = "${var.mysql_app_name}"
    sf_app_name             = "${var.sf_app_name}"
    central_chef_server_url = "${var.central_chef_server_url}"
    chef_user_pem           = "${var.chef_user_pem}"
    cookbook_name           = "${var.cookbook_name}"
    chef_organization_pem   = "${var.chef_organization_pem}"
    s3_build_jar	    = "${var.s3_build_jar}"
    app_version             = "${var.app_version}"
  }
}
variable "pipeline_stage" { 
}
variable "project_name" {
}
variable "mysql_app_name" {
}
variable "sf_app_name" {
}
variable "central_chef_server_url" {
  default = ""
}

variable "chef_organization_pem" {
  default = ""
}

variable "chef_user_pem" {
  default = ""
}

variable "cookbook_name" {
  default = ""
}
variable "s3_build_jar" {
}
variable "app_version" {
}
