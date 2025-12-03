# Terraform configuration for Snowflake infrastructure
# Updated setup script with clean ownership grants
terraform {
  required_version = ">= 1.0"

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 0.96"
    }
  }
}

# Configure the Snowflake Provider
provider "snowflake" {
  account_name      = var.snowflake_account_name
  organization_name = var.snowflake_organization_name
  user              = var.snowflake_username
  password          = var.snowflake_password
  role              = var.snowflake_role
}

# Variables
variable "snowflake_account_name" {
  description = "Snowflake account name"
  type        = string
}

variable "snowflake_organization_name" {
  description = "Snowflake organization name"
  type        = string
}

variable "snowflake_username" {
  description = "Snowflake username"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
  sensitive   = true
}

variable "snowflake_role" {
  description = "Snowflake role"
  type        = string
  default     = "TERRAFORM_DEV_ROLE"
}

variable "snowflake_region" {
  description = "Snowflake region"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "warehouse_name" {
  description = "Warehouse name"
  type        = string
}

variable "warehouse_size" {
  description = "Warehouse size"
  type        = string
  default     = "X-SMALL"
}

variable "schemas" {
  description = "List of schemas to create"
  type        = list(string)
  default     = ["PUBLIC", "STAGING", "ANALYTICS"]
}