# PSToolboxAI Implementation Notes

## Overview

This document describes the implementation of the Sourcegraph Toolbox pattern as a PowerShell module integrated with PSAI.

## Issue Reference

- **Issue**: #108 - Implement Sourcegraph Toolbox PowerShell port into PSAI
- **PR**: #111
- **Branch**: `copilot/implement-sourcegraph-toolbox-port`

## Implementation Summary

Successfully implemented a Sourcegraph Toolbox-style toolbox system for PSAI that:
1. Discovers tools from configurable directories
2. Dynamically loads and registers tools
3. Integrates seamlessly with PSAI's agent system
4. Follows the established patterns from existing PSAI tools

## Key Design Decisions

### 1. Module Structure

```
PSToolboxAI/
├── PSToolboxAI.psd1              # Module manifest
├── PSToolboxAI.psm1              # Module loader
├── Public/
│   └── PSToolboxAI.ps1           # Main functions
├── Private/                      # (Reserved for future use)
├── Examples/                     # Usage examples
│   ├── 01-BasicToolbox.ps1
│   └── 02-ConvenienceFunction.ps1
├── tmp/tools/                    # Default toolbox location
│   ├── filesystem/
│   ├── datetime/
│   └── text/
├── README.md                     # Documentation
└── test-toolbox.ps1              # Test script
```

### 2. Tool Discovery Pattern

**Environment Variable**: `$env:PSAI_TOOLBOX_PATH`
- Can specify multiple paths (`;` on Windows, `:` on Unix)
- If not set, uses default path: `spikes/PSToolboxAI/tmp/tools`

**Discovery Process**:
1. Scan toolbox directories for `.ps1` files
2. Dot-source each script to load functions
3. Call registration function (matches script basename)
4. Collect tool specifications from `Register-Tool`

### 3. Tool Definition Pattern

Each toolbox script follows this pattern:

```powershell
# Tool functions defined with Global scope
function Global:My-ToolFunction {
    # ... implementation ...
    return (ConvertTo-Json -Compress -InputObject @{ result = $result })
}

# Registration function (matches script filename)
function MyToolbox {
    $tools = @(
        Register-Tool -FunctionName My-ToolFunction
    )
    return $tools
}
```

**Key Points**:
- Tool functions use `Global:` scope to be accessible to `Register-Tool`
- Functions return JSON strings (required by OpenAI function calling)
- Registration function matches script basename
- Uses PSAI's `Register-Tool` for consistency

### 4. Integration with PSAI

The implementation integrates with PSAI's existing infrastructure:

- **Register-Tool**: Uses PSAI's tool registration function
- **New-Agent**: Tools work with standard `New-Agent -Tools` parameter
- **Get-AgentResponse**: Compatible with standard agent interactions
- **Invoke-InteractiveCLI**: Works with interactive agent sessions

## Implemented Toolboxes

### FileSystem Toolbox
Located: `tmp/tools/filesystem/FileSystemTools.ps1`

**Tools**:
1. `Get-DirectoryListing` - List files and directories
2. `Read-FileContent` - Read file contents
3. `Test-FileExists` - Check file/directory existence

### DateTime Toolbox
Located: `tmp/tools/datetime/DateTimeTools.ps1`

**Tools**:
1. `Get-CurrentDateTime` - Get current time in various formats
2. `Format-DateTime` - Format date/time strings
3. `Get-DateDifference` - Calculate time differences

### Text Toolbox
Located: `tmp/tools/text/TextTools.ps1`

**Tools**:
1. `Get-TextStatistics` - Analyze text (word count, etc.)
2. `Convert-TextCase` - Convert case (upper, lower, title, sentence)
3. `Search-TextPattern` - Search text using regex

## Public Functions

### Get-PSAIToolboxPath
Retrieves toolbox directories from environment variable or returns default path.

```powershell
$paths = Get-PSAIToolboxPath
```

### Get-PSAIToolbox
Discovers and loads toolbox tools from specified paths.

```powershell
# Use default paths
$tools = Get-PSAIToolbox

# Use specific path
$tools = Get-PSAIToolbox -Path "./my-tools"
```

