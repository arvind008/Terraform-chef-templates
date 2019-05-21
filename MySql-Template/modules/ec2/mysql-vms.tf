###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Sample Template for Provisioning                                       #
#      Elastic Load balancer - network LB                                 #
#                                                                         #
#                                                                         #
###########################################################################

# create a Linux server which has to be put behind LB

resource "aws_instance" "mysqlvms" {
  count                       = "${var.instance_count}"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${var.instance_profile}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.chef_client_installation.rendered}"

  tags {
    Name  = "mysql-node-${count.index+1}"
    Stack = "${var.stackname}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.vm_disk_size}"
    volume_type           = "${var.vm_disk_type}"
  }

  subnet_id = "${var.subnet_id}"

  availability_zone = "${var.availability_zone}"
}

resource "null_resource" "hosts-mysql" {
  count = "${var.instance_count}"

  depends_on = [
    "aws_instance.mysqlvms",
  ]

  provisioner "local-exec" {
    command = "echo \"mysql-${count.index} ansible_host=${element(aws_instance.mysqlvms.*.public_ip, count.index)} mysql_id=${count.index}\" >> hosts"
  }
}

resource "null_resource" "chef-databag-mysql" {
  count = "${var.instance_count}"

  depends_on = [
    "aws_instance.mysqlvms",
  ]

  provisioner "local-exec" {
    command = "sh modules/templates/chef_databag.sh ${aws_instance.mysqlvms.private_ip}"
  }
}

resource "null_resource" "hosts-dns-details" {
  depends_on = [
    "aws_instance.mysqlvms",
  ]

  provisioner "local-exec" {
    command = "echo \"public_dns=${aws_instance.mysqlvms.public_dns} private_dns=${aws_instance.mysqlvms.private_dns}\" >> dns_hosts"
  }
}
