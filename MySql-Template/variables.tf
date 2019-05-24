###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Template for Provisioning Mysql                                        #
#                                                                         #
###########################################################################

variable "region" {
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "session_token" {
  default = ""
}

variable "stackname" {
  default = "mysql"
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

variable "vm_count" {
  default = 1
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
  default = ""
}

variable "ssh_key_path" {
  default = "./keys"
}

variable "chef_server_url" {
  default = ""
}

variable "chef_org_pem" {
  default = ""
}

variable "chef_user_pem" {
  default = ""
}

variable "cookbook_name" {
  default = "mysqld"
}

variable "sf_app_name" {
  default = ""
}
variable "pipeline_stage" {
  default ="dev"
}
variable "version" {
  default ="0.1.0"
}
variable "app_name" {
  default ="Pet-Clinic"
}
variable "project_name" {
  default ="ITCS"
}
variable "ami_id" {
  default = ""
}