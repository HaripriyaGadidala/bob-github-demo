# Jira & GitHub Integration Guide

## 🎯 Overview

This guide will help you set up a free Jira account and integrate it with your GitHub repository to automatically create Jira tickets for pull requests.

---

## 📋 Part 1: Create Free Jira Account

### Step 1: Sign Up for Jira Cloud (Free)

1. **Visit Jira Cloud**
   - Go to: https://www.atlassian.com/software/jira/free
   - Click "Get it free"

2. **Create Account**
   - Enter your email: `haripriya.tcs@gmail.com`
   - Create a password
   - Verify your email

3. **Set Up Your Site**
   - Choose a site name: `haripriya-bob` (or any name you prefer)
   - Your Jira URL will be: `https://haripriya-bob.atlassian.net`
   - Select "Software Development" as your team type

4. **Create Your First Project**
   - Project name: "Bob GitHub Demo"
   - Project key: "BGD" (will be used in ticket IDs like BGD-1, BGD-2)
   - Template: Choose "Scrum" or "Kanban"

### Free Tier Limits
✅ Up to 10 users
✅ 2GB storage
✅ Unlimited projects
✅ Community support
✅ All core features

---

## 🔗 Part 2: Connect GitHub to Jira

### Method 1: Using Jira's GitHub Integration (Recommended)

#### Step 1: Install GitHub for Jira App

1. **In Jira:**
   - Go to: `https://your-site.atlassian.net/jira/settings/apps`
   - Click "Find new apps"
   - Search for "GitHub for Jira"
   - Click "Get it now" (Free)

2. **Authorize GitHub:**
   - Click "Get started"
   - Click "Connect GitHub account"
   - Sign in to GitHub
   - Authorize the Jira app

3. **Connect Repository:**
   - Select your GitHub organization/account
   - Choose repository: `bob-gihub-demo`
   - Click "Connect"

#### Step 2: Configure Integration

1. **Smart Commits** (Automatic linking)
   - Commit format: `BGD-123 Add new feature`
   - Jira will automatically link commits to tickets

2. **Branch Naming** (Automatic ticket creation)
   - Branch format: `BGD-123-feature-name`
   - Creates link between branch and ticket

3. **PR Linking**
   - PR title format: `[BGD-123] Add new feature`
   - Automatically links PR to Jira ticket

---

## 🤖 Part 3: Automated Ticket Creation for PRs

### Option A: GitHub Actions → Jira API

Create a workflow that automatically creates Jira tickets when PRs are opened.

#### Step 1: Generate Jira API Token

1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Name it: "GitHub Actions"
4. Copy the token (save it securely!)

#### Step 2: Add Secrets to GitHub

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Add these secrets:
   - `JIRA_BASE_URL`: `https://your-site.atlassian.net`
   - `JIRA_USER_EMAIL`: `haripriya.tcs@gmail.com`
   - `JIRA_API_TOKEN`: (paste your token)
   - `JIRA_PROJECT_KEY`: `BGD`

#### Step 3: Create Workflow File

I'll create this workflow for you below.

---

## 📝 Workflow: Auto-Create Jira Tickets from PRs

### File: `.github/workflows/pr-to-jira.yml`

```yaml
name: Create Jira Ticket from Pull Request

on:
  pull_request:
    types: [opened]

jobs:
  create-jira-ticket:
    runs-on: ubuntu-latest
    steps:
      - name: Create Jira Issue
        id: create
        uses: atlassian/gajira-create@v3
        with:
          project: ${{ secrets.JIRA_PROJECT_KEY }}
          issuetype: Task
          summary: "[PR #${{ github.event.pull_request.number }}] ${{ github.event.pull_request.title }}"
          description: |
            h2. Pull Request Details
            
            *PR Number:* #${{ github.event.pull_request.number }}
            *Author:* ${{ github.event.pull_request.user.login }}
            *Branch:* {{${{ github.event.pull_request.head.ref }}}} → {{${{ github.event.pull_request.base.ref }}}}
            *URL:* ${{ github.event.pull_request.html_url }}
            
            h2. Description
            ${{ github.event.pull_request.body }}
            
            h2. Changes
            * Commits: ${{ github.event.pull_request.commits }}
            * Files Changed: ${{ github.event.pull_request.changed_files }}
            * Additions: +${{ github.event.pull_request.additions }}
            * Deletions: -${{ github.event.pull_request.deletions }}
          fields: '{"labels": ["pull-request", "github"]}'
        env:
          JIRA_BASE_URL: ${{ secrets.JIRA_BASE_URL }}
          JIRA_USER_EMAIL: ${{ secrets.JIRA_USER_EMAIL }}
          JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}

      - name: Log created issue
        run: echo "Created Jira issue ${{ steps.create.outputs.issue }}"

      - name: Comment on PR with Jira link
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Jira ticket created: [${{ steps.create.outputs.issue }}](${{ secrets.JIRA_BASE_URL }}/browse/${{ steps.create.outputs.issue }})'
            })
```

---

## 🔄 Part 4: Workflow Features

### What Happens Automatically:

