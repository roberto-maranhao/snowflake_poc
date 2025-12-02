-- Create Terraform service users
-- Run this script as ACCOUNTADMIN after running 00_snowflake_initial_setup.sql
-- Replace the passwords with strong, unique passwords

-- Switch to ACCOUNTADMIN role
USE ROLE ACCOUNTADMIN;

-- Create development service user
-- IMPORTANT: Replace 'YOUR_STRONG_DEV_PASSWORD' with a strong, unique password
CREATE USER IF NOT EXISTS TERRAFORM_DEV_USER
    PASSWORD = 'SUPER_DUPER_STRONG_DEV_PASSWORD'
    DEFAULT_ROLE = 'TERRAFORM_DEV_ROLE'
    DEFAULT_WAREHOUSE = 'DEV_WH'
    DEFAULT_NAMESPACE = 'DEV_DB.PUBLIC'
    COMMENT = 'Service user for Terraform development environment automation'
    MUST_CHANGE_PASSWORD = FALSE;

-- Create production service user  
-- IMPORTANT: Replace 'YOUR_STRONG_PROD_PASSWORD' with a strong, unique password
CREATE USER IF NOT EXISTS TERRAFORM_PROD_USER
    PASSWORD = 'SUPER_DUPER_STRONG_PROD_PASSWORD'
    DEFAULT_ROLE = 'TERRAFORM_PROD_ROLE'
    DEFAULT_WAREHOUSE = 'PROD_WH'
    DEFAULT_NAMESPACE = 'PROD_DB.PUBLIC'
    COMMENT = 'Service user for Terraform production environment automation'
    MUST_CHANGE_PASSWORD = FALSE;

-- Grant the custom roles to the service users
GRANT ROLE TERRAFORM_DEV_ROLE TO USER TERRAFORM_DEV_USER;
GRANT ROLE TERRAFORM_PROD_ROLE TO USER TERRAFORM_PROD_USER;

-- Enable the roles for the users
ALTER USER TERRAFORM_DEV_USER SET DEFAULT_ROLE = 'TERRAFORM_DEV_ROLE';
ALTER USER TERRAFORM_PROD_USER SET DEFAULT_ROLE = 'TERRAFORM_PROD_ROLE';

-- Display the created users (for verification)
SHOW USERS LIKE 'TERRAFORM_%';

-- Display the roles (for verification)
SHOW ROLES LIKE 'TERRAFORM_%';

-- Test the users (optional - you can run these separately)
-- USE ROLE TERRAFORM_DEV_ROLE;
-- USE WAREHOUSE DEV_WH;
-- USE DATABASE DEV_DB;
-- SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE();