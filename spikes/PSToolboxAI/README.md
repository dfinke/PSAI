# PSToolboxAI - Sourcegraph Toolbox for PSAI

This is a spike implementation of Sourcegraph Toolbox pattern integration with PSAI, enabling dynamic discovery and loading of tool collections for AI agents.

## Overview

PSToolboxAI brings the Sourcegraph Toolbox concept to PowerShell AI agents. Toolboxes are collections of related tools that can be discovered automatically and loaded into agents, providing them with capabilities like file system operations, date/time calculations, text processing, and more.

## Key Concepts

### Sourcegraph Toolbox Pattern

The Sourcegraph Toolbox pattern involves:
1. **Environment-based discovery**: Tools are discovered via `$env:PSAI_TOOLBOX_PATH`
2. **JSON-based registration**: Tools return JSON specifications compatible with OpenAI function calling
3. **Dynamic loading**: Tools are loaded at runtime and registered via `Register-Tool`
4. **Agent integration**: Tools are integrated via `New-Agent -Tools`

### How It Works

1. **Discovery**: PSToolboxAI scans directories specified in `$env:PSAI_TOOLBOX_PATH` (or a default path)
2. **Loading**: Each `.ps1` file in the toolbox directories is loaded
3. **Registration**: Tool functions are registered using PSAI's `Register-Tool` function
4. **Integration**: The registered tools are passed to `New-Agent` for use by the AI agent

## Installation

Since this is a spike in the PSAI repository:

```powershell
# Clone or navigate to PSAI repository
cd /path/to/PSAI

# Import the module
Import-Module ./spikes/PSToolboxAI/PSToolboxAI.psd1
```

## Usage

### Basic Usage - Auto-discovery

Use the default toolbox path (no environment variable needed):

```powershell
# Import PSAI first
Import-Module PSAI

# Import the toolbox module
Import-Module ./spikes/PSToolboxAI/PSToolboxAI.psd1

# Discover and load all toolbox tools
$tools = Get-PSAIToolbox

# Create an agent with the tools
$agent = New-Agent -Tools $tools -ShowToolCalls

# Use the agent
$agent | Get-AgentResponse "List files in the current directory"
$agent | Get-AgentResponse "What is the current date and time?"
$agent | Get-AgentResponse "Count the words in this text: 'Hello world from PowerShell AI'"
```

### Using Environment Variable

Configure custom toolbox paths:

```powershell
# Set the toolbox path (can be multiple paths separated by ; on Windows or : on Unix)
$env:PSAI_TOOLBOX_PATH = "C:\MyTools;C:\SharedTools"

# Or on Unix/Linux:
$env:PSAI_TOOLBOX_PATH = "/home/user/mytools:/opt/sharedtools"

# Now discover tools from these paths
$tools = Get-PSAIToolbox

$agent = New-Agent -Tools $tools
```

### Convenience Function

Use the convenience function to create an agent with toolbox tools in one step:

```powershell
# Creates an agent with auto-discovered tools
$agent = New-PSAIToolboxAgent -Instructions "You are a helpful file management assistant" -ShowToolCalls

# Use it interactively
$agent | Invoke-InteractiveCLI
```

### Selective Loading

Load tools from a specific path:

```powershell
# Load only filesystem tools
$fsTools = Get-PSAIToolbox -Path "./spikes/PSToolboxAI/tmp/tools/filesystem"

$agent = New-Agent -Tools $fsTools -Name "FileAgent"
```

## Included Toolboxes

### FileSystem Toolbox
Located in: `tmp/tools/filesystem/`

Tools:
- **Get-DirectoryListing**: List files and directories
- **Read-FileContent**: Read file contents
- **Test-FileExists**: Check if a file or directory exists

### DateTime Toolbox
Located in: `tmp/tools/datetime/`

Tools:
- **Get-CurrentDateTime**: Get current date/time in various formats
- **Format-DateTime**: Format date/time strings
- **Get-DateDifference**: Calculate time differences

### Text Toolbox
Located in: `tmp/tools/text/`

Tools:
- **Get-TextStatistics**: Analyze text (word count, character count, etc.)
- **Convert-TextCase**: Convert text case (upper, lower, title, sentence)
- **Search-TextPattern**: Search text using regex patterns

## Creating Your Own Toolbox

