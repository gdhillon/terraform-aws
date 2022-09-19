resource "aws_iam_role" "data_scientists_full" {
  name = "AWS-Data-Scientists-FullAccess-${upper(var.environment)}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": [
                "sagemaker.amazonaws.com",
                "ds.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_caller_identity" "current" {}

locals {
  managed_policy_arns_for_ScientistsFull = [
			  "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
			  "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds",
			  "arn:aws:iam::aws:policy/service-role/AWSLambdaRole",
			  "arn:aws:iam::aws:policy/AWSLambdaExecute",
			  "arn:aws:iam::aws:policy/service-role/AmazonSageMakerServiceCatalogProductsLambdaServiceRolePolicy",
			  "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
			  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
			  "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
			  "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
			  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
			]

}

resource "aws_iam_role_policy_attachment" "ScientistsFull" {
  role       = "${aws_iam_role.data_scientists_full.name}"
  count      = "${length(local.managed_policy_arns_for_ScientistsFull)}"
  policy_arn = "${local.managed_policy_arns_for_ScientistsFull[count.index]}"
}

resource "aws_iam_role" "data_analytics_full" {
  name = "AWS-Data-Analytics-FullAccess-${upper(var.environment)}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": [
                "ec2.amazonaws.com",
                "ds.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


locals {
  managed_policy_arns_for_analyticsFull = [
			  "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess",
			  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
			  "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
			  "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
			  "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess",
			  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
				]
}

resource "aws_iam_role_policy_attachment" "analyticsFull" {
  role       = "${aws_iam_role.data_analytics_full.name}"
  count      = "${length(local.managed_policy_arns_for_analyticsFull)}"
  policy_arn = "${local.managed_policy_arns_for_analyticsFull[count.index]}"
}

resource "aws_iam_role" "data_engineer_full" {
  name = "AWS-Data-Engineer-FullAccess-${upper(var.environment)}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": [
                "ec2.amazonaws.com",
                "ds.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

locals {
  managed_policy_arns_for_data_engineerFull = [
		  "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess",
		  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
		  "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
		  "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
          	  "arn:aws:iam::aws:policy/service-role/AWSLambdaRole",
          	  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
          	  "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
          	  "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
		  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
		  "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
				]
}

resource "aws_iam_role_policy_attachment" "data_engineerFull" {
  role       = "${aws_iam_role.data_engineer_full.name}"
  count      = "${length(local.managed_policy_arns_for_data_engineerFull)}"
  policy_arn = "${local.managed_policy_arns_for_data_engineerFull[count.index]}"
}

