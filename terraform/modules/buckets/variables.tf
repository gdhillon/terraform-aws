variable "environment" {
  type        = string
  description = "Platform environment name [`dev`, `prod`]"
}

variable "business_unit" {
  type        = string
  description = "Business unit"

}

variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

variable "classification" {
  type        = string
  description = "data classification"
}

// refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning#versioning_configuration

variable "versioning" {
  type        = string
  description = "This flag is to either enable or disable S3 versioning; note that previously enabled buckets can only be suspended"
  validation {
    condition     = contains(["Disabled", "Suspended", "Enabled"], var.versioning)
    error_message = "Invalid input, options: \"Disabled\", \"Suspended\", \"Enabled\"."
  }
}

variable "is_acl_on" {
  type        = string
  description = "This flag is to adopt new ACL updates as mentioned in this link https://aws.amazon.com/blogs/aws/heads-up-amazon-s3-security-changes-are-coming-in-april-of-2023/"
  default = true
}

variable "allow_ssl_requests_only" {
  type        = bool
  description = "This flag is to enable Secure Socket Layer in S3 Bucket Policy as per - Security Standard - S3.5 S3 buckets should require requests to use Secure Socket Layer"
  default = true
}

