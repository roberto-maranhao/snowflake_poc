# Snowflake POC Repository

This repository contains Terraform infrastructure as code for managing Snowflake resources across development and production environments.

## Project Structure

```
snowflake_poc/
├── .github/workflows/          # GitHub Actions CI/CD workflows
│   ├── terraform-plan-dev.yml  # Dev environment deploy on PR
│   └── terraform-plan-prod.yml # Prod environment deploy on PR (with approval)
├── sql/                        # SQL scripts organized by type
│   ├── migrations/             # Database migrations
│   ├── schemas/               # Schema definitions
│   ├── procedures/            # Stored procedures
│   ├── functions/             # User-defined functions
│   └── views/                 # View definitions
└── terraform/                 # Terraform configuration
    ├── environments/          # Environment-specific configurations
    │   ├── dev/              # Development environment
    │   └── prod/             # Production environment
    ├── main.tf               # Main Terraform configuration
    ├── resources.tf          # Resource definitions
    ├── outputs.tf            # Output values
    └── variables.tf          # Variable definitions (moved to main.tf)
```

## Branch Strategy

- `main`: Main branch for general development
- `development`: Development environment branch - merges trigger dev deployments
- `production`: Production environment branch - merges trigger prod deployments

## Terraform Setup

### Prerequisites

1. **Terraform >= 1.6.0**
2. **Snowflake account with appropriate permissions**
3. **Git repository secrets configured**

### Environment Configuration

**⚠️ Important: No Local Credentials Required!**

All authentication is handled through GitHub repository secrets. You do not need to store any Snowflake credentials locally.

#### For Local Development/Testing (Optional)

If you want to test Terraform configurations locally:

1. Navigate to the environment directory:
   ```bash
   cd terraform/environments/dev  # or prod
   ```

2. Create a local terraform.tfvars file (not committed to git):
   ```bash
   # This file is git-ignored for security
   cat > terraform.tfvars << EOF
   snowflake_account  = "your-account.region.snowflakecomputing.com"
   snowflake_username = "your-username"
   snowflake_password = "your-password"
   snowflake_role     = "SYSADMIN"
   EOF
   ```

3. Initialize and plan:
   ```bash
   terraform init
   terraform plan
   ```

**Production deployments should only be done through GitHub Actions workflows.**

### Manual Deployment

#### Deploy Development Environment

```bash
cd terraform/environments/dev
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

#### Deploy Production Environment

```bash
cd terraform/environments/prod
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## GitHub Actions Setup

### Required Repository Secrets

Configure these secrets in your GitHub repository settings:

#### Development Environment
- `SNOWFLAKE_DEV_ACCOUNT`: Snowflake account identifier
- `SNOWFLAKE_DEV_USERNAME`: Development username
- `SNOWFLAKE_DEV_PASSWORD`: Development password
- `SNOWFLAKE_DEV_ROLE`: Development role (typically `SYSADMIN`)

#### Production Environment
- `SNOWFLAKE_PROD_ACCOUNT`: Snowflake account identifier
- `SNOWFLAKE_PROD_USERNAME`: Production username
- `SNOWFLAKE_PROD_PASSWORD`: Production password
- `SNOWFLAKE_PROD_ROLE`: Production role (typically `SYSADMIN`)
- `PROD_APPROVERS`: Comma-separated list of GitHub usernames who can approve production deployments

### Workflow Triggers

#### Development Workflow
- **Deploy**: Triggered on PR to `development` branch (automatic apply)

#### Production Workflow
- **Deploy**: Triggered on PR to `production` branch (requires manual approval before apply)

## Resources Created

The Terraform configuration creates the following Snowflake resources:

### Development Environment
- **Database**: `DEV_DB`
- **Warehouse**: `DEV_WH` (X-SMALL)
- **Schemas**: `PUBLIC`, `STAGING`, `ANALYTICS`, `TESTING`
- **Roles**: `DEV_APP_ROLE`, `DEV_READ_ROLE`

### Production Environment
- **Database**: `PROD_DB`
- **Warehouse**: `PROD_WH` (SMALL)
- **Schemas**: `PUBLIC`, `STAGING`, `ANALYTICS`
- **Roles**: `PROD_APP_ROLE`, `PROD_READ_ROLE`
- **Resource Monitor**: `PROD_WH_MONITOR` (1000 credit limit)

## SQL File Management

SQL files in the `sql/` directory are organized by type:

- **migrations/**: Version-controlled database changes (numbered for order)
- **schemas/**: Schema creation and modification scripts
- **procedures/**: Stored procedure definitions
- **functions/**: User-defined function definitions
- **views/**: View definitions

### Example SQL Files

The repository includes example files:
- `001_create_initial_tables.sql`: Creates users, products, and orders tables
- `user_orders_summary.sql`: View for user order summaries
- `get_user_order_history.sql`: Stored procedure for order history
- `calculate_order_total_with_tax.sql`: Function for tax calculations

## Development Workflow

### Making Changes

1. **Create Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**:
   - Update Terraform files in `terraform/`
   - Add SQL files in appropriate `sql/` subdirectories

3. **Create Pull Request**:
   - PR to `development` branch for development deployment
   - PR to `production` branch for production deployment

4. **Automatic Deployment**:
   - **Development**: GitHub Actions automatically applies changes on PR
   - **Production**: GitHub Actions requires manual approval, then applies changes

5. **No Local Credentials Needed**:
   - All authentication handled through repository secrets
   - No need to store passwords locally

### Promoting Changes

1. **Development → Production**:
   ```bash
   git checkout development
   git pull origin development
   git checkout production
   git merge development
   git push origin production
   ```

## Security Best Practices

1. **Never commit secrets** to version control
2. **Use environment-specific** Terraform state backends
3. **Implement least privilege** access for service accounts
4. **Enable resource monitoring** in production
5. **Require manual approval** for production deployments

## Troubleshooting

### Common Issues

1. **Authentication Failures**:
   - Verify Snowflake credentials in repository secrets
   - Check account identifier format
   - Ensure user has required permissions

2. **Resource Already Exists**:
   - Import existing resources into Terraform state
   - Use `terraform import` command

3. **State Lock Issues**:
   - Configure remote state backend (S3, Azure, etc.)
   - Use state locking mechanisms

### Getting Help

1. Check Terraform documentation: https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest
2. Review Snowflake documentation: https://docs.snowflake.com/
3. Check GitHub Actions logs for detailed error messages

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in development
5. Submit a pull request with detailed description
6. Ensure all CI checks pass
7. Request review from team members

## License

This project is licensed under the MIT License - see the LICENSE file for details.