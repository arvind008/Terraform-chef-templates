###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Template for Provisioning App server                                   #
#                                                                         #
###########################################################################

variable "region" {
}

variable "access_key" {}

variable "secret_key" {}

variable "stackname" {}

variable "vpc_id" {
  default = ""
}

variable "session_token" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "create_lb" {
  default = 1
}

variable "os_type" {
  default = "centos"
}

variable "mysql_endpoint" {
  default = "mysqladdress.dnsaddress.com"
}

variable "vm_count" {
  default = 3
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

variable "ssh_user" {
  default = "ubuntu"
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
variable "mysql_app_name"{
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
  default = "PetClinic"
}
variable "s3_build_jar" {
  default = "s3://petclinic-build-jar"
}
variable "sf_app_name"{
  default = ""
}
variable "ami_id" {
  default = ""
}

