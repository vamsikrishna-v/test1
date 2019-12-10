# This is an example of how to put public keys into S3 bucket and manage them in Terraform


resource "aws_s3_bucket" "ucas_s3_pubkeys" {
  region = "us-west-1"
  bucket = "ucas-test-bucket-12345"
  acl    = "private"

  policy = <<EOF
{
	  "Id": "Policy1575892965115",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1575892954448",
      "Action": [
        "s3:List*",
		"s3:Get*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::ucas-test-bucket-12345",
      "Principal": "*"
    }
  ]

}
EOF
}

resource "aws_s3_bucket_object" "ucas_s3_pubkeys" {
  bucket = "${aws_s3_bucket.ucas_s3_pubkeys.bucket}"
  key    = "${element(var.ssh_public_key_names, count.index)}.pub"

  # Make sure that you put files into correct location and name them accordingly (`public_keys/{keyname}.pub`)
  source = "public_keys/${element(var.ssh_public_key_names, count.index)}.pub"
  count  = "${length(var.ssh_public_key_names)}"

  depends_on = ["aws_s3_bucket.ucas_s3_pubkeys"]
}
