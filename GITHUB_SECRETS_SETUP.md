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

## 🔐 Production Protection Setup

**Use GitHub's built-in branch protection instead of custom approval secrets!**

### Option 1: Branch Protection Rules (Recommended)

1. **Go to Repository Settings**:
   - Navigate to **Settings → Branches**
   - Click **Add rule** or **Add protection rule**

2. **Configure Protection Rule**:
   - **Branch name pattern**: `prod`
   - ✅ **Require a pull request before merging**
   - ✅ **Require reviews before merging** (set to 1 or more)
   - ✅ **Dismiss stale PR reviews when new commits are pushed**
   - ✅ **Restrict pushes that create files larger than 100MB**
   - ✅ **Require status checks to pass before merging**

3. **Add Required Reviewers**:
   - Add specific GitHub usernames
   - Or create a team and require team review

### Option 2: GitHub Environments (Also Great)

1. **Go to Repository Settings**:
   - Navigate to **Settings → Environments**
   - Click **New environment**

2. **Create Production Environment**:
   - **Name**: `production`
   - ✅ **Required reviewers**: Add GitHub usernames or teams
   - ✅ **Wait timer**: Optional delay before deployment
   - ✅ **Deployment branches**: Only `prod` branch

### 🎯 Benefits of GitHub Native Protection

- ✅ **More secure**: Built into GitHub's security model
- ✅ **Better audit trail**: Clear record of who approved what
- ✅ **Team integration**: Works with GitHub teams and permissions
- ✅ **No secret management**: No need to maintain approver lists in secrets
- ✅ **Native UI**: Approvals happen in the GitHub PR interface

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

**Total: 6 secrets**

---

## 🚀 Next Steps

After configuring secrets:

1. **Execute the SQL setup scripts** in Snowflake (if not done already)

2. **Set up branch protection** (choose one option above)

3. **Create development and production branches**:
   ```bash
   git checkout -b dev
   git push -u origin dev
   
   git checkout -b prod  
   git push -u origin prod
   ```

4. **Test with a PR** to verify the automation and protection works

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