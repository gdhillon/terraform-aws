module "bronze-confidential" {
  source      = "./modules/bucket"
  environment = var.environment
  bucket_name    = "deloittify-${var.environment}-bronze-confidential"
  versioning     = "Suspended"
  is_acl_on      = var.environment == "lab" ? false : true
}

module "data-gold" {
   source         = "./modules/bucket"
   environment    = var.environment
   bucket_name    = "deloittify-dsc-${var.environment}-gold"
   versioning     = "Suspended"
   is_acl_on      = true
}

