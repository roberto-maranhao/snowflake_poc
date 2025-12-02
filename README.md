# Snowflake Infrastructure with Terraform

This repository provides a modular Terraform infrastructure for managing Snowflake resources across multiple environments (dev/prod) with automated deployments via GitHub Actions.

## Architecture

### Modular Design
The infrastructure is organized into domain-specific modules for better maintainability and separation of concerns:

```
terraform/
├── main.tf              # Provider and backend configuration
├── resources.tf         # Core infrastructure (database, warehouse, schemas, roles)
├── outputs.tf           # Output definitions
├── environments/        # Environment-specific configurations
│   ├── dev.tfvars
│   └── prod.tfvars
└── modules/            # Domain-specific modules
    ├── users/          # User management
    │   ├── tables.tf
    │   ├── procedures.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── products/       # Product catalog
    │   ├── tables.tf
    │   ├── functions.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── orders/         # Order processing
    │   ├── tables.tf
    │   ├── procedures.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── views/          # Analytics views
        ├── views.tf
        ├── variables.tf
        └── outputs.tf
```

### Module Dependencies
The modules have clear dependency relationships:
- **Users**: Standalone module with user management
- **Products**: Standalone module with product catalog and pricing functions
- **Orders**: Depends on Users module (foreign key relationship)
- **Views**: Depends on Users, Products, and Orders modules (joins data across tables)

## Environments

### Development Environment
- Database: `SNOWFLAKE_DEV`
- Warehouse: `COMPUTE_WH_DEV` (X-Small)
- Data retention: 30 days
- Single cluster warehouse
- No resource monitor

### Production Environment
- Database: `SNOWFLAKE_PROD`
- Warehouse: `COMPUTE_WH_PROD` (Small)
- Data retention: 90 days
- Auto-scaling warehouse (1-3 clusters)
- Resource monitor with credit limits and notifications

## Database Schema

### Users Module
- **USERS table**: User management with email uniqueness
- **CREATE_USER procedure**: User creation with validation

### Products Module
- **PRODUCTS table**: Product catalog with pricing
- **CALCULATE_TAX function**: Tax calculation utility
- **GET_PRODUCT_PRICE function**: Price lookup utility

### Orders Module  
- **ORDERS table**: Order processing with foreign key to users
- **GET_USER_ORDER_HISTORY procedure**: Order history retrieval

### Views Module
- **USER_ORDERS_SUMMARY view**: Aggregated analytics view joining users and orders

## Deployment

### Automated CI/CD
GitHub Actions workflows handle automated deployments:

#### Development Deployment
- **Trigger**: Push to `dev` branch
- **Workflow**: `.github/workflows/terraform-plan-dev.yml`
- **Process**: Terraform plan and apply automatically

#### Production Deployment
- **Trigger**: Push to `main` branch  
- **Workflow**: `.github/workflows/terraform-plan-prod.yml`
- **Process**: Terraform plan and apply automatically
- **Protection**: GitHub branch protection recommended for `main` branch

### Manual Deployment

1. **Initialize Terraform**:
   ```bash
   cd terraform
   terraform init
   ```

2. **Plan Deployment**:
   ```bash
   # Development
   terraform plan -var-file="environments/dev.tfvars"
   
   # Production  
   terraform plan -var-file="environments/prod.tfvars"
   ```

3. **Apply Changes**:
   ```bash
   # Development
   terraform apply -var-file="environments/dev.tfvars"
   
   # Production
   terraform apply -var-file="environments/prod.tfvars"
   ```

## Configuration

### Required Secrets
Configure these secrets in GitHub repository settings:

- `SNOWFLAKE_USER`: Snowflake username
- `SNOWFLAKE_PASSWORD`: Snowflake password  
- `SNOWFLAKE_ACCOUNT`: Snowflake account identifier
- `SNOWFLAKE_REGION`: Snowflake region

### Environment Variables
Each environment has its own variable file:

- `terraform/environments/dev.tfvars`
- `terraform/environments/prod.tfvars`

