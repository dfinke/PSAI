# Analysis: Anthropic Claude Skills and Sourcegraph Toolbox Integration

## Executive Summary

This document provides a comprehensive analysis of integrating Anthropic Claude Skills and Sourcegraph Toolbox capabilities into the PSAI PowerShell module ecosystem. Based on the proof-of-concept work completed and research into both platforms, this analysis presents implementation options with detailed plans for each approach.

## Table of Contents

1. [Current PSAI Architecture](#current-psai-architecture)
2. [Anthropic Claude Skills Overview](#anthropic-claude-skills-overview)
3. [Sourcegraph Toolbox Overview](#sourcegraph-toolbox-overview)
4. [Comparative Analysis](#comparative-analysis)
5. [Implementation Options](#implementation-options)
6. [Detailed Implementation Plans](#detailed-implementation-plans)
7. [Decision Matrix](#decision-matrix)
8. [Recommendations](#recommendations)

---

## Current PSAI Architecture

### Existing Capabilities

PSAI currently provides:

- **Agent Framework**: `New-Agent` function creates autonomous agents with custom instructions
- **Tool Registration**: `Register-Tool` function converts PowerShell functions to OpenAI tool specifications
- **Pre-built Tools**: Modular tools in `Public/Tools/` directory:
  - CalculatorTool.psm1
  - TavilyTool.psm1 (web search)
  - StockTickerTool.psm1
  - YouTubeTool.psm1
- **Interactive CLI**: Rich terminal-based interaction with agents
- **Message Management**: Conversation history and context management

### Key Design Patterns

1. **Tool as Module**: Each tool is a separate .psm1 file exporting a `New-*Tool` function
2. **Function-based Tools**: Tools wrap PowerShell functions registered via `Register-Tool`
3. **Environment Variable Configuration**: API keys stored in environment variables (e.g., `$env:TAVILY_API_KEY`)
4. **Agent-centric Design**: Agents orchestrate tools through the LLM

---

## Anthropic Claude Skills Overview

### What Are Claude Skills?

Based on the documentation at https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview and the GitHub repository at https://github.com/anthropics/skills:

**Claude Skills** are markdown-based, reusable capabilities that follow a standardized structure:

1. **Frontmatter Metadata**: YAML frontmatter defines the skill's metadata
   - Skill name and description
   - Categories and tags
   - Input/output specifications
   - Dependencies

2. **Implementation Instructions**: Markdown body contains detailed instructions for Claude
   - Step-by-step procedures
   - Best practices
   - Examples and edge cases

3. **Discovery Mechanism**: Skills are discovered through:
   - Directory scanning for `.md` files
   - Parsing frontmatter to build a skill catalog
   - Selective loading based on task requirements

### Key Benefits

- **Declarative**: Skills are defined in markdown, making them human-readable and easy to maintain
- **Composable**: Skills can reference and build upon other skills
- **Context-efficient**: Only relevant skills loaded into context when needed
- **Versioned**: Markdown files can be version-controlled alongside code
- **LLM-friendly**: Natural language instructions optimized for AI comprehension

### PoC Findings

From the issue description, the PoC demonstrated:
- Successful directory listing to discover `.md` skill files
- Frontmatter parsing using PowerShell
- Integration with `New-Agent -Instructions` to inject skill content
- AI model successfully interpreting and executing skills
- Dynamic skill loading based on AI agent requests

---

## Sourcegraph Toolbox Overview

### What Are Sourcegraph Toolboxes?

Based on the documentation at https://ampcode.com/manual#toolboxes and https://ampcode.com/manual/appendix#toolboxes-reference:

**Sourcegraph Toolboxes** are collections of tools that can be dynamically discovered and registered:

1. **Environment-based Discovery**: Tools are discovered via environment variable
   - `$env:TOOLBOX_PATH` or similar environment variable
   - Points to directory containing tool definitions

2. **JSON Tool Definitions**: Each tool defined in a structured JSON format
   - Tool name and description
   - Parameter schemas
   - Execution commands

3. **Dynamic Registration**: Tools registered at runtime based on environment
   - Check for environment variable
   - Parse tool definitions
   - Register with `New-Agent -Tools`

### Key Benefits

- **Extensibility**: New tools added without modifying core code
- **Environment-specific**: Different toolboxes for different environments
- **Standard Format**: JSON schemas ensure consistent tool definitions
- **Runtime Discovery**: Tools discovered and registered dynamically

### PoC Findings

From the issue description, the PoC demonstrated:
- Environment variable detection for toolbox path
- JSON parsing of tool definitions
- Successful registration via `Register-Tool`
- Integration with `New-Agent -Tools`
- Seamless tool invocation by AI agents

---

## Comparative Analysis

### Similarities

Both approaches:
- Enable extensibility without core code changes
- Support dynamic discovery and registration
- Use declarative definitions (markdown vs JSON)
- Work successfully with existing PSAI architecture
- Provide environment-based configuration

### Differences

| Aspect | Claude Skills | Sourcegraph Toolbox |
|--------|---------------|---------------------|
| **Format** | Markdown with YAML frontmatter | JSON |
| **Primary Use** | Instructions and workflows | Tool/function definitions |
| **Integration Point** | `New-Agent -Instructions` | `New-Agent -Tools` |
| **Content Type** | Natural language procedures | Structured tool schemas |
| **Discovery** | Directory scanning for `.md` | Environment variable path |
| **Context** | Loaded as system instructions | Registered as callable tools |
| **Granularity** | High-level workflows | Low-level functions |

### Complementary Nature

**Claude Skills** and **Sourcegraph Toolbox** are complementary rather than competing:

- **Skills** provide high-level guidance (the "what" and "how")
- **Toolboxes** provide low-level capabilities (the "tools to use")
- Skills can reference tools: "Use the weather tool from the toolbox"
- Tools can enable skills: A skill about data analysis requires data retrieval tools

---

## Implementation Options

### Option 1: Integrate Both into PSAI Core Module

**Description**: Add Skills and Toolbox capabilities as core features of PSAI

**Structure**:
```
PSAI/
├── Public/
│   ├── Skills/
│   │   ├── Get-ClaudeSkill.ps1
│   │   ├── Import-ClaudeSkill.ps1
│   │   └── Register-SkillDirectory.ps1
│   ├── Toolbox/
│   │   ├── Get-ToolboxPath.ps1
│   │   ├── Import-Toolbox.ps1
│   │   └── Register-ToolboxTools.ps1
│   └── New-Agent.ps1 (enhanced)
├── Skills/ (default skills directory)
└── Toolboxes/ (default toolboxes directory)
```

**Pros**:
- Unified experience for users
- Single module to install and update
- Easier to ensure compatibility
- Centralized documentation
- Skills and Toolboxes work together seamlessly

**Cons**:
- Increases PSAI module complexity
- Larger module footprint
- Breaking changes affect all users
- May bundle features not all users need

### Option 2: Separate Companion Modules

**Description**: Create separate modules that extend PSAI

**Structure**:
```
PSAI/ (core module - unchanged)

PSAISkills/ (new module)
├── Public/
│   ├── Get-ClaudeSkill.ps1
│   ├── Import-ClaudeSkill.ps1
│   └── New-AgentWithSkills.ps1
└── Skills/ (default skills)

PSAIToolbox/ (new module)
├── Public/
│   ├── Get-ToolboxPath.ps1
│   ├── Import-Toolbox.ps1
│   └── New-AgentWithToolbox.ps1
└── Toolboxes/ (default toolboxes)
```

**Pros**:
- Modular architecture - install only what you need
- Independent versioning and release cycles
- PSAI remains focused on core functionality
- Easier to maintain and test separately
- Community can contribute to specific modules

**Cons**:
- More modules to install and manage
- Potential version compatibility issues
- Documentation split across modules
- May require coordination for breaking changes

### Option 3: Hybrid Approach

**Description**: Core infrastructure in PSAI, content in separate modules

**Structure**:
```
PSAI/ (core with infrastructure)
├── Public/
│   ├── Skills/
│   │   └── Import-SkillProvider.ps1
│   ├── Toolbox/
│   │   └── Import-ToolboxProvider.ps1
│   └── New-Agent.ps1 (enhanced with provider support)

PSAI.Skills.Anthropic/ (skill provider)
├── Skills/
└── Register-AnthropicSkillProvider.ps1

PSAI.Toolbox.Sourcegraph/ (toolbox provider)
├── Toolboxes/
└── Register-SourcegraphToolboxProvider.ps1
```

**Pros**:
- Core functionality in PSAI for seamless integration
- Content modules can be swapped/extended
- Supports multiple skill/toolbox providers
- Clean separation of concerns
- Extensible architecture

**Cons**:
- Most complex implementation
- Requires provider abstraction layer
- May be over-engineered for current needs

---

## Detailed Implementation Plans

### Plan A: Integrate into PSAI Core Module

#### Phase 1: Skills Infrastructure (Week 1-2)

**New Functions**:

1. **`Get-ClaudeSkill`**
   ```powershell
   function Get-ClaudeSkill {
       param(
           [string]$SkillsPath = "$PSScriptRoot/../Skills",
           [string]$Category,
           [string[]]$Tags
       )
       # Scan directory for .md files
       # Parse YAML frontmatter
       # Return skill objects with metadata
   }
   ```

2. **`Import-ClaudeSkill`**
   ```powershell
   function Import-ClaudeSkill {
       param(
           [string]$SkillPath,
           [string]$SkillName
       )
       # Load skill content
       # Parse frontmatter and body
       # Return formatted instructions
   }
   ```

3. **`Register-SkillDirectory`**
   ```powershell
   function Register-SkillDirectory {
       param([string]$Path)
       # Register path for skill discovery
       # Update module-level configuration
   }
   ```

**Enhanced `New-Agent`**:
```powershell
function New-Agent {
    param(
        $Instructions,
        $Tools,
        [string[]]$Skills,  # NEW: Skill names to load
        [string]$SkillsPath,  # NEW: Custom skills directory
        $LLM,
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
    
    # Existing code...
    
    # NEW: Load and inject skills
    if ($Skills) {
        foreach ($skillName in $Skills) {
            $skill = Import-ClaudeSkill -SkillName $skillName -SkillsPath $SkillsPath
            $script:messages += @(New-ChatRequestSystemMessage $skill.Content)
        }
    }
}
```

**Default Skills Directory**:
- Create `PSAI/Skills/` with example skills
- Example: `code-review.md`, `documentation.md`, `testing.md`

**Tests**:
- Unit tests for skill parsing
- Integration tests for agent with skills
- Test frontmatter edge cases

#### Phase 2: Toolbox Infrastructure (Week 3-4)

**New Functions**:

1. **`Get-ToolboxPath`**
   ```powershell
   function Get-ToolboxPath {
       param()
       # Check $env:PSAI_TOOLBOX_PATH
       # Return path or default path
   }
   ```

2. **`Import-Toolbox`**
   ```powershell
   function Import-Toolbox {
       param(
           [string]$ToolboxPath,
           [string]$ToolboxName
       )
       # Load JSON tool definitions
       # Parse and validate schemas
       # Return tool objects
   }
   ```

3. **`Register-ToolboxTools`**
   ```powershell
   function Register-ToolboxTools {
       param([string]$ToolboxPath)
       # Import all tools from toolbox
       # Register with Register-Tool
       # Return tool array
   }
   ```

**Enhanced `New-Agent`**:
```powershell
function New-Agent {
    param(
        $Instructions,
        $Tools,
        [string[]]$Skills,
        [string]$SkillsPath,
        [string]$ToolboxPath,  # NEW: Toolbox directory
        [Switch]$AutoLoadToolbox,  # NEW: Auto-load from environment
        $LLM,
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
    
    # Existing code...
    
    # NEW: Load toolbox tools
    if ($AutoLoadToolbox -or $ToolboxPath) {
        $tbPath = $ToolboxPath ?? (Get-ToolboxPath)
        if (Test-Path $tbPath) {
            $toolboxTools = Register-ToolboxTools -ToolboxPath $tbPath
            $Tools = @($Tools) + @($toolboxTools)
        }
    }
}
```

**Default Toolboxes**:
- Create `PSAI/Toolboxes/` with example toolboxes
- Example: `filesystem.json`, `networking.json`

**Tests**:
- Unit tests for toolbox parsing
- Integration tests for agent with toolbox
- Test JSON schema validation

#### Phase 3: Documentation and Examples (Week 5)

**Documentation**:
- Add Skills section to README.md
- Add Toolbox section to README.md
- Create `docs/SKILLS_GUIDE.md`
- Create `docs/TOOLBOX_GUIDE.md`
- Update wiki with new features

**Examples**:
- `examples/skills/01-basic-skill.ps1`
- `examples/skills/02-skill-with-tools.ps1`
- `examples/toolbox/01-custom-toolbox.ps1`
- `examples/toolbox/02-environment-toolbox.ps1`

**Sample Skill** (`Skills/code-review.md`):
```markdown
---
name: code-review
description: Comprehensive code review guidelines
category: development
tags: [code-quality, review, best-practices]
version: 1.0.0
---

# Code Review Skill

When performing code review, follow these steps:

1. **Readability**: Check for clear variable names and comments
2. **Functionality**: Verify code meets requirements
3. **Performance**: Identify potential bottlenecks
4. **Security**: Look for common vulnerabilities
5. **Testing**: Ensure adequate test coverage

## Best Practices
- Be constructive and specific
- Suggest improvements, not just problems
- Consider maintainability
```

**Sample Toolbox** (`Toolboxes/filesystem.json`):
```json
{
  "name": "filesystem",
  "description": "File system operations toolbox",
  "version": "1.0.0",
  "tools": [
    {
      "name": "Get-DirectoryListing",
      "description": "List files in a directory",
      "function": "Get-ChildItem",
      "parameters": {
        "Path": {
          "type": "string",
          "description": "Directory path",
          "required": true
        }
      }
    }
  ]
}
```

#### Phase 4: Release (Week 6)

- Update module version
- Update changelog
- Publish to PowerShell Gallery
- Announce on social media
- Create blog post/video

---

### Plan B: Separate Companion Modules

#### Phase 1: PSAISkills Module (Week 1-3)

**Module Structure**:
```
PSAISkills/
├── PSAISkills.psd1
├── PSAISkills.psm1
├── Public/
│   ├── Get-ClaudeSkill.ps1
│   ├── Import-ClaudeSkill.ps1
│   ├── Register-SkillDirectory.ps1
│   └── New-AgentWithSkills.ps1
├── Skills/ (bundled skills)
├── README.md
└── __tests__/
```

**Core Function** (`New-AgentWithSkills.ps1`):
```powershell
function New-AgentWithSkills {
    [CmdletBinding()]
    param(
        [string[]]$Skills,
        [string]$SkillsPath = "$PSScriptRoot/../Skills",
        $Instructions,
        $Tools,
        $LLM,
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
    
    # Load skills
    $skillInstructions = foreach ($skillName in $Skills) {
        $skill = Import-ClaudeSkill -SkillName $skillName -SkillsPath $SkillsPath
        $skill.Content
    }
    
    # Combine with custom instructions
    $allInstructions = @($skillInstructions) + @($Instructions) -join "`n`n"
    
    # Create agent with PSAI
    New-Agent @PSBoundParameters -Instructions $allInstructions
}
```

**Dependencies**:
- `RequiredModules = @('PSAI')`
- Version compatibility matrix

**Testing**:
- Pester tests for all functions
- Integration tests with PSAI
- Mock PSAI functions for isolated testing

**Documentation**:
- Comprehensive README
- Wiki pages
- Example scripts

#### Phase 2: PSAIToolbox Module (Week 4-6)

**Module Structure**:
```
PSAIToolbox/
├── PSAIToolbox.psd1
├── PSAIToolbox.psm1
├── Public/
│   ├── Get-ToolboxPath.ps1
│   ├── Import-Toolbox.ps1
│   ├── Register-ToolboxTools.ps1
│   └── New-AgentWithToolbox.ps1
├── Toolboxes/ (bundled toolboxes)
├── README.md
└── __tests__/
```

**Core Function** (`New-AgentWithToolbox.ps1`):
```powershell
function New-AgentWithToolbox {
    [CmdletBinding()]
    param(
        [string]$ToolboxPath,
        [Switch]$AutoLoadFromEnv,
        $Instructions,
        $Tools,
        $LLM,
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
    
    # Determine toolbox path
    if ($AutoLoadFromEnv) {
        $ToolboxPath = Get-ToolboxPath
    }
    
    # Load toolbox tools
    $toolboxTools = @()
    if (Test-Path $ToolboxPath) {
        $toolboxTools = Register-ToolboxTools -ToolboxPath $ToolboxPath
    }
    
    # Combine with custom tools
    $allTools = @($Tools) + @($toolboxTools)
    
    # Create agent with PSAI
    New-Agent @PSBoundParameters -Tools $allTools
}
```

**Dependencies**:
- `RequiredModules = @('PSAI')`
- Version compatibility matrix

**Testing**:
- Pester tests for all functions
- Integration tests with PSAI
- Mock PSAI functions for isolated testing

**Documentation**:
- Comprehensive README
- Wiki pages
- Example scripts

#### Phase 3: Repository Setup (Week 7)

**Repositories**:
- Create `dfinke/PSAISkills` repository
- Create `dfinke/PSAIToolbox` repository
- Or: Create monorepo with multiple modules

**CI/CD**:
- GitHub Actions for testing
- Automated publishing to PowerShell Gallery
- Version compatibility checks with PSAI

**Documentation**:
- Cross-reference between modules
- Unified examples repository
- Video tutorials

#### Phase 4: Release (Week 8)

- Publish both modules to PowerShell Gallery
- Update PSAI README with links to extensions
- Announce on social media
- Create blog post/video

---

### Plan C: Hybrid Approach (Provider Pattern)

#### Phase 1: PSAI Core Extensions (Week 1-2)

**Add Provider Infrastructure to PSAI**:

1. **`Import-SkillProvider.ps1`**:
```powershell
function Import-SkillProvider {
    param(
        [string]$ProviderName,
        [string]$ProviderPath
    )
    # Register skill provider
    # Add to $script:skillProviders
}
```

2. **`Import-ToolboxProvider.ps1`**:
```powershell
function Import-ToolboxProvider {
    param(
        [string]$ProviderName,
        [string]$ProviderPath
    )
    # Register toolbox provider
    # Add to $script:toolboxProviders
}
```

3. **Enhanced `New-Agent`**:
```powershell
function New-Agent {
    param(
        $Instructions,
        $Tools,
        [string[]]$SkillProviders,  # NEW
        [string[]]$ToolboxProviders,  # NEW
        $LLM,
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
    
    # Load skills from providers
    foreach ($provider in $SkillProviders) {
        $skills = & "$provider\Get-Skills"
        # Process skills...
    }
    
    # Load tools from providers
    foreach ($provider in $ToolboxProviders) {
        $tools = & "$provider\Get-Tools"
        # Process tools...
    }
}
```

#### Phase 2: Provider Modules (Week 3-6)

**PSAI.Skills.Anthropic Module**:
```powershell
# Register provider with PSAI
Register-SkillProvider -Name 'Anthropic' -Module 'PSAI.Skills.Anthropic'

function Get-Skills {
    # Return Anthropic-style skills
}
```

**PSAI.Toolbox.Sourcegraph Module**:
```powershell
# Register provider with PSAI
Register-ToolboxProvider -Name 'Sourcegraph' -Module 'PSAI.Toolbox.Sourcegraph'

function Get-Tools {
    # Return Sourcegraph-style tools
}
```

**Benefits**:
- Community can create additional providers
- Support for different skill/toolbox formats
- PSAI provides standard interface

#### Phase 3-4: Same as Plan B

---

## Decision Matrix

| Criteria | Plan A: Core Integration | Plan B: Separate Modules | Plan C: Hybrid |
|----------|-------------------------|-------------------------|----------------|
| **Time to Implement** | 6 weeks | 8 weeks | 8 weeks |
| **Complexity** | Medium | Low | High |
| **User Experience** | Excellent (unified) | Good (multiple installs) | Excellent |
| **Maintenance Burden** | High (in PSAI) | Low (distributed) | Medium |
| **Extensibility** | Low | High | Very High |
| **Breaking Change Risk** | High | Low | Low |
| **Module Size** | Large | Small (each) | Medium |
| **Version Management** | Simple (one version) | Complex (multiple) | Complex |
| **Community Contribution** | Harder | Easier | Easier |
| **Discoverability** | Excellent | Good | Good |

---

## Recommendations

### Primary Recommendation: Plan A (Core Integration)

**Rationale**:

1. **Proven Success**: PoC demonstrates Skills and Toolbox integrate naturally with existing PSAI architecture
2. **User Experience**: Single module installation provides best UX
3. **Synergy**: Skills and Toolboxes are complementary features that work better together
4. **Current Scale**: PSAI is already a comprehensive module; these additions fit the scope
5. **Market Position**: Positions PSAI as the complete PowerShell AI solution

**Mitigations for Cons**:

- **Complexity**: Use clear module organization and naming conventions
- **Size**: Features are lightweight (mostly metadata parsing)
- **Breaking Changes**: Use semantic versioning and deprecation notices
- **Optional Features**: Make Skills and Toolbox features opt-in

### Secondary Recommendation: Plan B (Separate Modules)

**When to Choose Plan B**:

- If community adoption of Skills/Toolbox is uncertain
- If you want to experiment without affecting PSAI core
- If you anticipate rapid iteration on these features
- If you want to enable community ownership of extensions

**Implementation Note**: Start with Plan B and migrate to Plan A if adoption is strong

### Plan C: Consider for Future

**Hybrid approach** is ideal for:
- Supporting multiple skill/toolbox formats beyond Anthropic and Sourcegraph
- Building a plugin ecosystem
- Long-term extensibility

**Recommendation**: Implement Plan A or B first, then evolve to Plan C if:
1. Community creates alternative skill/toolbox formats
2. Enterprise users need custom providers
3. Market demands vendor-agnostic approach

---

## Next Steps

### For Plan A Implementation:

1. **Review and Approve**: Stakeholder review of this analysis
2. **Create Feature Branch**: `feature/skills-and-toolbox`
3. **Phase 1 Implementation**: Start with Skills infrastructure
4. **Community Preview**: Share with community for feedback after Phase 1
5. **Iterate Based on Feedback**: Adjust before Phase 2
6. **Complete Implementation**: Phases 2-4
7. **Release**: Version 0.6.0 with Skills and Toolbox

### For Plan B Implementation:

1. **Review and Approve**: Stakeholder review of this analysis
2. **Repository Setup**: Create PSAISkills and PSAIToolbox repositories
3. **Parallel Development**: Both modules can be developed simultaneously
4. **Cross-module Testing**: Ensure compatibility with PSAI
5. **Coordinated Release**: Release both modules together
6. **Marketing**: Position as "PSAI Extension Ecosystem"

---

## Appendix A: Example Usage Scenarios

### Scenario 1: Code Review Agent with Skills and Tools

```powershell
# Plan A (Core Integration)
Import-Module PSAI

$agent = New-Agent `
    -Skills @('code-review', 'security-audit') `
    -Tools (Register-Tool 'Get-ChildItem', 'Get-Content') `
    -Name "CodeReviewer" `
    -AutoLoadToolbox

$agent | Get-AgentResponse "Review the PowerShell files in ./src"
```

```powershell
# Plan B (Separate Modules)
Import-Module PSAI
Import-Module PSAISkills
Import-Module PSAIToolbox

$agent = New-AgentWithSkills `
    -Skills @('code-review', 'security-audit') `
    | New-AgentWithToolbox -AutoLoadFromEnv `
    | Register-Tool 'Get-ChildItem', 'Get-Content'

$agent | Get-AgentResponse "Review the PowerShell files in ./src"
```

### Scenario 2: Documentation Agent

```powershell
# Plan A
$agent = New-Agent `
    -Skills @('documentation', 'markdown-formatting') `
    -Instructions "Focus on clarity and examples" `
    -Name "DocWriter"

$agent | Get-AgentResponse "Document the New-Agent function"
```

### Scenario 3: DevOps Agent with Custom Toolbox

```powershell
# Plan A
$env:PSAI_TOOLBOX_PATH = "C:\DevOpsToolbox"

$agent = New-Agent `
    -Skills @('deployment', 'monitoring') `
    -AutoLoadToolbox `
    -Name "DevOpsAgent"

$agent | Invoke-InteractiveCLI
```

---

## Appendix B: Skill Schema

### Recommended YAML Frontmatter Schema

```yaml
---
# Required fields
name: skill-name                    # Unique identifier
description: Brief description      # One-line description
version: 1.0.0                     # Semantic version

# Optional fields
category: category-name            # e.g., development, devops, data
tags: [tag1, tag2]                # Searchable tags
author: Author Name               # Skill creator
dependencies: [skill1, skill2]    # Other required skills
tools: [tool1, tool2]             # Required tools from toolboxes
llm_models: [gpt-4, claude-3]     # Compatible models
parameters:                        # Configurable parameters
  param1:
    type: string
    description: Parameter description
    default: default-value
---
```

---

## Appendix C: Toolbox Schema

### Recommended JSON Toolbox Schema

```json
{
  "$schema": "https://psai.dev/schemas/toolbox-v1.json",
  "name": "toolbox-name",
  "description": "Toolbox description",
  "version": "1.0.0",
  "author": "Author Name",
  "tools": [
    {
      "name": "tool-name",
      "description": "Tool description",
      "function": "PowerShell-Function-Name",
      "parameters": {
        "param1": {
          "type": "string|number|boolean|array|object",
          "description": "Parameter description",
          "required": true,
          "default": "default-value",
          "enum": ["option1", "option2"]
        }
      },
      "returns": {
        "type": "string|number|boolean|array|object",
        "description": "Return value description"
      }
    }
  ],
  "environment": {
    "variables": ["ENV_VAR_1", "ENV_VAR_2"],
    "modules": ["RequiredModule1", "RequiredModule2"]
  }
}
```

---

## Conclusion

Both Anthropic Claude Skills and Sourcegraph Toolbox offer valuable paradigms for extending AI agent capabilities in PowerShell. The proof-of-concept work demonstrates successful integration with PSAI's existing architecture.

**Primary Recommendation**: Integrate both capabilities into the PSAI core module (Plan A) for the best user experience and market positioning.

**Alternative Path**: Start with separate modules (Plan B) for lower risk and faster iteration, with potential migration to core in the future.

The decision ultimately depends on:
- Risk tolerance
- Development resources
- Community feedback
- Long-term vision for PSAI

Both paths are viable and can deliver significant value to PSAI users.
