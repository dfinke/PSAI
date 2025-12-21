# Arc - PowerShell AI Skills and Tools

Arc is a PowerShell module that provides AI-powered skills and tools execution with built-in permission management.

## Overview

Arc supports two modes:
- **Skill Mode**: Uses predefined skills stored in SKILL.md files
- **Tool Mode**: Loads and executes tools from a toolbox directory

## Permission Management

Arc implements a security model to control what PowerShell commands can be executed by AI agents.

### Default Permissions

The following commands are always allowed without user confirmation:

- `Get-Content:*` - Read file contents (any parameters)
- `Get-ChildItem:*` - List directory contents (any parameters)
- `Select-String:*` - Search text in files (any parameters)

### Skill-Based Permissions

Skills can define additional allowed tools in their frontmatter:

```markdown
---
name: My Skill
description: Description of the skill
allowed-tools: Get-Date, Write-Host:*, Invoke-WebRequest -Uri *
---
```

When a skill is loaded, its `allowed-tools` are added to temporary permissions for that session.

### Permission Checking

- **Prefix Matching**: Patterns ending with `:*` match any command starting with that prefix (case-insensitive)
- **Exact Matching**: Other patterns require exact command matches (case-insensitive)

### Permission Prompts

If AI tries to execute code not covered by permissions, you'll see:

```
The Agent wants to run the following code:
[code block]

Do you want to execute this code? (y/n)
```

Type `y` or `yes` to allow execution, anything else cancels.

## Usage

### Skill Mode

```powershell
# Interactive mode
Arc

# With prompt
Arc -Prompt "Read the sales.csv file and analyze the data"

# Specify model
Arc -Prompt "List files" -Model "gpt-4"
```

### Tool Mode

```powershell
# Set toolbox path
$env:POWERSHELL_TOOLBOX_AI = "C:\path\to\toolbox"

# Use tool mode
Arc -Type tool -Prompt "Execute some tool"
```

## Skills

Skills are defined in `./skills/` subdirectories with `SKILL.md` files containing:

- YAML frontmatter with name, description, and allowed-tools
- Markdown documentation
- PowerShell code blocks that can be executed

### Creating a Skill

1. Create a directory under `./skills/`
2. Add a `SKILL.md` file with frontmatter and code blocks
3. Define `allowed-tools` for any additional permissions needed

Example SKILL.md:
```markdown
---
name: File Operations
description: Basic file operations
allowed-tools: Remove-Item:*, Copy-Item:*
---

# File Operations

## Delete File
```powershell
Remove-Item -Path <path>
```

## Copy File
```powershell
Copy-Item -Path <source> -Destination <destination>
```
```

## Security Notes

- Permissions are temporary and reset between skill invocations
- Always review permission prompts carefully
- Only allow execution of code you understand and trust
- Skills should specify minimal required permissions in `allowed-tools`</content>
<parameter name="filePath">d:\mygit\PSAI\Public\Arc\README.md