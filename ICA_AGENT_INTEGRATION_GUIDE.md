# 🤖 IBM Consulting Advantage (ICA) Agent Integration Guide

## 📋 Overview

This guide explains how to integrate the Bob Agent automation workflow with **IBM Consulting Advantage (ICA) Agent & Assistant Studio**, enabling users to make code changes through the ICA UI and automatically trigger the complete automation flow.

**ICA Portal:** https://servicesessentials.ibm.com/launchpad/agent-assistant-studio

---

## 🎯 Integration Architecture

```
ICA Agent Studio UI
        ↓
User makes changes via ICA
        ↓
ICA triggers GitHub workflow
        ↓
Bob Agent automation starts
        ↓
Auto PR → Auto Jira → Auto Approve → Auto Merge
```

---

## 🚀 Integration Options

### Option 1: ICA Agent with GitHub Actions Integration (Recommended)

Create an ICA Agent that can trigger GitHub workflows via API.

### Option 2: ICA Agentic App with Workflow Orchestration

Build an Agentic App in ICA that orchestrates the complete automation flow.

---

## 📝 Option 1: ICA Agent Setup

### Step 1: Create ICA Agent

1. **Go to ICA Agent Studio:**
   - Visit: https://servicesessentials.ibm.com/launchpad/agent-assistant-studio
   - Click "Create an Agent or Assistant"

2. **Configure Agent:**
   ```yaml
   Agent Name: Bob GitHub Automation Agent
   Description: Automates GitHub PR creation, Jira tickets, and merging
   Type: Assistant
   ```

3. **Add Agent Instructions:**
   ```
   You are Bob, an automation agent that helps users make code changes 
   and automatically creates PRs with Jira tickets.
   
   When a user requests code changes:
   1. Understand the change requirements
   2. Create/modify files in the GitHub repository
   3. Trigger the automation workflow
   4. Provide status updates
   ```

### Step 2: Add GitHub Integration Tool

Create a custom tool in ICA Agent to trigger GitHub workflows:

```json
{
  "name": "trigger_bob_automation",
  "description": "Triggers Bob Agent automation workflow for PR and Jira creation",
  "parameters": {
    "type": "object",
    "properties": {
      "branch_name": {
        "type": "string",
        "description": "Feature branch name (e.g., feature/user-auth)"
      },
      "target_branch": {
        "type": "string",
        "description": "Target branch for PR (default: main)",
        "default": "main"
      },
      "repository": {
        "type": "string",
        "description": "GitHub repository (owner/repo)"
      }
    },
    "required": ["branch_name", "repository"]
  }
}
```

### Step 3: Implement Tool Function

Add this function to your ICA Agent:

```python
import requests
import os

def trigger_bob_automation(branch_name: str, repository: str, target_branch: str = "main"):
    """
    Triggers Bob Agent automation workflow via GitHub API
    """
    # GitHub API endpoint
    url = f"https://api.github.com/repos/{repository}/actions/workflows/bob-auto-pr-jira.yml/dispatches"
    
    # Headers
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {os.getenv('GITHUB_TOKEN')}",
        "X-GitHub-Api-Version": "2022-11-28"
    }
    
    # Payload
    payload = {
        "ref": branch_name,
        "inputs": {
            "branch_name": branch_name,
            "target_branch": target_branch
        }
    }
    
    # Trigger workflow
    response = requests.post(url, json=payload, headers=headers)
    
    if response.status_code == 204:
        return {
            "success": True,
            "message": f"✅ Bob Agent automation triggered for branch: {branch_name}",
            "details": {
                "branch": branch_name,
                "target": target_branch,
                "repository": repository,
                "workflow": "bob-auto-pr-jira.yml"
            }
        }
    else:
        return {
            "success": False,
            "message": f"❌ Failed to trigger automation: {response.text}",
            "status_code": response.status_code
        }
```

### Step 4: Add File Management Tools

Add tools for creating/modifying files:

