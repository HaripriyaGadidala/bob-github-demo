# ICA Agent Orchestration Integration with Bob GitHub Demo

## Overview

This guide explains how to integrate the ICA (IBM Cloud Automation) 6-agent orchestration pipeline with the existing Bob Agent GitHub automation workflows in the `bob-github-demo` repository.

## Architecture

### Current Bob Agent Setup
- **GitHub Workflows**: Automated PR creation, Jira integration, auto-merge
- **Repository**: `bob-github-demo`
- **Jira Project**: SCRUM
- **Workflows**:
  - `bob-auto-merge.yml` - Auto-approve and merge PRs
  - `pr-to-jira.yml` - Create Jira tickets from PRs
  - `update-jira-on-merge.yml` - Update Jira status on merge
  - `close-issue-on-pr.yml` - Close GitHub issues on PR merge

### ICA Agent Pipeline
Six sequential agents that transform user requests into implemented code:
1. **Requirements Analyzer** - Analyzes requests and creates implementation plans
2. **Code Generator** - Generates production-ready code
3. **GitHub Operations** - Applies code to repository
4. **Automation Orchestrator** - Triggers GitHub workflows
5. **Status Monitor** - Tracks PR and workflow status
6. **User Communication** - Provides friendly updates

## Integration Architecture

```
User Request
     ↓
[ICA Agent Pipeline]
     ↓
Requirements Analyzer → Implementation Plan
     ↓
Code Generator → Generated Code Files
     ↓
GitHub Operations → Branch + Commit + Push
     ↓
[Bob Agent Workflows Triggered]
     ↓
pr-to-jira.yml → Creates Jira Ticket (SCRUM-X)
     ↓
bob-auto-merge.yml → Auto-approves & Merges PR
     ↓
update-jira-on-merge.yml → Moves Jira to "Done"
     ↓
[ICA Pipeline Continues]
     ↓
Automation Orchestrator → Monitors Workflow
     ↓
Status Monitor → Tracks PR/Jira Status
     ↓
User Communication → Friendly Status Update
```

## Step-by-Step Integration Guide

### Phase 1: Environment Setup

#### 1.1 Configure ICA Environment Variables

Create a `.env` file or configure in ICA platform:

```bash
# GitHub Configuration
GITHUB_TOKEN=<your-github-token>
GITHUB_REPO=HaripriyaGadidala/bob-gihub-demo
GITHUB_OWNER=HaripriyaGadidala
GITHUB_DEFAULT_BRANCH=main

# Jira Configuration
JIRA_BASE_URL=https://haripriya-bob.atlassian.net
JIRA_USER_EMAIL=<your-jira-email>
JIRA_API_TOKEN=<your-jira-api-token>
JIRA_PROJECT_KEY=SCRUM

# ICA Configuration
ICA_API_ENDPOINT=<your-ica-endpoint>
ICA_API_KEY=<your-ica-api-key>
```

#### 1.2 Install Required Dependencies

For the ICA agents to interact with GitHub and Jira:

```bash
# Python dependencies
pip install PyGithub requests python-dotenv

# Node.js dependencies (if using Node)
npm install @octokit/rest axios dotenv
```

### Phase 2: Implement GitHub Operations Agent

#### 2.1 Create GitHub Operations Module

Create `ica-agents/github_operations.py`:

