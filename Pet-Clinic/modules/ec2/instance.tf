resource "aws_instance" "appservers" {
  count = "${var.instance_count}"
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  iam_instance_profile        = "${var.instance_profile}"
  user_data                   = "${data.template_file.install_script.rendered}"
  tags {
    Name = "appserver-${count.index+1}"
    Stack = "${var.stackname}"
  }
  root_block_device {
    delete_on_termination = true
    volume_size = "${var.vm_disk_size}"
    volume_type = "${var.vm_disk_type}"
  }
  subnet_id = "${var.subnet_id}"

  availability_zone = "${var.availability_zone}"
}

resource "null_resource" "hosts-appservers" {
  count = "${var.instance_count}"
  depends_on = [
    "aws_instance.appservers"
  ]
  provisioner "local-exec" {
    command = "echo \"appserver-${count.index} ansible_host=${element(aws_instance.appservers.*.public_ip, count.index)} sizer_id=${count.index}\" >> hosts"
  }
}
resource "null_resource" "hosts-dns-details" {
  depends_on = [
    "aws_instance.appservers",
  ]

  provisioner "local-exec" {
    command = "echo \"public_dns=${aws_instance.appservers.public_dns} private_dns=${aws_instance.appservers.private_dns}\" >> dns_hosts"
  }
}

