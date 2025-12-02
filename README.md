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