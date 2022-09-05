# Project name
org = "netxillon" 

# Project name
project = "data_platform" 

# Environment name to be prefixed in resource names
environment = "prod" 

# AWS region name to be used for resource provisioning
region = "ap-southeast-2"  

# VPC parameters
cidr = "10.155.104.0/21"
private_subnets_tgw  = ["10.155.104.0/28", "10.155.104.16/28","10.155.104.32/28"]
private_subnets_workloads  = ["10.155.106.0/23", "10.155.108.0/23", "10.155.110.0/23"]
availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

# DHCP Uptions for VPC
domain_name          = "netxillon.com"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["220.158.215.21", "103.126.53.123"]

# Route 53 Domains
route_domain1        = "netxillon.net"
route_domain2        = "example.net"

# Route table CIDRs
shared_vpc = "11.1.1.0/24"
app_vpc = "11.1.2.0/24"
database_vpc = "11.1.3.0/24"

# Trasit Gateway ID

transit_gtway_id = "tgw-0876b783513e11e3e"
