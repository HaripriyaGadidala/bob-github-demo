# 🤖 ICA Agent Orchestration - Conversational Setup Guide

## 📋 What You're Seeing

The ICA Agent Orchestration uses a **conversational interface** where you:
1. **Describe what you want** in the chat box
2. **ICA generates YAML** configuration automatically
3. **Review and refine** the generated YAML
4. **Deploy** your agent orchestration

---

## 🎯 Step-by-Step Instructions

### Step 1: Choose Platform

**Select:** `IBM Consulting Advantage` (already selected)

### Step 2: Describe Your Agent System

In the chat box at the bottom (where it says "What would you like to know?"), type this:

```
Create a multi-agent system for GitHub automation with 6 specialized agents:

1. Requirements Analyzer Agent - Analyzes user requests and creates implementation plans
2. Code Generator Agent - Generates code files based on requirements
3. GitHub Operations Agent - Manages GitHub repository operations (branch creation, commits, push)
4. Automation Orchestrator Agent - Triggers GitHub Actions workflows
5. Status Monitor Agent - Monitors PR, Jira ticket, and merge status
6. User Communication Agent - Provides user updates and notifications

The system should:
- Accept natural language requests from users
- Automatically create code changes
- Commit to GitHub
- Trigger automated PR creation
- Create Jira tickets
- Monitor the complete workflow
- Notify users of completion

Each agent should pass data to the next agent in sequence.
```

**Click the blue arrow button** to send

---

## 📝 Alternative: Use Example Prompts

You can also try the suggested prompts at the bottom:

**Click:** "Create a multi-agent system with 3 agents"

Then modify the generated YAML to add our 6 agents.

---

## 🔄 What Happens Next

1. **ICA will generate YAML** in the right panel
2. **Review the YAML** - it will show agent definitions
3. **Refine if needed** - chat with ICA to adjust
4. **Save the configuration**

---

## 📊 Expected YAML Structure

The generated YAML should look like this:

```yaml
agents:
  - name: requirements_analyzer
    description: Analyzes user requirements
    model: gpt-4
    temperature: 0.3
    instructions: |
      You analyze user requests and create implementation plans...
  
  - name: code_generator
    description: Generates code files
    model: gpt-4
    temperature: 0.7
    instructions: |
      You generate clean, working code...
  
  - name: github_operations
    description: Manages GitHub operations
    model: gpt-3.5-turbo
    temperature: 0.1
    instructions: |
      You handle Git and GitHub operations...
  
  - name: automation_orchestrator
    description: Triggers workflows
    model: gpt-3.5-turbo
    temperature: 0.1
    instructions: |
      You trigger and monitor GitHub Actions...
  
  - name: status_monitor
    description: Monitors progress
    model: gpt-3.5-turbo
    temperature: 0.1
    instructions: |
      You track PR and Jira status...
  
  - name: user_communication
    description: Communicates with users
    model: gpt-4
    temperature: 0.8
    instructions: |
      You provide friendly updates to users...

workflow:
  steps:
    - agent: requirements_analyzer
      input: user_request
      output: implementation_plan
    
    - agent: code_generator
      input: implementation_plan
      output: code_files
    
    - agent: github_operations
      input: code_files
      output: branch_info
    
    - agent: automation_orchestrator
      input: branch_info
      output: workflow_run
    
    - agent: status_monitor
      input: workflow_run
      output: final_status
    
    - agent: user_communication
      input: final_status
      output: user_message
```

---

## 🎨 Detailed Agent Descriptions for Chat

If ICA asks for more details, provide these for each agent:

### Agent 1: Requirements Analyzer
```
This agent receives natural language requests from users and analyzes them to create detailed implementation plans. It identifies which files need to be created or modified, determines the scope of changes, and outputs a structured plan with file paths, actions, and implementation steps.
```

### Agent 2: Code Generator
```
This agent takes the implementation plan and generates complete, working code for each file. It follows coding best practices, includes proper error handling, adds comments, and ensures the code is production-ready. It outputs file paths with complete content.
```

