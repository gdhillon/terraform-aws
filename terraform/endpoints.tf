
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = tolist(["${aws_default_route_table.default_route_table.id}"])

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-s3"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = tolist(["${aws_default_route_table.default_route_table.id}"])
  
  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-dynamodb"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = "${aws_subnet.workload_private.*.id}"

  security_group_ids = [
    aws_security_group.local_vpc.id,
    aws_security_group.shared_vpc.id
  ]
  
  private_dns_enabled = true

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-secretsmanager"
  }
}

resource "aws_vpc_endpoint" "monitoring" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.monitoring"
  vpc_endpoint_type = "Interface"
  subnet_ids        = "${aws_subnet.workload_private.*.id}"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.local_vpc.id,
    aws_security_group.shared_vpc.id
  ]

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-monitoring"
  }
}

resource "aws_vpc_endpoint" "redshift" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.redshift"
  vpc_endpoint_type = "Interface"
  subnet_ids        = "${aws_subnet.workload_private.*.id}"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.local_vpc.id,
    aws_security_group.shared_vpc.id
  ]

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-redshift"
  }
}
