###########################################################################
#  Copyright 2018-19. MapleLabs                                           #
#                                                                         #
#  Sample Template for Provisioning                                       #
#      Elastic Load balancer - network LB                                 #
#                                                                         #
#      Classic ELB is old style                                           #
#      Application load balancer requires certificates                    #
#      network load balancers direct traffic                              #
#                                                                         #
###########################################################################


# Create Load Balancer
#
resource "aws_lb" "petcliniclb" {
  count              = "${var.create_lb}"
  internal           = false
  load_balancer_type = "network"
  subnets = ["${var.subnet_id}"]
  enable_deletion_protection = false

  tags {
    Name = "lb-${count.index+1}"
    Stack = "${var.stackname}"
  }
}

# Add listerners
#
resource "aws_lb_listener" "petcliniclistener443" {
  count       = "${var.create_lb}"
  load_balancer_arn = "${aws_lb.petcliniclb.arn}"
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.int443.arn}"
  }
}
resource "aws_lb_listener" "petcliniclistener80" {
  count       = "${var.create_lb}"
  load_balancer_arn = "${aws_lb.petcliniclb.arn}"
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.int80.arn}"
  }
}

# Create Target groups
#
resource "aws_lb_target_group" "int80" {
  count       = "${var.create_lb}"
  port        = 80
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Name = "port80-${count.index+1}"
    Stack = "${var.stackname}"
  }
}

resource "aws_lb_target_group" "int443" {
  count       = "${var.create_lb}"
  port        = 443
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Name = "port443-${count.index+1}"
    Stack = "${var.stackname}"
  }
}

# Attach target to Linux instances
#
resource "aws_lb_target_group_attachment" "int80" {
  count            = "${var.create_lb == 1 ? var.instance_count : 0 }"
  target_group_arn = "${aws_lb_target_group.int80.arn}"
  target_id        = "${element(aws_instance.appservers.*.id, count.index)}"
  port             = 8080
}

resource "aws_lb_target_group_attachment" "int443" {
  count            = "${var.create_lb == 1 ? var.instance_count : 0 }"
  target_group_arn = "${aws_lb_target_group.int443.arn}"
  target_id        = "${element(aws_instance.appservers.*.id, count.index)}"
  port             = 443
}


resource "null_resource" "write_dashboard_url" {
  provisioner "local-exec" {
    command = "sed -i 's/lbaddress/${aws_lb.petcliniclb.dns_name}/' externalURL.json"
  }
}
