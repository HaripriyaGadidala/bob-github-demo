# 🔐 ICA Environment Variables Configuration

## 📋 Overview

These are the exact environment variables you need to add to your ICA Agentic App for the Bob GitHub Automation System to work.

---

## 🔑 Environment Variables to Add

### In ICA Control Tower or App Settings

Add these environment variables:

### 1. GitHub Configuration

```bash
# GitHub Personal Access Token
GITHUB_TOKEN=<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>
# You need to generate this from: https://github.com/settings/tokens
# Required permissions: repo, workflow

# GitHub Repository
GITHUB_REPOSITORY=HaripriyaGadidala/bob-gihub-demo

# GitHub API URL
GITHUB_API_URL=https://api.github.com

# Workflow Configuration
WORKFLOW_FILE=bob-auto-pr-jira.yml
DEFAULT_TARGET_BRANCH=main
```

### 2. Jira Configuration

Based on your setup from [`JIRA_SETUP_INSTRUCTIONS.md`](JIRA_SETUP_INSTRUCTIONS.md):

```bash
# Jira Site URL
JIRA_BASE_URL=https://haripriya-bob.atlassian.net

# Jira User Email
JIRA_USER_EMAIL=haripriya.tcs@gmail.com

# Jira API Token
JIRA_API_TOKEN=<YOUR_JIRA_API_TOKEN>
# Generate from: https://id.atlassian.com/manage-profile/security/api-tokens

# Jira Project Key
JIRA_PROJECT_KEY=SCRUM
```

---

## 📝 Step-by-Step: How to Add Variables in ICA

### Option 1: Control Tower Tab

1. Go to your Agentic App: **Bob GitHub Automation System**
2. Click on **"Control Tower"** tab
3. Look for **"Environment Variables"** section
4. Click **"Add Variable"** or **"+"**
5. For each variable:
   - **Name:** (e.g., `GITHUB_TOKEN`)
   - **Value:** (paste the value)
   - **Type:** Secret (for tokens) or String (for URLs)
6. Click **"Save"**

### Option 2: App Settings

1. Click **Settings** icon (gear icon)
2. Navigate to **"Environment Variables"**
3. Add each variable as above

---

## 🔐 Security Best Practices

### For Sensitive Values (Tokens, Passwords)

- ✅ Mark as **"Secret"** type
- ✅ Never commit to version control
- ✅ Rotate tokens regularly
- ✅ Use minimal required permissions

### Token Permissions

**GitHub Token needs:**
- ✅ `repo` - Full repository access
- ✅ `workflow` - Trigger workflows
- ✅ `write:packages` - If using packages

**Jira Token needs:**
- ✅ Project access for SCRUM project
- ✅ Create/edit issues
- ✅ Add comments
- ✅ Transition issues

---

## 🎯 Quick Copy-Paste Format

### For ICA Control Tower

Copy this template and fill in your actual values:

```
Name: GITHUB_TOKEN
Value: ghp_YOUR_ACTUAL_TOKEN_HERE
Type: Secret

Name: GITHUB_REPOSITORY
Value: HaripriyaGadidala/bob-gihub-demo
Type: String

Name: GITHUB_API_URL
Value: https://api.github.com
Type: String

Name: WORKFLOW_FILE
Value: bob-auto-pr-jira.yml
Type: String

Name: DEFAULT_TARGET_BRANCH
Value: main
Type: String

Name: JIRA_BASE_URL
Value: https://haripriya-bob.atlassian.net
Type: String

Name: JIRA_USER_EMAIL
Value: haripriya.tcs@gmail.com
Type: String

Name: JIRA_API_TOKEN
Value: YOUR_ACTUAL_JIRA_TOKEN_HERE
Type: Secret

Name: JIRA_PROJECT_KEY
Value: SCRUM
Type: String
```

---

## 🔍 How to Get Missing Tokens

### GitHub Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Name: `ICA Bob Agent`
4. Select scopes:
   - ✅ `repo` (all)
   - ✅ `workflow`
5. Click **"Generate token"**
6. **Copy the token immediately** (you won't see it again!)
7. Paste as `GITHUB_TOKEN` value

### Jira API Token

1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token"**
3. Label: `ICA Bob Agent`
4. Click **"Create"**
5. **Copy the token immediately**
6. Paste as `JIRA_API_TOKEN` value

---

## ✅ Verification Checklist

After adding all variables, verify:

- [ ] `GITHUB_TOKEN` - Added as Secret
- [ ] `GITHUB_REPOSITORY` - Set to `HaripriyaGadidala/bob-gihub-demo`
- [ ] `GITHUB_API_URL` - Set to `https://api.github.com`
- [ ] `WORKFLOW_FILE` - Set to `bob-auto-pr-jira.yml`
- [ ] `DEFAULT_TARGET_BRANCH` - Set to `main`
- [ ] `JIRA_BASE_URL` - Set to `https://haripriya-bob.atlassian.net`
- [ ] `JIRA_USER_EMAIL` - Set to `haripriya.tcs@gmail.com`
- [ ] `JIRA_API_TOKEN` - Added as Secret
- [ ] `JIRA_PROJECT_KEY` - Set to `SCRUM`

---

## 🧪 Test Configuration

After adding variables, test with this command in ICA chat:

```
Test the environment variables by checking:
1. Can we connect to GitHub API?
2. Can we connect to Jira API?
3. Are all required variables present?
```

---

## 🚨 Troubleshooting

### If GitHub Connection Fails

```bash
# Test GitHub token manually
curl -H "Authorization: Bearer YOUR_GITHUB_TOKEN" \
  https://api.github.com/user
```

Expected: Your GitHub user info

### If Jira Connection Fails

```bash
# Test Jira token manually
curl -u haripriya.tcs@gmail.com:YOUR_JIRA_TOKEN \
  https://haripriya-bob.atlassian.net/rest/api/3/myself
```

Expected: Your Jira user info

---

## 📊 Summary

### Your Specific Configuration

| Variable | Value | Type |
|----------|-------|------|
| `GITHUB_TOKEN` | `<generate from GitHub>` | Secret |
| `GITHUB_REPOSITORY` | `HaripriyaGadidala/bob-gihub-demo` | String |
| `GITHUB_API_URL` | `https://api.github.com` | String |
| `WORKFLOW_FILE` | `bob-auto-pr-jira.yml` | String |
| `DEFAULT_TARGET_BRANCH` | `main` | String |
| `JIRA_BASE_URL` | `https://haripriya-bob.atlassian.net` | String |
| `JIRA_USER_EMAIL` | `haripriya.tcs@gmail.com` | String |
| `JIRA_API_TOKEN` | `<generate from Jira>` | Secret |
| `JIRA_PROJECT_KEY` | `SCRUM` | String |

---

## 🎯 Next Steps

After adding all environment variables:

1. ✅ Save the configuration
2. ✅ Go to **"Tools"** tab
3. ✅ Add GitHub API tool (if available)
4. ✅ Add Jira API tool (if available)
5. ✅ Go to **"Workflow"** tab
6. ✅ Verify agent connections
7. ✅ Test with: "Add a contact form to the website"
8. ✅ Monitor execution through all 6 agents

---

**Created:** 2026-06-01  
**App:** Bob GitHub Automation System  
**Status:** Ready for Environment Configuration  

---

*Add these variables to complete your ICA setup! 🚀*