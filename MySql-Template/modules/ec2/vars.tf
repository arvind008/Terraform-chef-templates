variable "stackname" {}

variable "subnet_id" {}

variable "ami_id" {}

variable "vm_disk_size" {}

variable "vm_disk_type" {}

variable "key_name" {}

variable "availability_zone" {
  default = "us-west-2a"
}

variable "instance_type" {}

variable "instance_count" {}

variable "instance_profile" {}

variable "security_group_id" {}

variable "ssh_key_path" {}

variable "ssh_user" {}

data "template_file" "chef_client_installation" {
  template = "${file("modules/templates/install.sh.tpl")}"

  vars {
    central_chef_server_url = "${var.central_chef_server_url}"
    chef_user_pem           = "${var.chef_user_pem}"
    cookbook_name           = "${var.cookbook_name}"
    chef_organization_pem   = "${var.chef_organization_pem}"
    app_version                 = "${var.app_version}"
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
variable "app_version"{
  default = ""
}
