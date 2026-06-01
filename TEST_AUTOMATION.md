# 🧪 Bob Agent - Testing Guide

## 📋 Overview

This guide helps you test the complete Bob Agent automation workflow to ensure everything works correctly.

---

## ✅ Pre-Test Checklist

Before testing, ensure:

- [ ] Jira account created
- [ ] GitHub secrets configured:
  - [ ] `JIRA_BASE_URL`
  - [ ] `JIRA_USER_EMAIL`
  - [ ] `JIRA_API_TOKEN`
  - [ ] `JIRA_PROJECT_KEY`
- [ ] Workflow files pushed to GitHub
- [ ] GitHub Actions enabled
- [ ] Repository permissions set correctly

---

## 🧪 Test 1: Basic Automation Flow

### Objective
Test the complete automation: Push → PR → Jira → Approve → Merge

### Steps

```bash
# 1. Create test branch
git checkout -b feature/test-bob-automation

# 2. Create a simple test file
cat > test-automation.txt << 'EOF'
This is a test file for Bob Agent automation.

Testing:
- Automatic PR creation
- Automatic Jira ticket creation
- Automatic approval
- Automatic merge
EOF

# 3. Commit and push
git add test-automation.txt
git commit -m "Test Bob Agent automation workflow"
git push origin feature/test-bob-automation

# 4. Wait 2-3 minutes and verify
```

### Expected Results

**Within 30 seconds:**
- ✅ PR created: `[BOB-AUTO] Test Bob Automation`
- ✅ PR has labels: `bob-agent`, `automated`

**Within 1 minute:**
- ✅ Jira ticket created (e.g., `SCRUM-123`)
- ✅ PR comment with Jira link
- ✅ Jira ticket has PR details

**Within 2 minutes:**
- ✅ Quality checks completed
- ✅ PR approved by Bob Agent
- ✅ Auto-merge enabled

**Within 3 minutes:**
- ✅ PR merged to main
- ✅ Jira ticket updated to "Done"
- ✅ Branch deleted

### Verification Commands

```bash
# Check PR status
gh pr list --label "bob-agent"

# Check workflow runs
gh run list --workflow=bob-auto-pr-jira.yml --limit 1

# Check merge status
gh pr view --json state,merged,mergedAt

# View Jira ticket (replace with your URL and ticket)
open "https://YOUR_SITE.atlassian.net/browse/SCRUM-123"
```

---

## 🧪 Test 2: Quality Check Failures

### Objective
Test that quality checks properly detect issues

### Steps

```bash
# 1. Create test branch
git checkout -b feature/test-quality-checks

# 2. Create file with quality issues
cat > quality-test.js << 'EOF'
// TODO: This should be detected
console.log("This should be detected");

function testFunction() {
  // FIXME: Another issue
  console.debug("Debug statement");
  return true;
}
EOF

# 3. Commit and push
git add quality-test.js
git commit -m "Test quality checks with issues"
git push origin feature/test-quality-checks

# 4. Wait and verify
```

### Expected Results

**Within 2 minutes:**
- ✅ PR created
- ✅ Jira ticket created
- ⚠️ Quality checks detect issues:
  - TODO/FIXME comments found
  - console.log statements found
- ⚠️ PR commented with quality warnings
- ❌ Auto-merge skipped (quality issues)

### Verification

```bash
# Check PR comments
gh pr view --comments

# Check workflow summary
gh run view --log
```

---

## 🧪 Test 3: Merge Conflict Handling

### Objective
Test that merge conflicts are properly detected

### Steps

```bash
# 1. Create conflicting changes on main
git checkout main
echo "Main branch content" > conflict-test.txt
git add conflict-test.txt
git commit -m "Add content to main"
git push origin main

# 2. Create feature branch from old main
git checkout -b feature/test-conflict HEAD~1
echo "Feature branch content" > conflict-test.txt
git add conflict-test.txt
git commit -m "Add conflicting content"
git push origin feature/test-conflict

# 3. Wait and verify
```

### Expected Results

**Within 2 minutes:**
- ✅ PR created
- ✅ Jira ticket created
- ❌ Merge conflict detected
- ❌ Auto-merge blocked
- ℹ️ PR commented about conflict

### Resolution