```python
def create_or_update_file(repository: str, branch: str, file_path: str, content: str, commit_message: str):
    """
    Creates or updates a file in GitHub repository
    """
    import base64
    
    # GitHub API endpoint
    url = f"https://api.github.com/repos/{repository}/contents/{file_path}"
    
    # Headers
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {os.getenv('GITHUB_TOKEN')}",
        "X-GitHub-Api-Version": "2022-11-28"
    }
    
    # Get current file SHA if it exists
    response = requests.get(url, headers=headers, params={"ref": branch})
    sha = response.json().get("sha") if response.status_code == 200 else None
    
    # Encode content
    encoded_content = base64.b64encode(content.encode()).decode()
    
    # Payload
    payload = {
        "message": commit_message,
        "content": encoded_content,
        "branch": branch
    }
    
    if sha:
        payload["sha"] = sha
    
    # Create/update file
    response = requests.put(url, json=payload, headers=headers)
    
    if response.status_code in [200, 201]:
        return {
            "success": True,
            "message": f"✅ File {file_path} updated successfully",
            "commit": response.json()["commit"]["sha"]
        }
    else:
        return {
            "success": False,
            "message": f"❌ Failed to update file: {response.text}"
        }
```

---

## 📝 Option 2: ICA Agentic App Setup

### Step 1: Create Agentic App

1. **Go to ICA Agent Studio:**
   - Click "Create an Agentic App"

2. **Configure App:**
   ```yaml
   App Name: Bob GitHub Automation System
   Description: Complete automation for GitHub PRs and Jira tickets
   Type: Multi-agent workflow
   ```

### Step 2: Define Workflow

Create a workflow with these agents:

```yaml
Workflow: Bob Automation Flow

Agents:
  1. Code Change Agent:
     - Role: Understand user requirements
     - Task: Create/modify code files
     - Output: Changed files list
  
  2. GitHub Agent:
     - Role: Manage GitHub operations
     - Task: Commit changes, create branch
     - Output: Branch name
  
  3. Automation Trigger Agent:
     - Role: Trigger Bob Agent workflows
     - Task: Call GitHub Actions API
     - Output: Workflow run ID
  
  4. Status Monitor Agent:
     - Role: Monitor automation progress
     - Task: Check PR, Jira, merge status
     - Output: Status updates

Flow:
  User Request → Code Change Agent → GitHub Agent → Automation Trigger Agent → Status Monitor Agent → User Notification
```

### Step 3: Implement Workflow Logic

```python
class BobAutomationWorkflow:
    def __init__(self):
        self.github_token = os.getenv('GITHUB_TOKEN')
        self.repository = os.getenv('GITHUB_REPOSITORY')
    
    async def execute(self, user_request: str):
        """
        Executes complete Bob automation workflow
        """
        # Step 1: Understand requirements
        requirements = await self.code_change_agent.analyze(user_request)
        
        # Step 2: Create branch
        branch_name = f"feature/{requirements['feature_name']}"
        await self.github_agent.create_branch(branch_name)
        
        # Step 3: Make changes
        for file_change in requirements['changes']:
            await self.github_agent.update_file(
                branch=branch_name,
                file_path=file_change['path'],
                content=file_change['content'],
                message=file_change['commit_message']
            )
        
        # Step 4: Trigger automation
        workflow_run = await self.automation_trigger_agent.trigger(
            branch_name=branch_name,
            target_branch="main"
        )
        
        # Step 5: Monitor progress
        status = await self.status_monitor_agent.monitor(
            workflow_run_id=workflow_run['id']
        )
        
        return {
            "success": True,
            "branch": branch_name,
            "workflow_run": workflow_run['id'],
            "pr_number": status['pr_number'],
            "jira_ticket": status['jira_ticket'],
            "status": status['current_status']
        }
```

---

## 🔧 Configuration

### Environment Variables

Add these to your ICA Agent/App:

```bash
# GitHub Configuration
GITHUB_TOKEN=ghp_your_github_personal_access_token
GITHUB_REPOSITORY=HaripriyaGadidala/bob-gihub-demo

# Jira Configuration (optional, for direct Jira access)
JIRA_BASE_URL=https://your-site.atlassian.net
JIRA_USER_EMAIL=your-email@example.com
JIRA_API_TOKEN=your-jira-api-token
JIRA_PROJECT_KEY=SCRUM
```