```python
import os
from github import Github
from datetime import datetime

class GitHubOperations:
    def __init__(self):
        self.token = os.getenv('GITHUB_TOKEN')
        self.repo_name = os.getenv('GITHUB_REPO')
        self.g = Github(self.token)
        self.repo = self.g.get_repo(self.repo_name)
    
    def create_feature_branch(self, branch_name):
        """Create a new feature branch from main"""
        try:
            main_branch = self.repo.get_branch('main')
            self.repo.create_git_ref(
                ref=f'refs/heads/{branch_name}',
                sha=main_branch.commit.sha
            )
            return {
                'success': True,
                'branch': branch_name,
                'sha': main_branch.commit.sha
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def commit_files(self, branch_name, files, commit_message):
        """Commit multiple files to a branch"""
        try:
            branch = self.repo.get_branch(branch_name)
            
            for file_path, content in files.items():
                try:
                    # Try to get existing file
                    contents = self.repo.get_contents(file_path, ref=branch_name)
                    self.repo.update_file(
                        path=file_path,
                        message=commit_message,
                        content=content,
                        sha=contents.sha,
                        branch=branch_name
                    )
                except:
                    # File doesn't exist, create it
                    self.repo.create_file(
                        path=file_path,
                        message=commit_message,
                        content=content,
                        branch=branch_name
                    )
            
            return {
                'success': True,
                'branch': branch_name,
                'files_committed': len(files)
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def create_pull_request(self, branch_name, title, body):
        """Create a pull request"""
        try:
            pr = self.repo.create_pull(
                title=title,
                body=body,
                head=branch_name,
                base='main'
            )
            
            # Add bob-agent label for auto-merge
            pr.add_to_labels('bob-agent')
            
            return {
                'success': True,
                'pr_number': pr.number,
                'pr_url': pr.html_url,
                'pr_id': pr.id
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def get_workflow_runs(self, workflow_name, branch_name):
        """Get workflow runs for a specific branch"""
        try:
            workflows = self.repo.get_workflow_runs(
                branch=branch_name,
                event='pull_request'
            )
            
            runs = []
            for run in workflows:
                if workflow_name in run.name:
                    runs.append({
                        'id': run.id,
                        'status': run.status,
                        'conclusion': run.conclusion,
                        'url': run.html_url
                    })
            
            return {'success': True, 'runs': runs}
        except Exception as e:
            return {'success': False, 'error': str(e)}
```

#### 2.2 Create Automation Orchestrator Module

Create `ica-agents/automation_orchestrator.py`:

```python
import os
import time
from github import Github

class AutomationOrchestrator:
    def __init__(self):
        self.token = os.getenv('GITHUB_TOKEN')
        self.repo_name = os.getenv('GITHUB_REPO')
        self.g = Github(self.token)
        self.repo = self.g.get_repo(self.repo_name)
    
    def trigger_workflow(self, workflow_file, branch_name, inputs=None):
        """Trigger a GitHub Actions workflow"""
        try:
            workflow = self.repo.get_workflow(workflow_file)
            
            # Trigger workflow dispatch
            success = workflow.create_dispatch(
                ref=branch_name,
                inputs=inputs or {}
            )
            
            return {
                'success': success,
                'workflow': workflow_file,
                'branch': branch_name
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def wait_for_workflow_completion(self, workflow_name, branch_name, timeout=300):
        """Wait for workflow to complete with timeout"""
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            runs = self.repo.get_workflow_runs(
                branch=branch_name,
                event='pull_request'
            )
            
            for run in runs:
                if workflow_name in run.name:
                    if run.status == 'completed':
                        return {
                            'success': True,
                            'conclusion': run.conclusion,
                            'url': run.html_url
                        }
            
            time.sleep(10)  # Check every 10 seconds
        
        return {'success': False, 'error': 'Timeout waiting for workflow'}
```

#### 2.3 Create Status Monitor Module

Create `ica-agents/status_monitor.py`:

```python
import os
import requests
from github import Github

class StatusMonitor:
    def __init__(self):
        self.token = os.getenv('GITHUB_TOKEN')
        self.repo_name = os.getenv('GITHUB_REPO')
        self.jira_url = os.getenv('JIRA_BASE_URL')
        self.jira_email = os.getenv('JIRA_USER_EMAIL')
        self.jira_token = os.getenv('JIRA_API_TOKEN')
        self.g = Github(self.token)
        self.repo = self.g.get_repo(self.repo_name)
    
    def get_pr_status(self, pr_number):
        """Get comprehensive PR status"""
        try:
            pr = self.repo.get_pull(pr_number)
            
            # Extract Jira ticket from PR title
            jira_ticket = None
            if '[SCRUM-' in pr.title:
                jira_ticket = pr.title.split('[')[1].split(']')[0]
            
            return {
                'success': True,
                'pr_number': pr.number,
                'pr_url': pr.html_url,
                'state': pr.state,
                'merged': pr.merged,
                'mergeable': pr.mergeable,
                'jira_ticket': jira_ticket,
                'checks_status': self._get_checks_status(pr)
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def _get_checks_status(self, pr):
        """Get status of all checks on a PR"""
        try:
            commit = pr.get_commits().reversed[0]
            statuses = commit.get_statuses()
            
            checks = []
            for status in statuses:
                checks.append({
                    'context': status.context,
                    'state': status.state,
                    'description': status.description
                })
            
            return checks
        except:
            return []
    
    def get_jira_status(self, ticket_key):
        """Get Jira ticket status"""
        try:
            url = f"{self.jira_url}/rest/api/3/issue/{ticket_key}"
            auth = (self.jira_email, self.jira_token)
            
            response = requests.get(url, auth=auth)
            
            if response.status_code == 200:
                data = response.json()
                return {
                    'success': True,
                    'ticket': ticket_key,
                    'status': data['fields']['status']['name'],
                    'url': f"{self.jira_url}/browse/{ticket_key}"
                }
            else:
                return {'success': False, 'error': f'HTTP {response.status_code}'}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def get_complete_status(self, pr_number):
        """Get complete status including PR, workflows, and Jira"""
        pr_status = self.get_pr_status(pr_number)
        
        if not pr_status['success']:
            return pr_status
        
        result = pr_status.copy()
        
        # Get Jira status if ticket exists
        if pr_status.get('jira_ticket'):
            jira_status = self.get_jira_status(pr_status['jira_ticket'])
            result['jira_status'] = jira_status
        
        return result
```

