# Jira Integration Setup Instructions

## 🎯 Your Jira Details

- **Jira Site URL:** https://haripriya-bob.atlassian.net
- **Project Name:** SCRUM
- **Project Key:** SCRUM
- **Email:** haripriya.tcs@gmail.com

---

## 📋 Step-by-Step Setup

### Step 1: Generate Jira API Token

1. **Go to Atlassian Account Settings:**
   - Visit: https://id.atlassian.com/manage-profile/security/api-tokens
   - Sign in with your Atlassian account

2. **Create API Token:**
   - Click "Create API token"
   - Label: `GitHub Actions Integration`
   - Click "Create"
   - **IMPORTANT:** Copy the token immediately and save it securely!
   - You won't be able to see it again

3. **Save Your Token:**
   - Store it in a secure location (password manager recommended)
   - You'll need it in the next step

---

### Step 2: Add Secrets to GitHub Repository

1. **Go to Your GitHub Repository:**
   - Visit: https://github.com/HaripriyaGadidala/bob-gihub-demo

2. **Navigate to Settings:**
   - Click "Settings" tab
   - Click "Secrets and variables" → "Actions"

3. **Add Repository Secrets:**
   Click "New repository secret" for each of these:

   **Secret 1: JIRA_BASE_URL**
   - Name: `JIRA_BASE_URL`
   - Value: `https://haripriya-bob.atlassian.net`
   - Click "Add secret"

   **Secret 2: JIRA_USER_EMAIL**
   - Name: `JIRA_USER_EMAIL`
   - Value: `haripriya.tcs@gmail.com`
   - Click "Add secret"

   **Secret 3: JIRA_API_TOKEN**
   - Name: `JIRA_API_TOKEN`
   - Value: [Paste your API token from Step 1]
   - Click "Add secret"

   **Secret 4: JIRA_PROJECT_KEY**
   - Name: `JIRA_PROJECT_KEY`
   - Value: `SCRUM`
   - Click "Add secret"

4. **Verify Secrets:**
   You should now see 4 secrets listed:
   - JIRA_BASE_URL
   - JIRA_USER_EMAIL
   - JIRA_API_TOKEN
   - JIRA_PROJECT_KEY

---

### Step 3: Push Workflow Files to GitHub

The workflow files are already created in your local repository. Now we need to push them:

```bash
# Navigate to repository
cd bob-gihub-demo

# Stage all new files
git add .

# Commit the changes
git commit -m "[SETUP]: Add Jira integration workflows and documentation"

# Push to GitHub
git push origin main
```

---

### Step 4: Enable GitHub Actions

1. **Go to Actions Tab:**
   - Visit: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions

2. **Enable Workflows:**
   - If prompted, click "I understand my workflows, go ahead and enable them"
   - Workflows should now be active

---

### Step 5: Test the Integration

#### Create a Test Pull Request:

1. **Create a new branch:**
   ```bash
   cd bob-gihub-demo
   git checkout -b test/jira-integration
   ```

2. **Make a small change:**
   ```bash
   echo "# Test Jira Integration" >> TEST.md
   git add TEST.md
   git commit -m "BGD-1 Test Jira integration"
   git push origin test/jira-integration
   ```

3. **Create Pull Request:**
   - Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo
   - Click "Compare & pull request"
   - Title: `[SCRUM-1] Test Jira Integration`
   - Description: `Testing automatic Jira ticket creation`
   - Click "Create pull request"

4. **Check Results:**
   - Wait 30-60 seconds
   - Check PR comments for Jira ticket link
   - Visit Jira: https://haripriya-bob.atlassian.net/browse/SCRUM-1
   - You should see a new ticket created automatically!

---

## 🔍 What Happens Automatically

### When You Create a PR:

1. ✅ GitHub Actions workflow triggers
2. ✅ Jira ticket is created with:
   - Title: `[PR #X] Your PR Title`
   - Description: PR details, changes, tasks
   - Labels: `pull-request`, `github`, `automated`
   - Assignee: PR author
3. ✅ Comment added to PR with Jira link
4. ✅ PR description updated with Jira link

### When You Merge a PR:

1. ✅ Jira ticket gets a comment about merge
2. ✅ Ticket status transitions to "Done"
3. ✅ Merge details recorded in Jira

### When You Close a PR (without merging):

1. ✅ Jira ticket gets a comment about closure
2. ✅ Ticket status transitions to "Cancelled"

---

## 📊 Jira Ticket Example

When you create a PR, Jira will create a ticket like this:

