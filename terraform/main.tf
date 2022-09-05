resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org}-${var.project}-vpc-${var.environment}"
  }  
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name          = var.domain_name
  domain_name_servers  = var.domain_name_servers
  ntp_servers          = var.ntp_servers

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

resource "aws_security_group" "local_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-local-vpc"
  description = "Allow traffic within the VPC"
  vpc_id      = aws_vpc.main.id

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
    cidr_blocks   = [aws_vpc.main.cidr_block]
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
    Name = "${var.org}-${var.project}-${var.environment}-local-vpc"
  }  
}

resource "aws_security_group" "shared_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-shared-vpc"
  description = "Allow traffic from shared VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = [var.shared_vpc]
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

resource "aws_security_group" "sap_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-sap-vpc"
  description = "Allow traffic from SAP VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = [var.sap_vpc]
    description = "Allow traffic from SAP VPC"
  }
  
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-sap-vpc"
  }
}

resource "aws_security_group" "workspace_vpc" {
  name        = "${var.org}-${var.project}-${var.environment}-workspace-vpc"
  description = "Allow traffic from Workspace VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol      = -1
    from_port     = 0
    to_port       = 0
    cidr_blocks   = [var.workspace_vpc]
    description = "Allow traffic from Workspace VPC"
  }
  
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-workspace-vpc"
  }
}

resource "aws_subnet" "tgw_private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_tgw, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets_tgw)

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-tgw-dedicated${count.index}"
  }    
}

resource "aws_subnet" "workload_private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_workloads, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets_workloads)

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-workloads${count.index}"
  }   
}

resource "aws_subnet" "redshift_private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_redshift, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets_redshift)

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-redshift${count.index}"
  }   
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = "${aws_subnet.tgw_private.*.id}"
  transit_gateway_id = var.transit_gtway_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = "Data-Analytics-${var.environment}-Attachment-${var.cidr}"
  }


}

resource "aws_route" "route_all_traffic" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table]
}

resource "aws_route" "route_shared_vpc" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = var.shared_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table]
}

resource "aws_route" "route_sap_vpc" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = var.sap_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table]
}

resource "aws_route" "route_workspace_vpc" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = var.workspace_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table]
}

resource "aws_route_table_association" "tgw" {
  count           = "${length(var.private_subnets_tgw)}"
  subnet_id       = "${element(aws_subnet.tgw_private.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table.id
}

resource "aws_route_table_association" "workloads" {
  count           = "${length(var.private_subnets_workloads)}"
  subnet_id       = "${element(aws_subnet.workload_private.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table.id
}