### GitHub Token Permissions

Your GitHub token needs these permissions:
- ✅ `repo` - Full repository access
- ✅ `workflow` - Trigger workflows
- ✅ `write:packages` - Write packages (if needed)

---

## 🎨 User Experience Flow

### Example Conversation

**User:** "I need to add a new login feature to the application"

**ICA Agent:**
```
🤖 I'll help you add the login feature. Let me:

1. ✅ Create a feature branch: feature/add-login
2. ✅ Add login.js file with authentication logic
3. ✅ Add login.html with form UI
4. ✅ Update app.js to integrate login
5. ✅ Commit changes
6. ✅ Trigger Bob Agent automation

⏳ Automation in progress...

✅ Complete! Here's what happened:
- PR #123 created: "[BOB-AUTO] Add Login"
- Jira ticket SCRUM-45 created and linked
- Quality checks passed
- PR approved automatically
- PR merged to main
- Jira ticket updated to "Done"

🎉 Your login feature is now live!
```

---

## 📊 ICA Agent Prompts

### System Prompt

```
You are Bob, an intelligent automation agent integrated with GitHub and Jira.

Your capabilities:
1. Understand user requirements for code changes
2. Create/modify files in GitHub repositories
3. Trigger automated PR creation and Jira ticket generation
4. Monitor automation progress
5. Provide real-time status updates

When a user requests changes:
1. Clarify requirements if needed
2. Propose the changes you'll make
3. Create a feature branch
4. Make the code changes
5. Trigger Bob Agent automation
6. Monitor and report progress
7. Confirm completion

Always:
- Use clear, descriptive branch names (feature/*, bugfix/*, etc.)
- Write meaningful commit messages
- Provide status updates at each step
- Confirm successful completion
```

### User Interaction Prompts

```
# Initial Request
"What code changes would you like me to make?"

# Clarification
"I understand you want to add [feature]. Should I:
1. Create new files: [list]
2. Modify existing files: [list]
3. Target branch: main

Proceed? (yes/no)"

# Progress Updates
"⏳ Creating feature branch..."
"✅ Branch created: feature/add-login"
"⏳ Adding files..."
"✅ Files added: login.js, login.html"
"⏳ Triggering automation..."
"✅ Automation started!"

# Completion
"🎉 All done! Your changes are live.
- PR: #123
- Jira: SCRUM-45
- Status: Merged"
```

---

## 🔗 API Integration

### Trigger Automation via REST API

```bash
# Trigger Bob Agent workflow
curl -X POST \
  https://api.github.com/repos/HaripriyaGadidala/bob-gihub-demo/actions/workflows/bob-auto-pr-jira.yml/dispatches \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d '{
    "ref": "feature/my-feature",
    "inputs": {
      "branch_name": "feature/my-feature",
      "target_branch": "main"
    }
  }'
```

### Check Workflow Status

```bash
# Get workflow runs
curl -X GET \
  https://api.github.com/repos/HaripriyaGadidala/bob-gihub-demo/actions/runs \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"
```

### Get PR Details

```bash
# Get PR by number
curl -X GET \
  https://api.github.com/repos/HaripriyaGadidala/bob-gihub-demo/pulls/123 \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"
```

---

## 🎯 Complete Integration Example

### ICA Agent Tool Definition

```json
{
  "tools": [
    {
      "name": "make_code_changes",
      "description": "Makes code changes and triggers Bob Agent automation",
      "parameters": {
        "type": "object",
        "properties": {
          "feature_name": {
            "type": "string",
            "description": "Name of the feature (e.g., 'user-authentication')"
          },
          "files": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "path": {"type": "string"},
                "content": {"type": "string"},
                "action": {"type": "string", "enum": ["create", "update", "delete"]}
              }
            }
          },
          "commit_message": {
            "type": "string",
            "description": "Commit message for the changes"
          }
        },
        "required": ["feature_name", "files", "commit_message"]
      }
    }
  ]
}
```

