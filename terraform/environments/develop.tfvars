# Project name
org = "netxillon" 

# Project name
project = "data_lake" 

# Environment name to be prefixed in resource names
environment = "dev" 

# AWS region name to be used for resource provisioning
region = "us-east-2"  

# VPC parameters
cidr = "10.15.88.0/21"
private_subnets_tgw  = ["10.15.88.0/28", "10.15.88.16/28","10.15.88.32/28"]
private_subnets_redshift  = ["10.15.88.112/28", "10.15.88.128/28"]
private_subnets_workloads  = ["10.15.90.0/23", "10.15.92.0/23", "10.15.94.0/23"]
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

# DHCP Uptions for VPC
domain_name          = "netxillon.net"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["169.254.169.123"]

# Route 53 Domains
route_domain1	     = "netxillon.net"
route_domain2        = "example.net"

# Route table CIDRs
shared_vpc = "10.155.8.0/21"
app_vpc = "10.155.56.0/21"
database_vpc = "10.155.64.0/21"

# Trasit Gateway ID
transit_gtway_id = "tgw-0337056ae6b70ebb3"

