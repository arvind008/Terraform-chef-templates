###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Sample Template for Provisioning                                       #
#      Elastic Load balancer - network LB                                 #
#                                                                         #
#                                                                         #
###########################################################################

resource "aws_instance" "elasticsearch_masternode" {
  count                       = "${var.master_node_count}"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${var.instance_profile}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.install_chef_client.rendered}"

  tags {
    Name  = "es-master-${count.index+1}"
    Stack = "${var.stackname}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.vm_disk_size}"
    volume_type           = "${var.vm_disk_type}"
  }

  subnet_id         = "${var.subnet_id}"
  availability_zone = "${var.availability_zone}"
}


resource "aws_instance" "elasticsearch_datanode" {
  count                       = "${var.data_node_count}"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${var.instance_profile}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.install_chef_client.rendered}"

  tags {
    Name  = "es-data-${count.index+1}"
    Stack = "${var.stackname}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.vm_disk_size}"
    volume_type           = "${var.vm_disk_type}"
  }

  subnet_id         = "${var.subnet_id}"
  availability_zone = "${var.availability_zone}"

  depends_on = [
    "aws_instance.elasticsearch_masternode",
  ]
}

resource "null_resource" "keypermisions" {
  provisioner "local-exec" {
    command = "chmod 400 ${var.ssh_key_path}/*"
  }
}

resource "null_resource" "chef-databag-masternode-elasticsearch" {
  count = "${var.master_node_count}"

  depends_on = [
    "aws_instance.elasticsearch_masternode",
  ]

  provisioner "local-exec" {
    command = "python modules/templates/push_data_to_data_bag.py itclouds ElasticSearch ${var.pipeline_stage} master_nodes ${aws_instance.elasticsearch_masternode.*.private_ip[count.index]}"
  }
}

resource "null_resource" "chef-databag-datanode-elasticsearch" {
  count = "${var.data_node_count}"

  depends_on = [
    "aws_instance.elasticsearch_datanode",
  ]

  provisioner "local-exec" {
    command = "python modules/templates/push_data_to_data_bag.py itclouds ElasticSearch ${var.pipeline_stage} data_nodes ${aws_instance.elasticsearch_datanode.*.private_ip[count.index]}"
  }
}
