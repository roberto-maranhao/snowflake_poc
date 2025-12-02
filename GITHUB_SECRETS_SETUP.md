# GitHub Repository Secrets Configuration Guide

## 📋 Required Repository Secrets

You need to add the following secrets to your GitHub repository. Go to:

**Your Repository → Settings → Secrets and variables → Actions → New repository secret**

---

## 🔑 Development Environment Secrets

### 1. SNOWFLAKE_DEV_ACCOUNT
- **Value**: `your-account.region.snowflakecomputing.com`
- **Example**: `abc123.us-east-1.snowflakecomputing.com`

### 2. SNOWFLAKE_DEV_USERNAME
- **Value**: `TERRAFORM_DEV_USER`

### 3. SNOWFLAKE_DEV_PASSWORD
- **Value**: `SUPER_DUPER_STRONG_DEV_PASSWORD`
- *(Use the exact password from your SQL script)*

---

## 🔑 Production Environment Secrets

### 4. SNOWFLAKE_PROD_ACCOUNT
- **Value**: `your-account.region.snowflakecomputing.com`
- **Example**: `abc123.us-east-1.snowflakecomputing.com`

### 5. SNOWFLAKE_PROD_USERNAME
- **Value**: `TERRAFORM_PROD_USER`

### 6. SNOWFLAKE_PROD_PASSWORD
- **Value**: `SUPER_DUPER_STRONG_PROD_PASSWORD`
- *(Use the exact password from your SQL script)*

---

## 👥 Production Approval Configuration

Production deployments require manual approval for security and compliance. This prevents accidental deployments to your production Snowflake environment.

### 7. PROD_APPROVERS
- **Value**: `your-github-username` (or comma-separated list of GitHub usernames)
- **Examples**: 
  - Single approver: `roberto-maranhao`
  - Multiple approvers: `roberto-maranhao,john.doe,jane.smith`
  - Team leads: `data-team-lead,devops-manager,cto`

### 🔐 How Production Approval Works

1. **PR Created**: When a PR is created against the `production` branch
2. **Terraform Plan**: GitHub Actions runs `terraform plan` automatically
3. **Manual Approval Required**: Workflow pauses and creates an approval issue
4. **Notification**: GitHub notifies the specified approvers
5. **Review & Approve**: Approvers review the plan and approve/reject
6. **Deploy**: Only after approval, `terraform apply` executes

### 👥 Approval Requirements

- **Minimum Approvals**: 1 (configurable in workflow)
- **Who Can Approve**: Only GitHub usernames listed in `PROD_APPROVERS`
- **Timeout**: 24 hours (workflow fails if no approval)
- **Emergency Override**: Repository admins can always approve

### 📋 Best Practices for Approvers

- **Data Team Lead**: Review schema and data model changes
- **DevOps Manager**: Review infrastructure and security implications  
- **Database Administrator**: Review permissions and performance impact
- **Security Officer**: Review compliance and security aspects

### ⚠️ Important Security Notes

- Approvers must have **read access** to the repository
- Approvers should review the **Terraform plan output** before approving
- Use **team-based approvers** rather than individual usernames when possible
- Consider **requiring multiple approvals** for critical production changes

---

## 🔧 How to Add Secrets

1. **Navigate to your repository on GitHub**
2. **Click Settings** (top menu)
3. **Click "Secrets and variables"** (left sidebar)
4. **Click "Actions"**
5. **Click "New repository secret"**
6. **Enter the name and value** for each secret above
7. **Click "Add secret"**

---

## ✅ Verification Checklist

After adding all secrets, verify you have:

- [ ] SNOWFLAKE_DEV_ACCOUNT
- [ ] SNOWFLAKE_DEV_USERNAME  
- [ ] SNOWFLAKE_DEV_PASSWORD
- [ ] SNOWFLAKE_PROD_ACCOUNT
- [ ] SNOWFLAKE_PROD_USERNAME
- [ ] SNOWFLAKE_PROD_PASSWORD  
- [ ] PROD_APPROVERS

**Total: 7 secrets**

---

## 🚀 Next Steps

After configuring secrets:

1. **Execute the SQL setup scripts** in Snowflake (if not done already)
2. **Create development and production branches**:
   ```bash
   git checkout -b development
   git push -u origin development
   
   git checkout -b production  
   git push -u origin production
   ```

3. **Test with a PR** to the development branch to verify the automation works

---

## 🛠️ Account Identifier Format

Your Snowflake account identifier should be in one of these formats:

- **Legacy format**: `account_name.region_id`
- **New format**: `orgname-account_name`
- **With cloud**: `account_name.region_id.cloud_provider`

**Examples**:
- `abc123.us-east-1.aws`
- `myorg-myaccount`  
- `company-dev.us-central1.gcp`

Find your exact account identifier in Snowflake under **Admin → Accounts**.

---

## 🔒 Security Notes

- ✅ These secrets are encrypted and only visible to repository admins
- ✅ Secrets are only passed to GitHub Actions during workflow execution
- ✅ Never commit passwords or sensitive data to your repository
- ⚠️ Rotate passwords regularly for security best practices