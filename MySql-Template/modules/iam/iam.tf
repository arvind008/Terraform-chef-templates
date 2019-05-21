resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "gam-s3-role1"
  assume_role_policy = "${file("modules/iam/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "gam-test-policy1"
  description = "A test policy"
  policy      = "${file("modules/iam/policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "gam-test-attachment1"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "gam_test_profile1"
  roles = ["${aws_iam_role.ec2_s3_access_role.name}"]
}

output "instance_profile_id" {
  value = "${aws_iam_instance_profile.test_profile.id}"
}
