terraform {
  backend "s3" {
    # Configure your S3 backend here
    # bucket = "your-terraform-state-bucket"
    # key    = "snowflake-poc/prod/terraform.tfstate"
    # region = "us-east-1"
    
    # Alternative: use local backend for development
    # Remove the backend block to use local state
  }
}

# Include the main terraform configuration
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

# Configure the Snowflake provider
provider "snowflake" {
  account   = var.snowflake_account
  username  = var.snowflake_username
  password  = var.snowflake_password
  role      = var.snowflake_role
  region    = var.snowflake_region
}

# Use the main module
module "snowflake_infrastructure" {
  source = "../../"
  
  environment      = "prod"
  database_name    = "PROD_DB"
  warehouse_name   = "PROD_WH"
  warehouse_size   = "SMALL"
  schemas          = ["PUBLIC", "STAGING", "ANALYTICS"]
  
  snowflake_account  = var.snowflake_account
  snowflake_username = var.snowflake_username
  snowflake_password = var.snowflake_password
  snowflake_role     = var.snowflake_role
  snowflake_region   = var.snowflake_region
}