1. **When PR is Opened:**
   - ✅ Jira ticket is created
   - ✅ Ticket includes PR details
   - ✅ PR gets comment with Jira link
   - ✅ Ticket is labeled "pull-request" and "github"

2. **Ticket Contents:**
   - PR number and title
   - Author information
   - Branch names
   - Description
   - Statistics (commits, files, lines changed)
   - Direct link to PR

3. **Smart Commits:**
   - Commit with `BGD-123` in message
   - Automatically links to ticket
   - Shows in Jira's development panel

---

## 📊 Part 5: Jira Ticket Workflow

### Typical Workflow:

```
1. Create PR → Jira ticket auto-created (Status: To Do)
2. Review starts → Move to "In Progress"
3. Changes requested → Add comments in Jira
4. Approved → Move to "In Review"
5. Merged → Move to "Done"
```

### Jira Ticket Example:

**Ticket:** BGD-1  
**Summary:** [PR #1] Add employee creation SQL script  
**Type:** Task  
**Status:** To Do  
**Labels:** pull-request, github  

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
```

---

## 🎨 Part 6: Advanced Integration

### Auto-Transition Tickets

Add workflow to automatically move tickets when PR is merged:

```yaml
name: Update Jira on PR Merge

on:
  pull_request:
    types: [closed]

jobs:
  update-jira:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Transition Jira Issue
        uses: atlassian/gajira-transition@v3
        with:
          issue: ${{ github.event.pull_request.head.ref }}
          transition: "Done"
        env:
          JIRA_BASE_URL: ${{ secrets.JIRA_BASE_URL }}
          JIRA_USER_EMAIL: ${{ secrets.JIRA_USER_EMAIL }}
          JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
```

### Custom Fields

Add custom fields to Jira tickets:

```yaml
fields: |
  {
    "labels": ["pull-request", "github", "automated"],
    "priority": {"name": "Medium"},
    "components": [{"name": "Backend"}],
    "customfield_10001": "Additional info"
  }
```

---

## 🔍 Part 7: Viewing Integration

### In Jira:

1. **Development Panel** (on ticket)
   - Shows linked PRs
   - Shows commits
   - Shows branches
   - Shows build status

2. **Filters:**
   - All PR tickets: `labels = "pull-request"`
   - Open PRs: `labels = "pull-request" AND status != Done`

### In GitHub:

1. **PR Comments:**
   - Shows Jira ticket link
   - Click to view in Jira

2. **Commit Messages:**
   - Include ticket ID: `BGD-123 Fix bug`
   - Shows in Jira automatically

---

## 📱 Part 8: Mobile Access

### Jira Mobile App:

1. Download from App Store/Play Store
2. Sign in with your Atlassian account
3. View and update tickets on the go
4. Get notifications for PR updates

---

## 🛠️ Part 9: Troubleshooting

### Issue: Workflow Not Running

**Check:**
1. Secrets are correctly set in GitHub
2. Workflow file syntax is correct
3. GitHub Actions are enabled
4. Jira API token is valid

### Issue: Ticket Not Created

**Check:**
1. Jira project key is correct
2. API token has correct permissions
3. Check workflow logs in GitHub Actions
4. Verify Jira site URL

### Issue: Smart Commits Not Working

**Check:**
1. GitHub for Jira app is installed
2. Repository is connected in Jira
3. Commit message format is correct: `BGD-123 message`

---

## 📚 Part 10: Best Practices

### Commit Messages:
```bash
# Good
git commit -m "BGD-123 Add employee creation feature"

# Also Good
git commit -m "[BGD-123] Fix validation bug"

# Will link to ticket
git commit -m "BGD-123 #comment Added unit tests"
```

### Branch Names:
```bash
# Good
git checkout -b BGD-123-add-feature

# Also Good
git checkout -b feature/BGD-123-new-functionality
```

### PR Titles:
```bash
# Good
[BGD-123] Add employee creation SQL script

# Also Good
BGD-123: Implement user authentication
```

---

## 🎓 Resources

### Documentation:
- Jira Cloud: https://www.atlassian.com/software/jira/guides
- GitHub for Jira: https://github.com/atlassian/github-for-jira
- Jira API: https://developer.atlassian.com/cloud/jira/platform/rest/v3/

### Tutorials:
- Jira Basics: https://www.atlassian.com/software/jira/guides/getting-started
- Smart Commits: https://support.atlassian.com/jira-software-cloud/docs/process-issues-with-smart-commits/

---

## ✅ Quick Setup Checklist

- [ ] Create free Jira Cloud account
- [ ] Create project (e.g., "Bob GitHub Demo")
- [ ] Install "GitHub for Jira" app
- [ ] Connect GitHub repository
- [ ] Generate Jira API token
- [ ] Add secrets to GitHub repository
- [ ] Create workflow file (pr-to-jira.yml)
- [ ] Test by creating a PR
- [ ] Verify ticket is created in Jira
- [ ] Configure ticket workflow in Jira

---

**Created:** 2026-05-21  
**Repository:** bob-gihub-demo  
**Integration Type:** GitHub Actions + Jira Cloud API  
**Cost:** Free (Jira Free tier + GitHub Actions)