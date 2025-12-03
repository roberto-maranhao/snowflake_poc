-- Snowflake Initial Setup Script
-- Run this script as ACCOUNTADMIN to create the necessary users, roles, and databases
-- for Terraform automation

-- Switch to ACCOUNTADMIN role
USE ROLE ACCOUNTADMIN;

-- Create custom roles for dev and prod environments
CREATE ROLE IF NOT EXISTS TERRAFORM_DEV_ROLE 
    COMMENT = 'Role for Terraform to manage development resources';
    
CREATE ROLE IF NOT EXISTS TERRAFORM_PROD_ROLE 
    COMMENT = 'Role for Terraform to manage production resources';

-- Create warehouses
CREATE WAREHOUSE IF NOT EXISTS DEV_WH 
    WITH WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Development warehouse for Terraform-managed resources';

CREATE WAREHOUSE IF NOT EXISTS PROD_WH 
    WITH WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Production warehouse for Terraform-managed resources';

-- Create databases
CREATE DATABASE IF NOT EXISTS DEV_DB 
    COMMENT = 'Development database managed by Terraform';
    
CREATE DATABASE IF NOT EXISTS PROD_DB 
    COMMENT = 'Production database managed by Terraform';

-- Grant privileges to custom roles

-- DEV ROLE GRANTS
-- Grant ownership (this includes all privileges)
GRANT OWNERSHIP ON WAREHOUSE DEV_WH TO ROLE TERRAFORM_DEV_ROLE REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON DATABASE DEV_DB TO ROLE TERRAFORM_DEV_ROLE REVOKE CURRENT GRANTS;

-- PROD ROLE GRANTS
-- Grant ownership (this includes all privileges)
GRANT OWNERSHIP ON WAREHOUSE PROD_WH TO ROLE TERRAFORM_PROD_ROLE REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON DATABASE PROD_DB TO ROLE TERRAFORM_PROD_ROLE REVOKE CURRENT GRANTS;

-- Grant role creation privileges (needed for Terraform to create application roles)
GRANT CREATE ROLE ON ACCOUNT TO ROLE TERRAFORM_DEV_ROLE;
GRANT CREATE ROLE ON ACCOUNT TO ROLE TERRAFORM_PROD_ROLE;

-- Grant role management privileges (needed to manage existing roles)
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE TERRAFORM_DEV_ROLE;
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE TERRAFORM_PROD_ROLE;

-- Grant ownership and full control over created resources
GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE DEV_DB TO ROLE TERRAFORM_DEV_ROLE REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE PROD_DB TO ROLE TERRAFORM_PROD_ROLE REVOKE CURRENT GRANTS;

-- Grant user creation privileges (if needed)
GRANT CREATE USER ON ACCOUNT TO ROLE TERRAFORM_DEV_ROLE;
GRANT CREATE USER ON ACCOUNT TO ROLE TERRAFORM_PROD_ROLE;

-- Grant warehouse creation privileges (if Terraform needs to create warehouses)
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE TERRAFORM_DEV_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE TERRAFORM_PROD_ROLE;

-- Grant database creation privileges (if Terraform needs to create databases)
GRANT CREATE DATABASE ON ACCOUNT TO ROLE TERRAFORM_DEV_ROLE;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE TERRAFORM_PROD_ROLE;