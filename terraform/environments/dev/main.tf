terraform {
  # Using local backend for development
  # For production, configure S3 backend:
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "snowflake-poc/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
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
  account  = var.snowflake_account
  username = var.snowflake_username
  password = var.snowflake_password
  role     = "TERRAFORM_DEV_ROLE"
  region   = var.snowflake_region
}

# Use the main module
module "snowflake_infrastructure" {
  source = "../../"

  environment    = "dev"
  database_name  = "DEV_DB"
  warehouse_name = "DEV_WH"
  warehouse_size = "X-SMALL"
  schemas        = ["PUBLIC", "STAGING", "ANALYTICS", "TESTING"]

  snowflake_account  = var.snowflake_account
  snowflake_username = var.snowflake_username
  snowflake_password = var.snowflake_password
  snowflake_role     = "TERRAFORM_DEV_ROLE"
  snowflake_region   = var.snowflake_region
}