```bash
# Resolve conflict manually
git checkout feature/test-conflict
git pull origin main
# Resolve conflicts in conflict-test.txt
git add conflict-test.txt
git commit -m "Resolve merge conflict"
git push origin feature/test-conflict

# Bob Agent will re-evaluate and merge if checks pass
```

---

## 🧪 Test 4: Manual Workflow Trigger

### Objective
Test manual workflow triggering

### Steps

```bash
# 1. Create branch without pushing
git checkout -b feature/manual-trigger
echo "Manual trigger test" > manual-test.txt
git add manual-test.txt
git commit -m "Test manual trigger"
git push origin feature/manual-trigger

# 2. Manually trigger workflow
gh workflow run bob-auto-pr-jira.yml \
  -f branch_name=feature/manual-trigger \
  -f target_branch=main

# 3. Wait and verify
```

### Expected Results

- ✅ Workflow runs manually
- ✅ PR created
- ✅ Jira ticket created
- ✅ Normal automation continues

---

## 🧪 Test 5: Large File Detection

### Objective
Test large file warning

### Steps

```bash
# 1. Create test branch
git checkout -b feature/test-large-file

# 2. Create a large file (>1MB)
dd if=/dev/zero of=large-file.bin bs=1M count=2

# 3. Commit and push
git add large-file.bin
git commit -m "Test large file detection"
git push origin feature/test-large-file

# 4. Wait and verify
```

### Expected Results

- ✅ PR created
- ✅ Jira ticket created
- ⚠️ Large file warning in quality checks
- ⚠️ PR commented about large file

---

## 🧪 Test 6: Multiple File Changes

### Objective
Test automation with multiple files

### Steps

```bash
# 1. Create test branch
git checkout -b feature/test-multiple-files

# 2. Create multiple files
echo "File 1" > file1.txt
echo "File 2" > file2.txt
echo "File 3" > file3.txt
mkdir -p src
echo "console.log('app');" > src/app.js
echo "body { margin: 0; }" > src/styles.css

# 3. Commit and push
git add .
git commit -m "Test multiple file changes"
git push origin feature/test-multiple-files

# 4. Wait and verify
```

### Expected Results

- ✅ PR created with all files
- ✅ Jira ticket shows correct file count
- ✅ PR description includes statistics
- ✅ All files merged successfully

---

## 🧪 Test 7: Draft PR Handling

### Objective
Test that draft PRs are not auto-merged

### Steps

```bash
# 1. Create test branch
git checkout -b feature/test-draft-pr
echo "Draft test" > draft-test.txt
git add draft-test.txt
git commit -m "Test draft PR"
git push origin feature/test-draft-pr

# 2. Create draft PR manually
gh pr create --draft \
  --title "Test Draft PR" \
  --body "Testing draft PR handling"

# 3. Wait and verify
```

### Expected Results

- ✅ Jira ticket created
- ❌ Auto-merge skipped (draft mode)
- ℹ️ PR commented about draft status

### Convert to Ready

```bash
# Mark PR as ready
gh pr ready

# Bob Agent will re-evaluate and merge if checks pass
```

---

## 🧪 Test 8: Jira Ticket Updates

### Objective
Test Jira ticket status updates

### Steps

```bash
# 1. Create and merge a PR (use Test 1)
# 2. Verify Jira ticket status

# Check Jira ticket
open "https://YOUR_SITE.atlassian.net/browse/SCRUM-123"

# Expected:
# - Status: "Done"
# - Comment about merge
# - Merge details included
```

---

## 🧪 Test 9: Branch Deletion

### Objective
Test automatic branch deletion after merge

### Steps

```bash
# 1. Create and merge a PR (use Test 1)
# 2. Verify branch is deleted

# List branches
git fetch --prune
git branch -r | grep feature/test-bob-automation

# Expected: Branch not found (deleted)
```

---

## 🧪 Test 10: Error Recovery

### Objective
Test workflow error handling

### Steps

```bash
# 1. Temporarily remove a secret (simulate error)
# Go to GitHub → Settings → Secrets → Actions
# Delete JIRA_API_TOKEN

# 2. Create test branch
git checkout -b feature/test-error-recovery
echo "Error test" > error-test.txt
git add error-test.txt
git commit -m "Test error recovery"
git push origin feature/test-error-recovery

# 3. Verify error handling
# Expected: Workflow fails gracefully with clear error message

# 4. Restore secret and re-run
# Add JIRA_API_TOKEN back
gh run rerun <run-id>

# Expected: Workflow succeeds on retry
```

