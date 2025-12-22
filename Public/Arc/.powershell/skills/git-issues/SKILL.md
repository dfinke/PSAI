---
name: Git Issues
description: Manage GitHub issues using PowerShell
---

# Git Issues Skill
This skill allows you to manage GitHub issues using PowerShell commands. You can create, update, close, and list issues in a specified GitHub repository.

## Commands

### Get Issue
Retrieve a list of issues from a GitHub repository.

```powershell
gh issue list --repo <owner>/<repo>
```

### Set Copilot
Assign the GitHub Copilot to a specific issue.

```powershell
gh issue edit <IssueNumber> --repo <owner>/<repo> --add-assignee "@copilot"
```

### Create Issue
Create a new issue in a GitHub repository.

```powershell
gh issue create --repo <owner>/<repo> --title "<IssueTitle>" --body "<IssueBody>"
```