### Agent 3: GitHub Operations
```
This agent handles all GitHub repository operations. It creates feature branches with proper naming conventions (feature/, bugfix/, etc.), commits the generated code with meaningful commit messages, and pushes changes to the remote repository. It requires GITHUB_TOKEN and GITHUB_REPOSITORY environment variables.
```

### Agent 4: Automation Orchestrator
```
This agent triggers GitHub Actions workflows via the GitHub API. Specifically, it triggers the bob-auto-pr-jira.yml workflow which automatically creates PRs and Jira tickets. It monitors the workflow execution and reports the run ID and status.
```

### Agent 5: Status Monitor
```
This agent continuously monitors the automation progress. It tracks PR creation, Jira ticket creation, quality checks, approval status, and merge status. It polls GitHub and Jira APIs every 10 seconds and provides real-time status updates until completion.
```

### Agent 6: User Communication
```
This agent communicates with users in a friendly, clear manner. It provides progress updates at each stage using emojis for visual clarity, delivers final success messages with complete summaries, and handles errors gracefully with helpful suggestions.
```

---

## 🔧 Environment Variables to Add

After creating the orchestration, you'll need to add these environment variables:

```bash
GITHUB_TOKEN=your_github_token
GITHUB_REPOSITORY=HaripriyaGadidala/bob-gihub-demo
JIRA_BASE_URL=https://your-site.atlassian.net
JIRA_USER_EMAIL=your-email@example.com
JIRA_API_TOKEN=your_jira_token
JIRA_PROJECT_KEY=SCRUM
WORKFLOW_FILE=bob-auto-pr-jira.yml
DEFAULT_TARGET_BRANCH=main
```

---

## 💡 Tips for Chatting with ICA

1. **Be specific** - Describe exactly what each agent should do
2. **Mention data flow** - Explain how agents pass data to each other
3. **Include tools** - Mention GitHub API, Jira API, etc.
4. **Iterate** - Refine the YAML through conversation
5. **Test incrementally** - Start with 2-3 agents, then add more

---

## 🎯 Quick Start Command

**Copy and paste this into the chat box:**

```
Create a 6-agent orchestration for GitHub automation:

Agent 1 (Requirements Analyzer): Analyzes user requests, creates implementation plans with file lists
Agent 2 (Code Generator): Generates complete code files from plans
Agent 3 (GitHub Operations): Creates branches, commits code, pushes to GitHub
Agent 4 (Automation Orchestrator): Triggers GitHub Actions workflow "bob-auto-pr-jira.yml"
Agent 5 (Status Monitor): Monitors PR creation, Jira tickets, merge status
Agent 6 (User Communication): Sends friendly updates to users

Data flows sequentially: user_request → plan → code → branch → workflow → status → message

Use gpt-4 for agents 1, 2, 6 and gpt-3.5-turbo for agents 3, 4, 5
```

**Then click the blue arrow** →

---

## 📊 What to Do After YAML is Generated

1. **Review the YAML** in the right panel
2. **Click "Edit manually"** if you need to adjust
3. **Add detailed instructions** for each agent
4. **Configure tools** (GitHub API, Jira API)
5. **Set environment variables**
6. **Test the orchestration**
7. **Deploy to production**

---

## 🚀 Next Steps After Creation

Once the YAML is generated and saved:

1. Go to **"Tools"** tab - Add GitHub and Jira integration tools
2. Go to **"Workflow"** tab - Verify agent connections
3. Go to **"Control Tower"** tab - Add environment variables
4. **Test** with a simple request like "Add a contact form"
5. **Monitor** the execution through all 6 agents
6. **Refine** based on results

---

## ❓ Common Questions

**Q: Can I edit the YAML directly?**
A: Yes! Click "edit manually" in the Generated YAML panel

**Q: How do I add more agents later?**
A: Chat with ICA again: "Add another agent that does X"

**Q: Can I test individual agents?**
A: Yes, in the Agents tab after creation

**Q: What if the YAML is wrong?**
A: Chat with ICA: "Modify agent X to do Y instead"

---

**Current Status:** Ready to chat with ICA  
**Next Action:** Type the agent description in the chat box  
**Expected Time:** 5-10 minutes to generate and refine  

---

*Start chatting with ICA now to create your agent orchestration! 🚀*