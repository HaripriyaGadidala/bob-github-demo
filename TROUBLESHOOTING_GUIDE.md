# 🔧 Troubleshooting Guide - Bob Agent Automation

## 🔍 Issue: Workflows Not Triggering

### Symptom
- PR created manually but no Jira ticket
- No workflow runs in Actions tab
- Automation not working

### Root Cause Analysis

The automation has two trigger points:

1. **`bob-auto-pr-jira.yml`** - Triggers on **push** to feature branches
   - Creates PR automatically
   - Creates Jira ticket
   
2. **`pr-to-jira.yml`** - Triggers when **PR is opened**
   - Backup for manually created PRs
   - Creates Jira ticket

### 🎯 What Happened

When you pushed `feature/test-bob-automation`:
- ✅ Branch was pushed successfully
- ❌ `bob-auto-pr-jira.yml` didn't trigger (needs investigation)
- ✅ You manually created a PR
- ❓ `pr-to-jira.yml` should have triggered on PR open

---

## 🔍 Diagnostic Steps

### Step 1: Check GitHub Actions Status

1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions
2. Look for workflow runs
3. Check if any workflows failed

**What to look for:**
- ❌ Red X = Failed
- ✅ Green checkmark = Success
- 🟡 Yellow dot = In progress
- ⚪ Gray = Skipped

### Step 2: Check Workflow Permissions

1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/actions
2. Verify **"Allow all actions and reusable workflows"** is selected
3. Check **"Workflow permissions"**:
   - Should be: **"Read and write permissions"**
   - Enable: **"Allow GitHub Actions to create and approve pull requests"**

### Step 3: Check Environment Protection

1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/environments
2. Click on **"production"** environment
3. Check if there are **deployment protection rules**
4. If "Required reviewers" is set, workflows will wait for approval

**Fix:** Remove required reviewers for automated workflows

### Step 4: Verify Secrets

1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/settings/environments
2. Click **"production"**
3. Verify all 4 secrets exist:
   - `JIRA_BASE_URL`
   - `JIRA_USER_EMAIL`
   - `JIRA_API_TOKEN`
   - `JIRA_PROJECT_KEY`

### Step 5: Check Workflow Files

Verify workflow files are in the correct location:
```
.github/
  workflows/
    bob-auto-pr-jira.yml
    pr-to-jira.yml
    update-jira-on-merge.yml
    bob-auto-merge.yml
```

---

## 🚀 Quick Fixes

### Fix 1: Enable Workflow Permissions

```bash
# Go to repository settings
Settings → Actions → General → Workflow permissions

# Select:
☑ Read and write permissions
☑ Allow GitHub Actions to create and approve pull requests

# Click "Save"
```

### Fix 2: Remove Environment Protection

```bash
# Go to environments
Settings → Environments → production

# Under "Deployment protection rules":
# Remove any "Required reviewers"
# Or add yourself as an approved reviewer
```

### Fix 3: Manually Trigger Workflow

Since the PR already exists, manually trigger the Jira ticket creation:

1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions
2. Click on **"Create Jira Ticket from Pull Request"** workflow
3. Click **"Run workflow"**
4. Select branch: `main`
5. Click **"Run workflow"**

### Fix 4: Re-trigger by Updating PR

Add a comment or update the PR to trigger workflows:

```bash
# In the PR, add a comment:
"Trigger workflows"

# Or update PR description
# Or add a label
```

---

## 🔄 Alternative: Manual Workflow Trigger

If automatic triggers aren't working, you can manually run workflows:

### Trigger bob-auto-pr-jira.yml Manually

1. Go to Actions tab
2. Select "Bob Agent - Auto PR & Jira Creation"
3. Click "Run workflow"
4. Fill in:
   - Branch: `feature/test-bob-automation`
   - Target: `main`
5. Click "Run workflow"

---

## 📊 Expected vs Actual

### Expected Flow:
```
Push → Workflow Triggers → PR Created → Jira Created → Auto-Merge
```

### Actual Flow (Current):
```
Push → Manual PR Created → ❌ Workflow Not Triggered
```

### Why This Happened:

**Possible Reasons:**

1. **Workflow Permissions Not Set**
   - GitHub Actions doesn't have write permissions
   - Fix: Enable in Settings → Actions → General

2. **Environment Protection Rules**
   - Production environment requires approval
   - Fix: Remove required reviewers

3. **Workflow File Issues**
   - YAML syntax errors
   - Fix: Check workflow files for errors

4. **Secrets Not Accessible**
   - Environment secrets not available to workflows
   - Fix: Verify secrets are in "production" environment

---

## ✅ Verification Checklist

After applying fixes, verify:

- [ ] GitHub Actions has write permissions
- [ ] No environment protection rules blocking workflows
- [ ] All 4 Jira secrets exist in production environment
- [ ] Workflow files have no syntax errors
- [ ] Actions tab shows workflow runs
- [ ] Jira ticket created successfully

---

## 🎯 Test Again

After fixing issues, test with a new branch:

```bash
# Create new test branch
git checkout main
git pull origin main
git checkout -b feature/test-automation-v2

# Make a change
echo "Test v2" > test-v2.txt
git add test-v2.txt
git commit -m "Test automation v2"

# Push
git push origin feature/test-automation-v2

# This time, DON'T create PR manually
# Let the workflow create it automatically
```

---

## 📞 Still Not Working?

### Check Workflow Logs

1. Go to Actions tab
2. Click on the failed workflow run
3. Click on the job name
4. Expand each step to see errors
5. Look for error messages

### Common Error Messages

**"Resource not accessible by integration"**
- Fix: Enable write permissions in Settings → Actions

**"Environment protection rules"**
- Fix: Remove required reviewers from production environment

**"Secret not found"**
- Fix: Add missing secrets to production environment

**"Invalid JIRA_API_TOKEN"**
- Fix: Regenerate Jira API token and update secret

---

## 🔧 Emergency Manual Process

If automation still doesn't work, you can create Jira tickets manually:

1. Go to Jira: https://haripriya-bob.atlassian.net
2. Click "Create"
3. Fill in:
   - Project: SCRUM
   - Issue Type: Task
   - Summary: `[PR #X] Your PR Title`
   - Description: Link to PR
4. Click "Create"
5. Add PR link in Jira ticket
6. Add Jira ticket link in PR description

---

## 📚 Additional Resources

- [GitHub Actions Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
- [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Jira API Documentation](https://developer.atlassian.com/cloud/jira/platform/rest/v3/)

---

**Created:** 2026-06-01  
**Purpose:** Troubleshoot Bob Agent automation issues  
**Status:** Active troubleshooting guide  

---

*Follow these steps to diagnose and fix automation issues! 🔧*