Customize database names, warehouse sizes, and other environment-specific settings in these files.

## Security

### Role-Based Access Control
- **APP_ROLE**: Full privileges for application use
- **READ_ROLE**: Read-only access for reporting and analytics

### Data Retention
- Development: 30 days
- Production: 90 days

### Resource Monitoring
Production environment includes credit monitoring with:
- Notifications at 80% and 90% usage
- Suspension at 95% usage
- Immediate suspension at 100% usage

## Contributing

1. Create feature branch from `dev`
2. Make changes to Terraform modules
3. Test in development environment
4. Create pull request to `dev` branch
5. After testing, merge to `main` for production deployment

## Best Practices

### Module Development
- Keep modules focused on single domains
- Use clear variable names and descriptions
- Include comprehensive outputs for inter-module communication
- Establish explicit dependencies using `depends_on`

### Environment Management
- Always test changes in dev environment first
- Use environment-specific variable files
- Maintain separate state files for each environment
- Review Terraform plans before applying

### Security
- Rotate Snowflake credentials regularly
- Use least privilege access principles
- Monitor resource usage and costs
- Review access grants periodically

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
- **Deploy**: Triggered on PR to `dev` branch (automatic apply)

#### Production Workflow
- **Deploy**: Triggered on PR to `prod` branch (requires manual approval before apply)

## Resources Created

The Terraform configuration creates the following Snowflake resources:

### Development Environment
- **Database**: `DEV_DB`
- **Warehouse**: `DEV_WH` (X-SMALL)
- **Schemas**: `PUBLIC`, `STAGING`, `ANALYTICS`, `TESTING`
- **Roles**: `DEV_APP_ROLE`, `DEV_READ_ROLE`
- **Tables**: `USERS`, `PRODUCTS`, `ORDERS`
- **Views**: `USER_ORDERS_SUMMARY`
- **Functions**: `CALCULATE_ORDER_TOTAL_WITH_TAX`, `CALCULATE_ORDER_TOTAL_WITH_DEFAULT_TAX`
- **Procedures**: `GET_USER_ORDER_HISTORY`, `CREATE_USER`

### Production Environment
- **Database**: `PROD_DB`
- **Warehouse**: `PROD_WH` (SMALL)
- **Schemas**: `PUBLIC`, `STAGING`, `ANALYTICS`
- **Roles**: `PROD_APP_ROLE`, `PROD_READ_ROLE`
- **Resource Monitor**: `PROD_WH_MONITOR` (1000 credit limit)
- **Tables**: `USERS`, `PRODUCTS`, `ORDERS`
- **Views**: `USER_ORDERS_SUMMARY`
- **Functions**: `CALCULATE_ORDER_TOTAL_WITH_TAX`, `CALCULATE_ORDER_TOTAL_WITH_DEFAULT_TAX`
- **Procedures**: `GET_USER_ORDER_HISTORY`, `CREATE_USER`

## Declarative Schema Management

All database objects (tables, views, functions, procedures) are defined as Terraform resources. This means:

### Adding a Column
```hcl
# In terraform/tables.tf, add to any table:
column {
  name     = "NEW_COLUMN"
  type     = "VARCHAR(100)"
  nullable = true
}
```

### Modifying a Table
- **Add columns**: Add column blocks to the resource
- **Change column types**: Modify the type in the column definition
- **Add constraints**: Use primary_key, foreign_key, or table_constraint resources
- **Terraform handles the DDL**: Automatically generates ALTER TABLE statements

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
   - PR to `dev` branch for development deployment
   - PR to `prod` branch for production deployment

4. **Automatic Deployment**:
   - **Development**: GitHub Actions automatically applies changes on PR
   - **Production**: GitHub Actions requires manual approval, then applies changes

5. **No Local Credentials Needed**:
   - All authentication handled through repository secrets
   - No need to store passwords locally

### Promoting Changes

1. **Development → Production**:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout prod
   git merge dev
   git push origin prod
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