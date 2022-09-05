variable "org" {
  type = string
  description = "Organization name"
}

variable "project" {
  type = string
  description = "Project name"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "environment" {
  type = string
  description = "Environment name to be prefixed in resource names"
}

variable "AWS_DEFAULT_REGION" {
  type = string
  description = "The region to provison the resources in"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "AWS Access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "AWS Secret Access key"
}

variable "sap_vpc" {
  type = string
  description = "CIDR block of the SAP VPC"
}

variable "workspace_vpc" {
  type = string
  description = "CIDR block of the AWS Workspace VPC"
}

variable "transit_gtway_id" {
  type = string
  description = "ID of the Transit Gateway"
}

variable "domain_name" {
  description = "Domain name"
}

variable "domain_name_servers" {
  description = "List of DNS Servers"
}

variable "ntp_servers" {
  description = "List of NTP Servers"
}

# Define variables for public vpc

variable "cidr_ingress" {
  type = string
  description = "CIDR block to be used for VPC, e.g. 10.5.0.0/16"
}

variable "allowed_dbt_ips" {
    description = "The IP of dbt servers"
    type        = list(string)
    default     = ["152.45.144.63/32", "54.81.134.249/32", "52.22.161.231/32"]
}

variable "public_subnets_tgw" {
  type = list(string)
  description = "List of subnets dedicated to the transit gateway"
}

variable "public_subnets_workloads" {
  type = list(string)
  description = "List of subnets for the workloads"
}

variable "public_availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["us-east-2a", "us-east-2b"]
}

variable "ami_id" {
  description = "AMI ID for Bastion host in Public subnet"
  default = "ami-051dfed8f67f095f5"
}

variable "bastion_host_key" {
  description = "SSH Key for the Bastion host in Public subnet"
  default = "aws-deloitte.key"
}

variable "dev_vpc" {
    description = "The Dev VPC"
    type        = string
    default     = "10.155.88.0/21"
}

variable "test_vpc" {
    description = "The Test VPc"
    type        = string
    default     = "10.155.96.0/21"
}