### New-PSAIToolboxAgent
Convenience function that combines tool discovery and agent creation.

```powershell
$agent = New-PSAIToolboxAgent `
    -Instructions "You are a helpful assistant" `
    -ShowToolCalls
```

## Usage Examples

### Basic Usage
```powershell
Import-Module PSAI
Import-Module ./spikes/PSToolboxAI/PSToolboxAI.psd1

# Discover tools
$tools = Get-PSAIToolbox

# Create agent
$agent = New-Agent -Tools $tools -ShowToolCalls

# Use agent
$agent | Get-AgentResponse "What is the current date?"
```

### With Environment Variable
```powershell
# Set custom toolbox paths
$env:PSAI_TOOLBOX_PATH = "C:\MyTools;C:\SharedTools"

# Tools will be discovered from these paths
$agent = New-PSAIToolboxAgent -ShowToolCalls
```

### Convenience Function
```powershell
# One-step agent creation with auto-discovery
$agent = New-PSAIToolboxAgent `
    -Instructions "You are a file management assistant" `
    -Name "FileBot" `
    -ShowToolCalls

$agent | Invoke-InteractiveCLI
```

## Testing

A comprehensive test script (`test-toolbox.ps1`) validates:

1. ✓ Module loading (PSAI and PSToolboxAI)
2. ✓ Toolbox path discovery
3. ✓ Tool discovery (9 tools)
4. ✓ Function availability (all 9 functions)
5. ✓ Function execution (DateTime, Text, FileSystem)
6. ✓ Agent creation with tools

All tests pass successfully.

## Technical Challenges & Solutions

### Challenge 1: Function Scope
**Problem**: Tool functions weren't visible to `Register-Tool` when called.

**Solution**: Defined tool functions with `Global:` scope, following the pattern used in `TavilyTool.psm1`.

### Challenge 2: Duplicate Registration
**Problem**: Tools were being registered twice (18 instead of 9).

**Solution**: Removed `return FunctionName` at end of scripts, which was outputting the function name as a string when dot-sourcing.

### Challenge 3: Submodule Issue
**Problem**: `spikes/PSToolboxAI` was initially a gitlink (submodule reference).

**Solution**: Removed the gitlink with `git rm --cached` and added files as regular repository content.

## Comparison with Sourcegraph Toolbox

### Similarities
- Environment-based discovery
- Dynamic tool loading
- JSON-based tool specifications
- Integration with agent frameworks

### PowerShell-Specific Adaptations
- Uses PowerShell module system
- Leverages PSAI's existing `Register-Tool` infrastructure
- Follows PowerShell naming conventions (Verb-Noun)
- Uses PowerShell's comment-based help
- Returns JSON strings for LLM compatibility

## Future Enhancements

Potential improvements identified:

1. **Tool Caching**: Cache discovered tools for performance
2. **Tool Versioning**: Support versioned toolboxes
3. **Remote Toolboxes**: Load toolboxes from URLs
4. **Tool Validation**: Validate tool specifications
5. **Tool Dependencies**: Handle inter-tool dependencies
6. **Auto-documentation**: Generate docs from tool metadata
7. **Tool Marketplace**: Community toolbox sharing

## References

- [Sourcegraph Toolboxes Manual](https://ampcode.com/manual#toolboxes)
- [Sourcegraph Toolboxes Reference](https://ampcode.com/manual/appendix#toolboxes-reference)
- [PSAI Repository](https://github.com/dfinke/PSAI)
- Issue #108: Implement Sourcegraph Toolbox PowerShell port into PSAI
- Issue #106: Analysis of Anthropic Claude Skills and Sourcegraph Toolbox approach

## Conclusion

The implementation successfully demonstrates the Sourcegraph Toolbox pattern in PowerShell, integrated with PSAI's agent system. The spike provides:

- A working proof of concept
- Clear patterns for creating new toolboxes
- Comprehensive documentation
- Example toolboxes with 9 useful tools
- A solid foundation for future enhancements

The implementation is ready for review and can serve as the basis for either:
1. Integration into the main PSAI module (recommended)
2. Publication as a separate companion module
3. Further iteration based on user feedback
