function Invoke-PSToolBoxAI {
    [CmdletBinding()]
    [Alias('pt')]
    param(
        [string]$Prompt,
        [string[]]$ToolboxPath
    )
    
    
    # Main function for PSToolboxAI
    if ($Prompt) {
        Write-Verbose "Processing prompt: $Prompt"
    }
    else {
        Write-Verbose "Entering Chat Mode"
    }
    
    $toolboxPath = if ($ToolboxPath) { 
        $ToolboxPath 
    } 
    else { 
        if ($env:POWERSHELL_TOOLBOX_AI) { 
            $env:POWERSHELL_TOOLBOX_AI -split ';' 
        }
        else {
            @() 
        } 
    }    if ($toolboxPath) {
        Write-Verbose "Loading tools from $($toolboxPath -join ';')"
        $env:POWERSHELL_TOOLBOX_ACTION = 'describe'
        $toolPaths = $toolboxPath
        
        $tools = @()
        foreach ($path in $toolPaths) {
            if (Test-Path $path) {
                $files = Get-ChildItem $path -File -Recurse *.ps1 | Where-Object { $_.Name -notlike "*.tests.ps1" }
                foreach ($file in $files) {
                    Write-Verbose "Importing tool: $($file.FullName)"
                    $tools += . $file.FullName
                }
            }
            else {
                Write-Warning "Directory '$path' does not exist."
            }
        }
        
        $env:POWERSHELL_TOOLBOX_ACTION = $null
        if ($tools.Count -eq 0) {
            Write-Verbose "Initializing agent with tools: no tools found"
        }
        else {
            Write-Verbose "Initializing agent with tools: $($tools.function.name -join ', ')"
        }

        $agentParameters = @{
            Tools         = $tools
            LLM           = (New-OpenAIChat gpt-4.1)
            ShowToolCalls = $PSBoundParameters.ContainsKey('Verbose')
            Instructions  = "You must check the tools first and use them"
        }
        
        $agent = New-Agent @agentParameters

        if (-not $Prompt) {
            $agent = $agent | Start-Conversation
        }
        else {
            Write-Verbose "Querying agent..."
            $agent | Get-AgentResponse -Prompt $Prompt
        }
    }
    else {
        Write-Error "Toolbox path is not set. Please provide it as a parameter or set the environment variable 'POWERSHELL_TOOLBOX_AI'."
        return
    }
}