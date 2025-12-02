# Snowflake Setup Guide

This guide will walk you through setting up Snowflake users and databases for Terraform automation.

## Prerequisites

1. **Snowflake Account** with ACCOUNTADMIN privileges
2. **SnowSQL CLI** installed (recommended) or access to Snowflake Web UI
3. **GitHub Repository** with admin access to configure secrets

## Step 1: Generate Strong Passwords

Generate strong passwords for your Terraform service users:

```bash
# Generate development password
openssl rand -base64 32

# Generate production password  
openssl rand -base64 32
```

**⚠️ Save these passwords securely - you'll need them for the SQL scripts and GitHub secrets!**

## Step 2: Update SQL Scripts with Passwords

1. Edit `setup/01_create_terraform_users.sql`
2. Replace `YOUR_STRONG_DEV_PASSWORD` with the dev password you generated
3. Replace `YOUR_STRONG_PROD_PASSWORD` with the prod password you generated

## Step 3: Execute Snowflake Setup Scripts

### Option A: Using SnowSQL (Recommended)

```bash
# Connect to Snowflake as ACCOUNTADMIN
snowsql -a your-account.region.snowflakecomputing.com -u your-admin-username

# Execute the setup scripts
!source setup/00_snowflake_initial_setup.sql
!source setup/01_create_terraform_users.sql
```

### Option B: Using Snowflake Web UI

1. Copy the contents of `setup/00_snowflake_initial_setup.sql`
2. Paste and execute in Snowflake Web UI worksheets
3. Copy the contents of `setup/01_create_terraform_users.sql` 
4. Paste and execute in Snowflake Web UI worksheets

## Step 4: Verify Setup

Run this query to verify everything was created correctly:

```sql
-- Verify users
SHOW USERS LIKE 'TERRAFORM_%';

-- Verify roles  
SHOW ROLES LIKE 'TERRAFORM_%';

-- Verify databases
SHOW DATABASES LIKE '%_DB';

-- Verify warehouses
SHOW WAREHOUSES LIKE '%_WH';
```

## Step 5: Configure GitHub Repository Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:

### Development Secrets
- **Name**: `SNOWFLAKE_DEV_ACCOUNT`
  - **Value**: `your-account.region.snowflakecomputing.com`
- **Name**: `SNOWFLAKE_DEV_USERNAME`  
  - **Value**: `TERRAFORM_DEV_USER`
- **Name**: `SNOWFLAKE_DEV_PASSWORD`
  - **Value**: `[the dev password you generated]`
- **Name**: `SNOWFLAKE_DEV_ROLE`
  - **Value**: `TERRAFORM_DEV_ROLE`

### Production Secrets  
- **Name**: `SNOWFLAKE_PROD_ACCOUNT`
  - **Value**: `your-account.region.snowflakecomputing.com`
- **Name**: `SNOWFLAKE_PROD_USERNAME`
  - **Value**: `TERRAFORM_PROD_USER` 
- **Name**: `SNOWFLAKE_PROD_PASSWORD`
  - **Value**: `[the prod password you generated]`
- **Name**: `SNOWFLAKE_PROD_ROLE`
  - **Value**: `TERRAFORM_PROD_ROLE`

### Additional Production Secret
- **Name**: `PROD_APPROVERS`
  - **Value**: `your-github-username,other-approver-username` (comma-separated)

## Step 6: Create terraform.tfvars Files for Local Testing

### Development Environment

```bash
cd terraform/environments/dev

cat > terraform.tfvars << EOF
snowflake_account  = "your-account.region.snowflakecomputing.com"
snowflake_username = "TERRAFORM_DEV_USER"
snowflake_password = "your-generated-dev-password"
snowflake_role     = "TERRAFORM_DEV_ROLE"
EOF
```

### Production Environment

```bash
cd terraform/environments/prod

cat > terraform.tfvars << EOF
snowflake_account  = "your-account.region.snowflakecomputing.com"
snowflake_username = "TERRAFORM_PROD_USER"
snowflake_password = "your-generated-prod-password"
snowflake_role     = "TERRAFORM_PROD_ROLE"
EOF
```

## Step 7: Test Terraform Configuration

```bash
# Test development environment
cd terraform/environments/dev
terraform init
terraform plan

# Test production environment  
cd terraform/environments/prod
terraform init
terraform plan
```

```bash
# Create and push development branch
git checkout -b development
git push -u origin development

# Create and push production branch  
git checkout -b production
git push -u origin production

# Return to main
git checkout main
```

## Step 8: Create Development and Production Branches

```bash
# Create and push development branch
git checkout -b development
git push -u origin development

# Create and push production branch  
git checkout -b production
git push -u origin production

# Return to main
git checkout main
```

## Step 9: Test the Complete Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/test-terraform-setup
   ```

2. **Make a small change** (e.g., add a comment to a SQL file)

3. **Create PR to development branch** - this should trigger the dev deployment

4. **Create PR to production branch** - this should require manual approval

## Troubleshooting

### Common Issues

1. **Insufficient Privileges**: Ensure you're running setup scripts as ACCOUNTADMIN
2. **Password Policy**: Ensure passwords meet your organization's requirements  
3. **Account Identifier**: Use the full account identifier including region
4. **Role Assignment**: Verify users have the correct default roles assigned

### Useful Queries

```sql
-- Check user privileges
SHOW GRANTS TO USER TERRAFORM_DEV_USER;
SHOW GRANTS TO USER TERRAFORM_PROD_USER;

-- Check role privileges  
SHOW GRANTS TO ROLE TERRAFORM_DEV_ROLE;
SHOW GRANTS TO ROLE TERRAFORM_PROD_ROLE;

-- Test user login
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE();
```

## Security Best Practices

1. **Rotate Passwords Regularly**: Update service account passwords periodically
2. **Limit Permissions**: Users only have access to their respective environments
3. **Monitor Usage**: Review Snowflake query history for service accounts
4. **Separate Environments**: Dev and prod are completely isolated
5. **GitHub Secrets**: Never commit credentials to version control

## Next Steps

After completing this setup, you can:
- Create PRs to test the automated deployment workflows
- Add more SQL objects (tables, views, procedures) to your environment
- Configure additional Snowflake features through Terraform
- Set up monitoring and alerting for your Snowflake resources