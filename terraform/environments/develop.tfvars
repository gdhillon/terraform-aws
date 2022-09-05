# Project name
org = "netxillon" 

# Project name
project = "data_lake" 

# Environment name to be prefixed in resource names
environment = "dev" 

# AWS region name to be used for resource provisioning
region = "us-east-2"  

# VPC Internet Facing
cidr_ingress = "10.101.101.0/26"
public_subnets_tgw  = ["10.101.101.0/28", "10.101.101.16/28"]
public_subnets_workloads  = ["10.101.101.32/28", "10.101.101.48/28"]
public_availability_zones = ["us-east-2a", "us-east-2b"]

# DHCP Uptions for VPC
domain_name          = "netxillon.net"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["169.254.169.123"]

# Route 53 Domains
route_domain1	     = "netxillon.net"
route_domain2        = "example.net"

# Route table CIDRs
shared_vpc = "11.1.1.0/24"
app_vpc = "11.1.2.0/24"
database_vpc = "11.1.3.0/24"

# Trasit Gateway ID
transit_gtway_id = "tgw-0337056ae6b70ebb3"

ami_id = "ami-051dfed8f67f095f5"
