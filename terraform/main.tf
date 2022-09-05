resource "aws_vpc" "ingress_vpc" {
  cidr_block           = var.cidr_ingress
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org}-${var.project}-vpc-ingress"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ingress_vpc.id

  tags = {
    Name = "${var.org}-${var.project}-vpc-ingress"
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
  vpc_id          = aws_vpc.ingress_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

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
    cidr_blocks   = [var.workspace_vpc]
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

resource "aws_subnet" "tgw_public" {
  vpc_id            = aws_vpc.ingress_vpc.id
  cidr_block        = element(var.public_subnets_tgw, count.index)
  availability_zone = element(var.public_availability_zones, count.index)
  count             = length(var.public_subnets_tgw)

  tags = {
    Name = "${var.org}-${var.project}-public-tgw-dedicated${count.index}"
  }
}

resource "aws_subnet" "workload_public" {
  vpc_id            = aws_vpc.ingress_vpc.id
  cidr_block        = element(var.public_subnets_workloads, count.index)
  availability_zone = element(var.public_availability_zones, count.index)
  count             = length(var.public_subnets_workloads)

  tags = {
    Name = "${var.org}-${var.project}-public-workloads${count.index}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "public_tgw_attach" {
  subnet_ids         = "${aws_subnet.tgw_public.*.id}"
  transit_gateway_id = var.transit_gtway_id
  vpc_id             = aws_vpc.ingress_vpc.id

  tags = {
    Name = "Data-Analytics-${var.environment}-Attachment-${var.cidr_ingress}"
  }
}

resource "aws_default_route_table" "default_route_table_public_vpc" {
  default_route_table_id = aws_vpc.ingress_vpc.default_route_table_id

  tags = {
    Name = "${var.org}-${var.project}-${var.environment}-public"
  }
}

resource "aws_route_table_association" "public_tgw" {
  count           = "${length(var.public_subnets_tgw)}"
  subnet_id       = "${element(aws_subnet.tgw_public.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_public_vpc.id
}

resource "aws_route_table_association" "public_workloads" {
  count           = "${length(var.public_subnets_workloads)}"
  subnet_id       = "${element(aws_subnet.workload_public.*.id, count.index)}"
  route_table_id  = aws_default_route_table.default_route_table_public_vpc.id
}

resource "aws_route" "route_public_traffic" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id	            = aws_internet_gateway.gw.id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

resource "aws_route" "route_dev_vpc" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = var.dev_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

resource "aws_route" "route_test_vpc" {
  route_table_id            = aws_default_route_table.default_route_table_public_vpc.id
  destination_cidr_block    = var.test_vpc
  transit_gateway_id        = var.transit_gtway_id
  depends_on                = [aws_default_route_table.default_route_table_public_vpc]
}

resource "aws_instance" "bastion" {
   instance_type 		= "t2.micro"
   ami 		 		= "${var.ami_id}"
   subnet_id 			= "${aws_subnet.workload_public[0].id}"
   key_name 			= "${var.bastion_host_key}"
   associate_public_ip_address 	= true
   disable_api_termination   	= true
   monitoring			= true
   vpc_security_group_ids 	= ["${aws_security_group.dbt_cloud.id}","${aws_security_group.public_local_vpc.id}","${aws_security_group.public_workspace_vpc.id}"]

root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.org}-${var.project}-bastion-root-volume"
    }
  }

tags = {
    Name = "${var.org}-${var.project}-bastion"
  }
}

resource "aws_eip" "bastion_host_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
      Name = "${var.org}-${var.project}-bastion-eip"
    }
}
