# 🔧 Move Secrets from Environment to Repository Level

## ⚠️ Issue
The workflows are failing because environment secrets in "production" are not accessible. We've removed `environment: production` from all workflows, so now we need to move the secrets to repository level.

## 📋 Step-by-Step Instructions

### 1. Navigate to Repository Secrets
Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/secrets/actions

### 2. Add Repository Secrets
Click **"New repository secret"** and add each of these 4 secrets:

#### Secret 1: JIRA_BASE_URL
- **Name:** `JIRA_BASE_URL`
- **Value:** `https://haripriya-bob.atlassian.net`

#### Secret 2: JIRA_USER_EMAIL
- **Name:** `JIRA_USER_EMAIL`
- **Value:** `haripriya.tcs@gmail.com`

#### Secret 3: JIRA_API_TOKEN
- **Name:** `JIRA_API_TOKEN`
- **Value:** (Copy from your production environment secret)

#### Secret 4: JIRA_PROJECT_KEY
- **Name:** `JIRA_PROJECT_KEY`
- **Value:** `SCRUM`

### 3. Copy API Token from Environment
To get your JIRA_API_TOKEN value:
1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/environments/1607352160/edit
2. Find the `JIRA_API_TOKEN` secret
3. You'll need to re-enter the token value (GitHub doesn't show existing secret values)
4. If you don't have it, generate a new one at: https://id.atlassian.com/manage-profile/security/api-tokens

### 4. Verify All Secrets Are Added
After adding all 4 secrets, you should see them listed at:
https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/secrets/actions

### 5. Test the Workflow
Once all secrets are added:
1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions
2. Find the failed "Bob Agent - Auto PR & Jira Creation" workflow
3. Click "Re-run all jobs"
4. The workflow should now succeed! ✅

## 🎯 Why This Works
- **Repository secrets** are accessible to all workflows in the repository
- **Environment secrets** require environment protection rules and branch restrictions
- By using repository secrets, we avoid environment configuration complexity

## 🔒 Security Note
Repository secrets are still secure and encrypted. They're only accessible to GitHub Actions workflows in your repository.

## ✅ Expected Result
After moving secrets to repository level:
- ✅ Workflows can access Jira credentials
- ✅ Jira tickets will be created automatically
- ✅ PRs will be linked to Jira tickets
- ✅ Auto-merge will work correctly

## 🆘 Need Help?
If you encounter issues:
1. Verify all 4 secrets are added correctly
2. Check secret names match exactly (case-sensitive)
3. Ensure JIRA_API_TOKEN is valid
4. Re-run the workflow after adding secrets