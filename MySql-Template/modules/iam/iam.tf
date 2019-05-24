resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"-${var.stackname}
  assume_role_policy = "${file("modules/iam/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "policy"-${var.stackname}
  description = "A test policy"
  policy      = "${file("modules/iam/policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "attachment"-${var.stackname}
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "profile"-${var.stackname}
  roles = ["${aws_iam_role.ec2_s3_access_role.name}"]
}

output "instance_profile_id" {
  value = "${aws_iam_instance_profile.test_profile.id}"
}
