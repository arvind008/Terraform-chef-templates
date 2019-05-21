resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "PetClinic-s3-role"
  assume_role_policy = "${file("modules/iam/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "PetClinic-test-policy"
  description = "A test policy"
  policy      = "${file("modules/iam/policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "PetClinic-test-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "PetClinic_test_profile"
  roles = ["${aws_iam_role.ec2_s3_access_role.name}"]
}

output "instance_profile_id" {
  value = "${aws_iam_instance_profile.test_profile.id}"
}