### Phase 3: Integrate with ICA Agent Orchestration

#### 3.1 Update Agent Instructions

Modify the `github-operations` agent in your ICA spec:

```yaml
- name: github-operations
  type: worker
  role: GitHub Operations Agent
  goal: Apply generated code to repository via standard GitHub workflows.
  instructions: |
    Purpose:
      Apply code changes to GitHub using the GitHubOperations module.

    Step-by-step process:
      1. Generate unique branch name: feature/ica-{timestamp}
      2. Call GitHubOperations.create_feature_branch(branch_name)
      3. Call GitHubOperations.commit_files(branch_name, files, commit_message)
      4. Call GitHubOperations.create_pull_request(branch_name, title, body)
      5. Return PR details for next agent

    Output format:
      {
        "branch_name": "feature/ica-1234567890",
        "pr_number": 10,
        "pr_url": "https://github.com/...",
        "commit_sha": "abc123..."
      }
  model: gpt-4o
  tools:
    - github_operations
```

#### 3.2 Update Automation Orchestrator

```yaml
- name: automation-orchestrator
  type: worker
  role: Automation Orchestrator
  goal: Monitor Bob Agent workflows automatically triggered by PR creation.
  instructions: |
    Purpose:
      The PR creation automatically triggers Bob Agent workflows.
      Monitor their execution and wait for completion.

    Step-by-step process:
      1. Receive PR details from github-operations
      2. Wait 30 seconds for workflows to start
      3. Call AutomationOrchestrator.wait_for_workflow_completion()
      4. Return workflow results

    Note:
      - pr-to-jira.yml triggers automatically on PR open
      - bob-auto-merge.yml triggers automatically on PR open
      - No manual workflow dispatch needed

    Output format:
      {
        "workflows": [
          {"name": "pr-to-jira", "status": "completed", "conclusion": "success"},
          {"name": "bob-auto-merge", "status": "completed", "conclusion": "success"}
        ]
      }
  model: gpt-4o
  tools:
    - automation_orchestrator
```

#### 3.3 Update Status Monitor

```yaml
- name: status-monitor
  type: worker
  role: Status Monitor
  goal: Track PR, workflow, and Jira-related status until completion.
  instructions: |
    Purpose:
      Monitor complete lifecycle: PR → Jira ticket → Auto-merge → Done

    Step-by-step process:
      1. Call StatusMonitor.get_complete_status(pr_number)
      2. Check PR state (open/merged/closed)
      3. Verify Jira ticket created and status
      4. Confirm auto-merge completion
      5. Return comprehensive status

    Success indicators:
      - PR merged successfully
      - Jira ticket moved to "Done"
      - All checks passed

    Output format:
      {
        "pr_status": "merged",
        "jira_ticket": "SCRUM-10",
        "jira_status": "Done",
        "all_checks_passed": true,
        "summary": "Implementation complete and deployed"
      }
  model: gpt-4o
  tools:
    - status_monitor
```

### Phase 4: Testing the Integration

#### 4.1 End-to-End Test

Create `test_ica_integration.py`:

