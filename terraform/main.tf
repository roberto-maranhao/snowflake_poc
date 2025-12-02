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

# Variables
variable "snowflake_account" {
  description = "Snowflake account identifier"
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