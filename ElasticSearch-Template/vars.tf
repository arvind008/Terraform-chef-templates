###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Template for Provisioning LB                               #
#                                                                         #
###########################################################################

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-2"
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "stackname" {
  default = "esc"
}

variable "version" {
  default = "1.0"
}

variable "central_chef_server_url" {
  default = "https://manage.chef.io/organizations/maplelabs123"
}

variable "chef_organization_pem" {
  default = "s3://chefpemfiles/maplelabs123-validator.pem"
}

variable "chef_user_pem" {
  default = "s3://chefpemfiles/gmanal.pem"
}

variable "cookbook_name" {
  default = "adobe_elasticsearch"
}

variable "vpc_id" {
  default = ""
}

variable ssh_user {
  default = "ubuntu"
}

variable "subnet_id" {
  default = ""
}

variable "vm_instance_type" {
  default = "t2.small"
}

variable "vm_disk_size" {
  default = 10
}

variable "vm_disk_type" {
  default = "standard"
}

variable "ssh_key_name" {
  default = "arvind_pem"
}

variable "ssh_key_path" {
  default = "."
}

variable "master_node_count" {
  default = "1"
}

variable "data_node_count" {
  default = "2"
}

variable "pipeline_stage" {
  default = "dev"
}
