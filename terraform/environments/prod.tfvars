# Project name
org = "netxillon" 

# Project name
project = "data_lake" 

# Environment name to be prefixed in resource names
environment = "prod" 

# AWS region name to be used for resource provisioning
region = "us-east-2"  

# VPC parameters
cidr = "10.155.104.0/21"
private_subnets_tgw  = ["10.155.104.0/28", "10.155.104.16/28","10.155.104.32/28"]
private_subnets_workloads  = ["10.155.106.0/23", "10.155.108.0/23", "10.155.110.0/23"]
availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

# DHCP Uptions for VPC
domain_name          = "lion.aws"
domain_name_servers  = ["AmazonProvidedDNS"]
ntp_servers          = ["203.29.242.183", "169.254.169.123"]

# Route table CIDRs
shared_vpc = "10.155.8.0/21"
sap_vpc = "10.155.56.0/21"
workspace_vpc = "10.155.64.0/21"

# Trasit Gateway ID

transit_gtway_id = "tgw-0876b783513e11e3e"
