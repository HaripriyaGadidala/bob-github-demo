# GitHub PR to Issue Workflow Guide

## 🎯 Overview

This repository is configured with automated workflows that create GitHub Issues for every Pull Request, providing Jira-like issue tracking without requiring external tools.

## 🔄 How It Works

### When You Create a Pull Request:

1. **Automatic Issue Creation**
   - A GitHub Issue is automatically created
   - Issue title: `[PR #123] Your PR Title`
   - Issue includes:
     - PR details (author, branch, URL)
     - Description from PR
     - Task checklist
     - PR statistics (commits, files changed, additions/deletions)

2. **Automatic Linking**
   - Issue is labeled with `pull-request` and `auto-created`
   - Issue is assigned to the PR author
   - PR gets a comment with the issue number

3. **When PR is Merged/Closed**
   - Related issue is automatically closed
   - Closing comment indicates if PR was merged or closed
   - Issue state reflects the outcome

## 📋 Workflow Files

### 1. `.github/workflows/pr-to-issue.yml`
Creates a tracking issue when a PR is opened.

**Triggers:** When a PR is opened
**Permissions:** issues: write, pull-requests: write

### 2. `.github/workflows/close-issue-on-pr.yml`
Closes the tracking issue when PR is merged or closed.

**Triggers:** When a PR is closed (merged or not)
**Permissions:** issues: write, pull-requests: read

## 🚀 Usage Example

### Step 1: Create a Feature Branch
```bash
git checkout -b feature/add-new-functionality
```

### Step 2: Make Changes and Commit
```bash
git add .
git commit -m "[FEATURE]: Add new functionality"
git push origin feature/add-new-functionality
```

### Step 3: Create Pull Request
```bash
# Via GitHub CLI
gh pr create --title "Add new functionality" --body "Description of changes"

# Or via GitHub web interface
# Navigate to your repository and click "New Pull Request"
```

### Step 4: Automatic Issue Creation
✅ GitHub Actions automatically creates an issue like:

**Issue #1: [PR #1] Add new functionality**
```
## 🔗 Related Pull Request
This issue was automatically created from Pull Request #1

**PR Title:** Add new functionality
**PR Author:** @HaripriyaGadidala
**PR URL:** https://github.com/HaripriyaGadidala/bob-gihub-demo/pull/1
**Branch:** `feature/add-new-functionality` → `main`

## 📝 Description
Description of changes

## ✅ Tasks
- [ ] Review code changes
- [ ] Test functionality
- [ ] Approve PR
- [ ] Merge to main

## 📊 PR Details
- **Commits:** 3
- **Changed Files:** 5
- **Additions:** +150
- **Deletions:** -20
```

### Step 5: Track Progress
- Use the issue to track review progress
- Check off tasks as they're completed
- Add comments for discussions

### Step 6: Merge PR
When you merge the PR:
- ✅ Issue automatically closes
- Comment added: "✅ Pull Request #1 was merged. Closing this tracking issue automatically."

## 🏷️ Issue Labels

The workflow automatically applies these labels:
- `pull-request` - Indicates this is a PR tracking issue
- `auto-created` - Shows it was created by automation

## 📊 Benefits

### Compared to Manual Issue Creation:
✅ **Automatic** - No manual work required
✅ **Consistent** - Same format every time
✅ **Linked** - PR and Issue are connected
✅ **Tracked** - Easy to see all PR-related issues
✅ **Free** - No external tools needed

### Jira-like Features:
- Issue tracking for every PR
- Automatic status updates
- Task checklists
- Assignees
- Labels for categorization
- Comments and discussions
- Search and filtering

## 🔧 Customization

### Modify Issue Template
Edit `.github/workflows/pr-to-issue.yml` to customize:
- Issue title format
- Issue body content
- Labels applied
- Task checklist items

### Add More Labels
```yaml
labels: ['pull-request', 'auto-created', 'needs-review', 'enhancement']
```

### Add Reviewers
```yaml
assignees: [pr.user.login, 'reviewer1', 'reviewer2']
```

### Custom Task Checklist
```yaml
## ✅ Tasks
- [ ] Code review completed
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Documentation updated
- [ ] Security scan passed
- [ ] Performance tested
```

## 📈 Viewing Issues

### All PR Tracking Issues:
```
https://github.com/HaripriyaGadidala/bob-gihub-demo/issues?q=is%3Aissue+label%3Apull-request
```

### Open PR Issues:
```
https://github.com/HaripriyaGadidala/bob-gihub-demo/issues?q=is%3Aopen+label%3Apull-request
```

### Closed PR Issues:
```
https://github.com/HaripriyaGadidala/bob-gihub-demo/issues?q=is%3Aclosed+label%3Apull-request
```

## 🛠️ Troubleshooting

### Issue Not Created?
1. Check GitHub Actions tab for workflow runs
2. Verify workflow file syntax
3. Ensure repository has Issues enabled
4. Check workflow permissions

### Issue Not Closing?
1. Verify PR was actually merged/closed
2. Check workflow logs in Actions tab
3. Ensure issue has correct labels

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Issues Guide](https://docs.github.com/en/issues)
- [GitHub CLI](https://cli.github.com/)

## 🎓 Best Practices

1. **Write Clear PR Descriptions** - They become issue descriptions
2. **Use Conventional Commits** - Makes tracking easier
3. **Link Related Issues** - Use "Closes #123" in PR description
4. **Review Checklist** - Complete tasks in the auto-created issue
5. **Add Comments** - Use issue for PR-related discussions

## 🔐 Security Note

The workflows use `GITHUB_TOKEN` which is automatically provided by GitHub Actions. No additional secrets or tokens are required.

---

**Created:** 2026-05-20  
**Repository:** bob-gihub-demo  
**Workflow Version:** 1.0