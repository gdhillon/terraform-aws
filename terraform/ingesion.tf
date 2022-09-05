resource "aws_iam_role" "glue_role" {
  name = "${var.org}-${var.project}-${var.environment}-glueAccessRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "glue.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

locals {
  managed_policy_arns_for_glue = [ "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
                                    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
                                    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
                                    "arn:aws:iam::aws:policy/AWSXrayFullAccess",
                                    "arn:aws:iam::aws:policy/AdministratorAccess",
                                    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
}

resource "aws_iam_role_policy_attachment" "glue-attachment" {
  role       = "${aws_iam_role.glue_role.name}"
  count      = "${length(local.managed_policy_arns_for_glue)}"
  policy_arn = "${local.managed_policy_arns_for_glue[count.index]}"
}

resource "aws_iam_role" "s3_role" {
  name = "${var.org}-${var.project}-${var.environment}-S3Role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_access" {
  name = "${var.org}-${var.project}-${var.environment}-S3Access"
  role = aws_iam_role.s3_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.sftp_bucket.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
locals {
  managed_policy_arns_for_s3_access_role    = [ "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
                                                "arn:aws:iam::aws:policy/AWSXrayFullAccess",
                                                "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
}

resource "aws_iam_role_policy_attachment" "s3-attachment" {
  role       = "${aws_iam_role.s3_role.name}"
  count      = "${length(local.managed_policy_arns_for_s3_access_role)}"
  policy_arn = "${local.managed_policy_arns_for_s3_access_role[count.index]}"
}
