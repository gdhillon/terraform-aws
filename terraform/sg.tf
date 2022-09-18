resource "aws_security_group" "public_local_vpc" {
  name        = "${var.org}-${var.project}-public_local_vpc"
  description = "Allow traffic within the VPC"
  vpc_id      = aws_vpc.ingress_vpc.id

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    self = true
  }

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = [aws_vpc.ingress_vpc.cidr_block]
    description = "Allow traffic within the VPC"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-public_local_vpc"
  }
}

resource "aws_security_group" "dbt_cloud" {
  name        = "${var.org}-${var.project}-dbt_cloud"
  description = "Allow traffic from shared VPC"
  vpc_id      = aws_vpc.ingress_vpc.id

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = "${var.allowed_dbt_ips}"
    description = "Allow traffic from dbt cloud servers"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-dbt_cloud"
  }
}

resource "aws_security_group" "public_workspace_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-shared-vpc"
  description = "Allow traffic from shared VPC"
  vpc_id      = aws_vpc.ingress_vpc.id

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = [var.database_vpc]
    description = "Allow traffic from shared VPC"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-shared-vpc"
  }
}

