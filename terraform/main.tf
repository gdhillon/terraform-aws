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

