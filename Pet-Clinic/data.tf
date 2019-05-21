###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Template for Provisioning LB and app servers                           #
#                                                                         #
###########################################################################

data "aws_vpc" "selected_vpc" {
  id      = "${var.vpc_id}"
  default = "${var.vpc_id == "" ? true : false}"
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = "${data.aws_vpc.selected_vpc.id}"
}

resource "random_shuffle" "subnets" {
  input = [
    "${data.aws_subnet_ids.subnet_ids.ids}",
  ]
}

data "aws_subnet" "subnet_selected" {
  id     = "${var.subnet_id == "" ? random_shuffle.subnets.result.0 : var.subnet_id}"
  vpc_id = "${data.aws_vpc.selected_vpc.id}"
}

locals {
  mysql_ami = "ami-08692d171e3cf02d6"
}
