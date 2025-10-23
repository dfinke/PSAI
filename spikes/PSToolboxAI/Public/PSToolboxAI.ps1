<#
.SYNOPSIS
PowerShell implementation of Sourcegraph Toolbox integration for PSAI.

.DESCRIPTION
This module provides functions to discover and load Sourcegraph-style toolboxes
for use with PSAI agents. Toolboxes are discovered via the $env:PSAI_TOOLBOX_PATH
environment variable and registered as tools that can be used with New-Agent.

.NOTES
Sourcegraph Toolbox pattern:
- Tools are defined as JSON specifications
- Tools are discovered via directory scanning
- Tools are registered using Register-Tool
- Tools are integrated via New-Agent -Tools

.LINK
https://ampcode.com/manual#toolboxes
https://ampcode.com/manual/appendix#toolboxes-reference
#>

<#
.SYNOPSIS
Gets the toolbox search paths from environment variable.

.DESCRIPTION
Retrieves toolbox directories from the PSAI_TOOLBOX_PATH environment variable.
If not set, returns a default path relative to this module.

.EXAMPLE
Get-PSAIToolboxPath
Returns an array of toolbox directory paths.

.OUTPUTS
System.String[]
#>
function Get-PSAIToolboxPath {
    [CmdletBinding()]
    param()
    
    $toolboxPaths = @()
    
    if ($env:PSAI_TOOLBOX_PATH) {
        # Split on semicolon (Windows) or colon (Unix)
        $separator = if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) { ';' } else { ':' }
        $toolboxPaths = $env:PSAI_TOOLBOX_PATH -split $separator | Where-Object { $_ }
    }
    
    # Add default path if no environment variable is set
    if ($toolboxPaths.Count -eq 0) {
        $defaultPath = Join-Path $PSScriptRoot ".." "tmp" "tools"
        $toolboxPaths += $defaultPath
    }
    
    # Resolve and return only existing directories
    $toolboxPaths | ForEach-Object {
        $resolved = Resolve-Path $_ -ErrorAction SilentlyContinue
        if ($resolved) {
            $resolved.Path
        }
    }
}

<#
.SYNOPSIS
Discovers toolbox tool definitions from specified directories.

.DESCRIPTION
Scans toolbox directories for PowerShell scripts (.ps1 files) that define tools.
Each tool script should return a tool specification compatible with Register-Tool.

.PARAMETER Path
Optional specific path to scan. If not provided, uses Get-PSAIToolboxPath.

.EXAMPLE
Get-PSAIToolbox
Discovers all toolbox tools from configured paths.

.EXAMPLE
Get-PSAIToolbox -Path "./my-tools"
Discovers toolbox tools from a specific directory.

.OUTPUTS
System.Object[]
Array of tool definitions ready for New-Agent -Tools.
#>
function Get-PSAIToolbox {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$Path
    )
    
    if (-not $Path) {
        $Path = Get-PSAIToolboxPath
    }
    
    $tools = @()
    
    foreach ($toolPath in $Path) {
        if (Test-Path $toolPath) {
            Write-Verbose "Scanning toolbox path: $toolPath"
            
            # Find all .ps1 files in subdirectories
            $toolScripts = Get-ChildItem -Path $toolPath -Filter "*.ps1" -Recurse -File
            
            foreach ($script in $toolScripts) {
                try {
                    Write-Verbose "Loading tool from: $($script.FullName)"
                    
                    # Dot-source the script to load its functions
                    . $script.FullName
                    
                    # The script should define a function that returns tool specifications
                    # Convention: function name matches filename without extension
                    $functionName = $script.BaseName
                    
                    if (Get-Command $functionName -ErrorAction SilentlyContinue) {
                        # Call the function to get tool registrations
                        $toolSpecs = & $functionName
                        
                        if ($toolSpecs) {
                            $tools += $toolSpecs
                            Write-Verbose "Registered $(@($toolSpecs).Count) tool(s) from $functionName"
                        }
                    }
                }
                catch {
                    Write-Warning "Failed to load tool from $($script.FullName): $_"
                }
            }
        }
        else {
            Write-Warning "Toolbox path does not exist: $toolPath"
        }
    }
    
    Write-Verbose "Total tools discovered: $($tools.Count)"
    return $tools
}

<#
.SYNOPSIS
Creates a new PSAI agent with toolbox tools automatically loaded.

.DESCRIPTION
Convenience function that discovers toolbox tools and creates an agent with them.
This combines Get-PSAIToolbox with New-Agent for a streamlined experience.

.PARAMETER Instructions
Instructions for the agent.

.PARAMETER ToolboxPath
Optional specific toolbox path(s). If not provided, uses environment configuration.

.PARAMETER Name
Name of the agent.

.PARAMETER Description
Description of the agent.

.PARAMETER ShowToolCalls
Switch to show tool invocations.

.EXAMPLE
$agent = New-PSAIToolboxAgent -Instructions "You are a helpful assistant"
Creates an agent with all discovered toolbox tools.

.EXAMPLE
$agent = New-PSAIToolboxAgent -ToolboxPath "./my-tools" -ShowToolCalls
Creates an agent with tools from a specific path and shows tool calls.

.OUTPUTS
PSCustomObject
An agent object that can be used with Get-AgentResponse and Invoke-InteractiveCLI.
#>
function New-PSAIToolboxAgent {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Instructions,
        
        [Parameter()]
        [string[]]$ToolboxPath,
        
        [Parameter()]
        [string]$Name,
        
        [Parameter()]
        [string]$Description,
        
        [Switch]$ShowToolCalls
    )
    
    # Discover toolbox tools
    if ($ToolboxPath) {
        $tools = Get-PSAIToolbox -Path $ToolboxPath
    }
    else {
        $tools = Get-PSAIToolbox
    }
    
    if ($tools.Count -eq 0) {
        Write-Warning "No toolbox tools discovered. Agent will be created without tools."
    }
    
    # Create agent with discovered tools
    $agentParams = @{
        Tools = $tools
        ShowToolCalls = $ShowToolCalls
    }
    
    if ($Instructions) {
        $agentParams['Instructions'] = $Instructions
    }
    
    if ($Name) {
        $agentParams['Name'] = $Name
    }
    
    if ($Description) {
        $agentParams['Description'] = $Description
    }
    
    New-Agent @agentParams
}

# Export functions
Export-ModuleMember -Function Get-PSAIToolboxPath, Get-PSAIToolbox, New-PSAIToolboxAgent
