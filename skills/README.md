# PSAI Skills

This directory contains PSAI Skills, which implement the Anthropic Claude Skills pattern for PowerShell. Skills are modular capabilities that extend AI agent functionality with domain-specific expertise.

## What are Skills?

Skills are reusable, filesystem-based resources that provide AI agents with:
- Domain-specific workflows and best practices
- On-demand loading (progressive disclosure)
- Structured guidance through YAML frontmatter and markdown content

## Skills Architecture

The PSAI Skills implementation follows a three-level loading pattern:

### Level 1: Metadata (always loaded)
The YAML frontmatter in `SKILL.md` files provides discovery information:
```yaml
---
name: Skill Name
description: What this skill does and when to use it
---
```

### Level 2: Instructions (loaded on-demand)
The main body of `SKILL.md` contains procedural knowledge:
- Workflows and step-by-step guidance
- Code examples and best practices
- Usage patterns and tips

### Level 3: Resources (loaded as needed)
Additional files can be included:
- Related markdown files for specialized guidance
- Scripts and utilities
- Reference materials and examples

## Using Skills with PSAI

### Discovering Skills

Use `Get-PSAISkillFrontmatter` to scan for available skills:

```powershell
# Get all skills as JSON
Get-PSAISkillFrontmatter -SkillsRoot "./skills"

# Get skills as PowerShell objects
Get-PSAISkillFrontmatter -SkillsRoot "./skills" -AsPSCustomObject
```

### Reading Skill Content

Use `Read-PSAISkill` to load full skill instructions:

```powershell
$skills = Get-PSAISkillFrontmatter -SkillsRoot "./skills" -AsPSCustomObject
$readSkill = $skills | Where-Object { $_.name -eq "Read File" }
Read-PSAISkill -Fullname $readSkill.fullname
```

### Creating an Agent with Skills

Integrate skills into an AI agent:

```powershell
$instructions = @"
You are a PowerShell Skills AI Assistant. 

When a user provides a request, analyze it to determine which skills are relevant.

**ONLY USE** Read-PSAISkill to read SKILL.md files. 
**DO NOT USE** Read-PSAISkill to read any other type of file. 

Use code blocks in the SKILL.md file as examples to form your response. 

You have access to these skills:
$(Get-PSAISkillFrontmatter -SkillsRoot "./skills" -Compress)
"@

$tools = @(
    'Invoke-Expression'
    'Read-PSAISkill'
)

$agent = New-Agent -Tools $tools -Instructions $instructions -Name 'PSSkillsAgent'

# Use the agent
$agent | Get-AgentResponse "How do I read a file in PowerShell?"
```

## Skill Structure

Each skill should be organized as a directory containing at minimum a `SKILL.md` file:

```
skills/
├── public/
│   ├── read-file/
│   │   └── SKILL.md
│   ├── write-file/
│   │   └── SKILL.md
│   └── process-management/
│       └── SKILL.md
└── README.md
```

### SKILL.md Format

Every skill requires YAML frontmatter with these fields:

```markdown
---
name: Your Skill Name (max 64 characters)
description: Brief description of what this skill does and when to use it (max 1024 characters)
---

# Your Skill Name

## Quick start
[Step-by-step guidance]

## Examples
[Concrete examples with code blocks]

## Best practices
[Tips and recommendations]
```

## Creating Custom Skills

1. Create a new directory under `skills/public/` (or your custom location)
2. Create a `SKILL.md` file with proper frontmatter
3. Write clear, actionable instructions with code examples
4. Test with `Get-PSAISkillFrontmatter` and `Read-PSAISkill`
5. Integrate into your agent's instructions

## Best Practices

- **Clear descriptions**: Make skill descriptions specific about when to use them
- **Actionable content**: Provide step-by-step guidance and working examples
- **Code examples**: Include PowerShell code blocks that can be used directly
- **Scoped skills**: Keep each skill focused on a specific capability
- **Consistent structure**: Follow the Quick start → Examples → Best practices pattern

## References

- Anthropic Claude Skills documentation: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview
- GitHub repository: https://github.com/anthropics/skills
- PSAI documentation: https://github.com/dfinke/PSAI/wiki
