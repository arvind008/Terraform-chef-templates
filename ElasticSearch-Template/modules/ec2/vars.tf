variable "stackname" {}

variable "subnet_id" {}

variable "ami_id" {}

variable "vm_disk_size" {}

variable "vm_disk_type" {}

variable "key_name" {}

variable "availability_zone" {}

variable "instance_type" {}

variable "master_node_count" {}

variable "data_node_count" {}

variable "instance_profile" {}

variable "security_group_id" {}

variable "ssh_key_path" {}

variable "ssh_user" {}

data "template_file" "install_chef_client" {
  template = "${file("modules/templates/install.sh.tpl")}"

  vars {
    central_chef_server_url = "${var.central_chef_server_url}"
    chef_user_pem           = "${var.chef_user_pem}"
    cookbook_name           = "${var.cookbook_name}"
    chef_organization_pem   = "${var.chef_organization_pem}"
    pipeline_stage          = "${var.pipeline_stage}"
  }
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
variable "pipeline_stage" {
  default = ""
}