```python
import os
from datetime import datetime
from ica_agents.github_operations import GitHubOperations
from ica_agents.automation_orchestrator import AutomationOrchestrator
from ica_agents.status_monitor import StatusMonitor

def test_full_pipeline():
    """Test complete ICA → Bob Agent integration"""
    
    # 1. Simulate code generation
    generated_files = {
        'test_file.py': 'print("Hello from ICA Agent")\n',
        'README.md': '# Test Integration\n\nGenerated by ICA Agent\n'
    }
    
    # 2. GitHub Operations
    gh_ops = GitHubOperations()
    
    branch_name = f"feature/ica-test-{int(datetime.now().timestamp())}"
    print(f"Creating branch: {branch_name}")
    
    branch_result = gh_ops.create_feature_branch(branch_name)
    print(f"Branch created: {branch_result}")
    
    commit_result = gh_ops.commit_files(
        branch_name,
        generated_files,
        "feat: ICA Agent test integration"
    )
    print(f"Files committed: {commit_result}")
    
    pr_result = gh_ops.create_pull_request(
        branch_name,
        "ICA Agent Test Integration",
        "This PR was created by the ICA Agent pipeline for testing."
    )
    print(f"PR created: {pr_result}")
    
    # 3. Monitor automation
    if pr_result['success']:
        pr_number = pr_result['pr_number']
        
        print("\nWaiting for Bob Agent workflows...")
        import time
        time.sleep(60)  # Wait for workflows to complete
        
        # 4. Check status
        monitor = StatusMonitor()
        status = monitor.get_complete_status(pr_number)
        print(f"\nFinal status: {status}")
        
        return status
    
    return None

if __name__ == "__main__":
    test_full_pipeline()
```

Run the test:

```bash
python test_ica_integration.py
```

### Phase 5: Production Deployment

#### 5.1 Deploy ICA Agent Specification

```bash
# Deploy to ICA platform
ica-cli deploy --spec github-automation-pipeline.yaml --env production
```

#### 5.2 Configure Monitoring

Set up monitoring for:
- Agent execution times
- GitHub API rate limits
- Jira API rate limits
- Workflow success rates

#### 5.3 Set Up Alerts

Configure alerts for:
- Failed PR creations
- Workflow failures
- Jira ticket creation failures
- Auto-merge failures

## Usage Examples

### Example 1: Simple Feature Request

**User Input:**
```
"Add a new endpoint /api/health that returns server status"
```

**ICA Pipeline Flow:**
1. Requirements Analyzer → Creates implementation plan
2. Code Generator → Generates endpoint code
3. GitHub Operations → Creates PR with code
4. Bob Workflows Trigger → Creates SCRUM-11, auto-merges
5. Status Monitor → Confirms merge and Jira "Done"
6. User Communication → "✅ Health endpoint deployed successfully!"

### Example 2: Bug Fix Request

**User Input:**
```
"Fix the authentication timeout issue in login.py"
```

**ICA Pipeline Flow:**
1. Requirements Analyzer → Identifies fix location
2. Code Generator → Generates patched code
3. GitHub Operations → Creates PR with fix
4. Bob Workflows Trigger → Creates SCRUM-12, auto-merges
5. Status Monitor → Confirms merge and Jira "Done"
6. User Communication → "🐛 Authentication bug fixed and deployed!"

## Troubleshooting

### Common Issues

#### 1. PR Not Auto-Merging

**Symptom:** PR created but not auto-merged

**Solution:**
- Ensure PR has `bob-agent` label
- Check PR is not in draft mode
- Verify no merge conflicts
- Check workflow logs in GitHub Actions

#### 2. Jira Ticket Not Created

**Symptom:** PR created but no Jira ticket

**Solution:**
- Verify Jira credentials in GitHub Secrets
- Check `pr-to-jira.yml` workflow logs
- Ensure Jira project key is correct

#### 3. Jira Ticket Not Moving to Done

**Symptom:** PR merged but Jira still "TO DO"

**Solution:**
- Verify PR title contains `[SCRUM-X]` format
- Check `update-jira-on-merge.yml` workflow logs
- Ensure Jira transition "Done" exists in workflow

## Next Steps

1. **Add MCP Tools**: Integrate GitHub and Jira MCP servers for direct API access
2. **Enhanced Monitoring**: Add real-time status updates via webhooks
3. **Multi-Repository Support**: Extend to handle multiple repositories
4. **Advanced Code Generation**: Add context from existing codebase
5. **Rollback Capability**: Implement automatic rollback on failures

## Support

For issues or questions:
- GitHub Issues: https://github.com/HaripriyaGadidala/bob-gihub-demo/issues
- Documentation: See other guides in this repository
- ICA Platform: Refer to ICA documentation

---

**Last Updated:** June 1, 2026
**Version:** 1.0
**Maintained by:** Platform Engineering Team