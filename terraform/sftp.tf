
resource "aws_s3_bucket" "sftp_bucket" {
  bucket = "data-zone-sftp-gsd-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "sftp_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.sftp_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_transfer_server" "sftp" {
  endpoint_type = "VPC"

  endpoint_details {
    subnet_ids = "${aws_subnet.workload_private.*.id}"
    vpc_id     = aws_vpc.main.id
  }

  protocols   = ["SFTP"]
  domain = "S3"
  identity_provider_type = "SERVICE_MANAGED"

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-sftp"
  }
}


resource "aws_iam_role" "sftp_role" {
  name = "${var.org}-${var.project}-${var.environment}-sftp"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "sftp_policy" {
  name = "${var.org}-${var.project}-${var.environment}-sftp"
  role = aws_iam_role.sftp_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.sftp_bucket.arn}"
            ]
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetBucketLocation",
                "s3:GetObjectVersion",
                "s3:GetObjectACL",
                "s3:PutObjectACL"
            ],
            "Resource": "${aws_s3_bucket.sftp_bucket.arn}/*"
        }
    ]
}
POLICY
}

resource "aws_transfer_user" "sftp_user" {
  server_id = aws_transfer_server.sftp.id
  user_name = "sftp_user"
  role      = aws_iam_role.sftp_role.arn
  home_directory_type = "LOGICAL"

  home_directory_mappings {
      entry  = "/"
      target = "/${aws_s3_bucket.sftp_bucket.id}/$${Transfer:UserName}"
  }

}