**Ticket:** SCRUM-1
**Summary:** [PR #1] Add employee creation SQL script  
**Type:** Task  
**Status:** To Do  
**Labels:** pull-request, github, automated  
**Assignee:** HaripriyaGadidala

**Description:**
```
Pull Request Details
--------------------
PR Number: #1
Author: HaripriyaGadidala
Branch: feature/add-sql-script → main
URL: https://github.com/HaripriyaGadidala/bob-gihub-demo/pull/1

Description
-----------
Added demo_employee_creation.sql for Oracle HRMS

Changes
-------
• Commits: 1
• Files Changed: 1
• Additions: +222
• Deletions: -0

Tasks
-----
• Review code changes
• Test functionality
• Approve PR
• Merge to main
```

---

## 🎨 Using Smart Commits

You can control Jira tickets directly from Git commits:

### Basic Linking:
```bash
git commit -m "BGD-123 Fix validation bug"
# Links commit to ticket BGD-123
```

### Add Comment:
```bash
git commit -m "BGD-123 #comment Fixed the validation issue"
# Adds comment to ticket
```

### Transition Ticket:
```bash
git commit -m "BGD-123 #done Fixed and tested"
# Moves ticket to Done status
```

### Multiple Actions:
```bash
git commit -m "BGD-123 #comment Fixed bug #time 2h #done"
# Adds comment, logs time, and marks as done
```

---

## 🔧 Troubleshooting

### Issue: Workflow Not Running

**Check:**
1. Go to: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions
2. Look for failed workflows
3. Click on the workflow to see error details

**Common Fixes:**
- Verify all 4 secrets are added correctly
- Check API token is valid (not expired)
- Ensure project key is exactly "BGD"

### Issue: Jira Ticket Not Created

**Check:**
1. GitHub Actions logs for errors
2. Verify Jira API token has correct permissions
3. Test API token manually:
   ```bash
   curl -u haripriya.tcs@gmail.com:YOUR_API_TOKEN \
     https://haripriya-bob.atlassian.net/rest/api/3/myself
   ```

### Issue: Cannot Transition Ticket

**Fix:**
- Go to Jira project settings
- Check workflow transitions
- Ensure "Done" and "Cancelled" states exist
- Update workflow file if using different state names

---

## 📱 Access Your Jira

### Web Access:
- **Dashboard:** https://haripriya-bob.atlassian.net/jira/dashboards
- **Project:** https://haripriya-bob.atlassian.net/jira/software/projects/BGD
- **All Issues:** https://haripriya-bob.atlassian.net/jira/software/projects/BGD/issues

### Mobile App:
1. Download "Jira Cloud" from App Store/Play Store
2. Sign in with: haripriya.tcs@gmail.com
3. Access your project on the go

---

## 📚 Quick Reference

### Workflow Files Created:
1. `.github/workflows/pr-to-jira.yml` - Creates Jira tickets
2. `.github/workflows/update-jira-on-merge.yml` - Updates tickets on merge
3. `.github/workflows/pr-to-issue.yml` - Creates GitHub issues (backup)
4. `.github/workflows/close-issue-on-pr.yml` - Closes GitHub issues

### Documentation Files:
1. `JIRA_GITHUB_INTEGRATION_GUIDE.md` - Complete integration guide
2. `JIRA_SETUP_INSTRUCTIONS.md` - This file (setup steps)
3. `WORKFLOW_GUIDE.md` - GitHub Issues workflow guide

---

## ✅ Setup Checklist

- [ ] Created Jira account at https://haripriya-bob.atlassian.net
- [ ] Created project "Bob GitHub Demo" with key "BGD"
- [ ] Generated Jira API token
- [ ] Added JIRA_BASE_URL secret to GitHub
- [ ] Added JIRA_USER_EMAIL secret to GitHub
- [ ] Added JIRA_API_TOKEN secret to GitHub
- [ ] Added JIRA_PROJECT_KEY secret to GitHub
- [ ] Pushed workflow files to GitHub
- [ ] Enabled GitHub Actions
- [ ] Created test PR to verify integration
- [ ] Verified Jira ticket was created
- [ ] Tested PR merge → Jira ticket closure

---

## 🎓 Next Steps

1. **Complete the setup** using the steps above
2. **Test the integration** with a sample PR
3. **Customize workflows** if needed
4. **Train your team** on using the integration
5. **Monitor** GitHub Actions for any issues

---

## 📞 Support

### GitHub Actions Issues:
- Check: https://github.com/HaripriyaGadidala/bob-gihub-demo/actions
- Docs: https://docs.github.com/en/actions

### Jira Issues:
- Support: https://support.atlassian.com/
- Community: https://community.atlassian.com/

---

**Created:** 2026-05-21  
**Status:** Ready for Setup  
**Next Action:** Follow Step 1 to generate API token