### Implementation

```python
async def make_code_changes(feature_name: str, files: list, commit_message: str):
    """
    Complete automation: Create branch, make changes, trigger Bob Agent
    """
    repository = os.getenv('GITHUB_REPOSITORY')
    branch_name = f"feature/{feature_name}"
    
    # Step 1: Create branch
    await create_branch(repository, branch_name, from_branch="main")
    
    # Step 2: Make file changes
    for file in files:
        if file['action'] in ['create', 'update']:
            await create_or_update_file(
                repository=repository,
                branch=branch_name,
                file_path=file['path'],
                content=file['content'],
                commit_message=commit_message
            )
    
    # Step 3: Trigger Bob Agent automation
    result = await trigger_bob_automation(
        branch_name=branch_name,
        repository=repository,
        target_branch="main"
    )
    
    # Step 4: Monitor progress
    status = await monitor_automation(repository, branch_name)
    
    return {
        "success": True,
        "branch": branch_name,
        "pr_number": status['pr_number'],
        "jira_ticket": status['jira_ticket'],
        "status": "Automation complete",
        "message": f"✅ Feature '{feature_name}' deployed successfully!"
    }
```

---

## 📱 ICA UI Integration

### Dashboard View

```
┌─────────────────────────────────────────────────┐
│  Bob GitHub Automation Agent                    │
├─────────────────────────────────────────────────┤
│                                                 │
│  💬 Chat with Bob                               │
│  ┌───────────────────────────────────────────┐ │
│  │ User: Add a contact form to the website  │ │
│  │                                           │ │
│  │ Bob: I'll add a contact form. Creating:  │ │
│  │ - contact.html (form UI)                 │ │
│  │ - contact.js (form validation)           │ │
│  │ - contact.css (styling)                  │ │
│  │                                           │ │
│  │ ✅ Branch created: feature/contact-form  │ │
│  │ ✅ Files added                           │ │
│  │ ✅ PR #124 created                       │ │
│  │ ✅ Jira SCRUM-46 created                 │ │
│  │ ✅ Merged to main                        │ │
│  │                                           │ │
│  │ 🎉 Contact form is live!                 │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  📊 Recent Automations                          │
│  ┌───────────────────────────────────────────┐ │
│  │ #124 - Contact Form      ✅ Merged        │ │
│  │ #123 - User Login        ✅ Merged        │ │
│  │ #122 - Bug Fix           ✅ Merged        │ │
│  └───────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

---

## ✅ Setup Checklist

- [ ] ICA Agent/App created in Agent Studio
- [ ] GitHub token configured with proper permissions
- [ ] Repository environment variables set
- [ ] Custom tools implemented
- [ ] Workflow logic tested
- [ ] User prompts configured
- [ ] Error handling implemented
- [ ] Status monitoring working
- [ ] Documentation provided to users

---

## 🚀 Deployment

### Deploy to ICA

1. **Package your agent:**
   ```bash
   # Export agent configuration
   ica-cli export-agent --name "Bob GitHub Automation Agent"
   ```

2. **Deploy to production:**
   ```bash
   # Deploy agent
   ica-cli deploy-agent --config agent-config.json
   ```

3. **Test integration:**
   ```bash
   # Test automation flow
   ica-cli test-agent --agent-id "bob-automation" --test-case "create-feature"
   ```

---

## 📞 Support

### ICA Agent Studio
- Portal: https://servicesessentials.ibm.com/launchpad/agent-assistant-studio
- Documentation: IBM Consulting Advantage docs

### Bob Agent
- Repository: https://github.com/HaripriyaGadidala/bob-gihub-demo
- Documentation: See repository files

---

**Created:** 2026-06-01  
**Version:** 1.0  
**Integration Type:** ICA Agent Studio + GitHub Actions + Jira  
**Status:** Ready for Implementation

---

*Made with ❤️ by Bob Agent for IBM Consulting Advantage*