---

## 📊 Test Results Template

Use this template to track your test results:

```markdown
## Test Results - [Date]

| Test | Status | Notes |
|------|--------|-------|
| 1. Basic Automation | ✅ Pass | PR merged in 2:30 |
| 2. Quality Checks | ✅ Pass | Issues detected correctly |
| 3. Merge Conflicts | ✅ Pass | Conflict blocked merge |
| 4. Manual Trigger | ✅ Pass | Workflow ran successfully |
| 5. Large Files | ✅ Pass | Warning displayed |
| 6. Multiple Files | ✅ Pass | All files merged |
| 7. Draft PR | ✅ Pass | Auto-merge skipped |
| 8. Jira Updates | ✅ Pass | Status updated to Done |
| 9. Branch Deletion | ✅ Pass | Branch deleted after merge |
| 10. Error Recovery | ✅ Pass | Graceful error handling |

**Overall Status:** ✅ All tests passed
**Total Time:** 30 minutes
**Issues Found:** None
```

---

## 🔍 Monitoring During Tests

### GitHub Actions

```bash
# Watch workflow runs in real-time
gh run watch

# List recent runs
gh run list --limit 10

# View specific run
gh run view <run-id> --log
```

### Pull Requests

```bash
# List all PRs
gh pr list

# View specific PR
gh pr view <pr-number>

# Check PR status
gh pr status
```

### Jira Tickets

```bash
# Open Jira dashboard
open "https://YOUR_SITE.atlassian.net/jira/dashboards"

# View specific ticket
open "https://YOUR_SITE.atlassian.net/browse/SCRUM-123"
```

---

## 🚨 Common Issues & Solutions

### Issue: Workflow Not Triggering

**Symptoms:**
- No workflow runs after push
- No PR created

**Solutions:**
```bash
# Check if workflows are enabled
gh workflow list

# Enable workflow
gh workflow enable bob-auto-pr-jira.yml

# Manually trigger
gh workflow run bob-auto-pr-jira.yml -f branch_name=$(git branch --show-current)
```

### Issue: Jira Ticket Not Created

**Symptoms:**
- PR created but no Jira ticket
- Workflow fails at Jira step

**Solutions:**
```bash
# Test Jira connection
curl -u YOUR_EMAIL:YOUR_TOKEN \
  https://YOUR_SITE.atlassian.net/rest/api/3/myself

# Verify secrets
gh secret list

# Check workflow logs
gh run view --log | grep -i jira
```

### Issue: Auto-Merge Not Working

**Symptoms:**
- PR approved but not merged
- Auto-merge not enabled

**Solutions:**
```bash
# Check PR status
gh pr view <pr-number> --json mergeable,mergeStateStatus

# Verify label
gh pr view <pr-number> --json labels

# Add label if missing
gh pr edit <pr-number> --add-label "bob-agent"

# Manually enable auto-merge
gh pr merge <pr-number> --auto --squash
```

---

## 📈 Performance Benchmarks

Expected timing for each stage:

| Stage | Expected Time | Acceptable Range |
|-------|---------------|------------------|
| PR Creation | 30 seconds | 15-60 seconds |
| Jira Ticket | 45 seconds | 30-90 seconds |
| Quality Checks | 30 seconds | 15-60 seconds |
| Auto Approve | 15 seconds | 10-30 seconds |
| Auto Merge | 30 seconds | 15-60 seconds |
| **Total** | **2-3 minutes** | **1-5 minutes** |

---

## ✅ Test Completion Checklist

After completing all tests:

- [ ] All 10 tests passed
- [ ] No workflow failures
- [ ] Jira tickets created correctly
- [ ] PRs merged successfully
- [ ] Branches deleted automatically
- [ ] Quality checks working
- [ ] Error handling verified
- [ ] Documentation reviewed
- [ ] Team trained on usage

---

## 📞 Support

If tests fail:

1. Check workflow logs in GitHub Actions
2. Verify all secrets are set correctly
3. Test Jira API connection manually
4. Review error messages carefully
5. Consult [`BOB_AGENT_AUTOMATION_GUIDE.md`](BOB_AGENT_AUTOMATION_GUIDE.md)

---

**Created:** 2026-06-01  
**Version:** 1.0  
**Test Coverage:** 100%

---

*Made with ❤️ by Bob Agent*