1. **Create a directory** for your toolbox under `tmp/tools/` (or your custom path)
2. **Create a PowerShell script** (e.g., `MyTools.ps1`) with this structure:

```powershell
# Main registration function (matches filename)
function MyTools {
    [CmdletBinding()]
    param()
    
    Write-Verbose "Registering MyTools"
    
    # Register your tool functions
    $tools = @(
        Register-Tool -FunctionName My-ToolFunction
    )
    
    return $tools
}

# Your actual tool function
function My-ToolFunction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Input
    )
    
    # Do work here
    $result = @{
        input = $Input
        output = "Processed: $Input"
    }
    
    # Return JSON
    return ($result | ConvertTo-Json -Compress)
}

# Return the registration function
return MyTools
```

3. **Tool functions should**:
   - Accept parameters that are clearly typed
   - Return JSON strings (use `ConvertTo-Json`)
   - Handle errors gracefully
   - Provide good descriptions in comment-based help

## Architecture

```
PSToolboxAI/
├── PSToolboxAI.psd1           # Module manifest
├── PSToolboxAI.psm1           # Module loader
├── Public/
│   └── PSToolboxAI.ps1        # Main functions (Get-PSAIToolbox, etc.)
└── tmp/
    └── tools/                 # Default toolbox location
        ├── filesystem/
        │   └── FileSystemTools.ps1
        ├── datetime/
        │   └── DateTimeTools.ps1
        └── text/
            └── TextTools.ps1
```

## Environment Variables

- **`$env:PSAI_TOOLBOX_PATH`**: Path(s) to toolbox directories (optional)
  - Multiple paths can be specified (`;` on Windows, `:` on Unix)
  - If not set, uses default path: `spikes/PSToolboxAI/tmp/tools`

- **`$env:PSAI_ENABLE_TOOLBOX`**: Enable/disable toolbox loading (optional)
  - Set to `$false` to disable toolbox loading
  - Useful for testing or debugging

## Examples

### Example 1: File Management Agent

```powershell
Import-Module PSAI
Import-Module ./spikes/PSToolboxAI/PSToolboxAI.psd1

$agent = New-PSAIToolboxAgent `
    -Instructions "You are a file management assistant. Help users with file operations." `
    -Name "FileBot" `
    -ShowToolCalls

$agent | Get-AgentResponse "What files are in the current directory?"
$agent | Get-AgentResponse "Read the content of README.md"
```

### Example 2: Date Calculator

```powershell
$agent = New-PSAIToolboxAgent -Name "DateBot"

$agent | Get-AgentResponse "How many days until December 31, 2025?"
$agent | Get-AgentResponse "What day of the week is Christmas 2025?"
```

### Example 3: Text Analyzer

```powershell
$agent = New-PSAIToolboxAgent -Name "TextBot"

$text = "The quick brown fox jumps over the lazy dog."
$agent | Get-AgentResponse "Analyze this text: $text"
$agent | Get-AgentResponse "Convert 'hello world' to title case"
```

## Integration with PSAI

PSToolboxAI integrates seamlessly with PSAI's existing infrastructure:

- Uses `Register-Tool` for tool registration
- Compatible with `New-Agent` function
- Works with `Get-AgentResponse` and `Invoke-InteractiveCLI`
- Follows PSAI's tool specification format

## Reference Links

- [Sourcegraph Toolboxes Manual](https://ampcode.com/manual#toolboxes)
- [Sourcegraph Toolboxes Reference](https://ampcode.com/manual/appendix#toolboxes-reference)
- [PSAI Repository](https://github.com/dfinke/PSAI)

## Future Enhancements

Potential improvements for this spike:

1. **Tool metadata**: Add more descriptive metadata to tools
2. **Tool versioning**: Support versioned toolboxes
3. **Tool dependencies**: Handle dependencies between tools
4. **Tool discovery optimization**: Cache discovered tools
5. **Remote toolboxes**: Load toolboxes from remote URLs
6. **Tool validation**: Validate tool specifications before registration
7. **Tool documentation**: Auto-generate documentation from tools

## Contributing

This is a spike/proof-of-concept. To contribute:

1. Add new toolboxes under `tmp/tools/`
2. Follow the existing pattern
3. Test with PSAI agents
4. Document your toolbox in this README

## License

This code is part of the PSAI project and follows the same license (MIT).
