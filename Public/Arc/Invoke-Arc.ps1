function Invoke-Arc {
    [CmdletBinding()]
    [Alias("Arc")]
    param(        
        [string]$prompt,
        [string]$model = 'gpt-4.1',
        [ValidateSet('skill', 'tool')]
        [string]$Type = 'skill',
        [switch]$ShowToolCalls
    )

    Write-Verbose "[Invoke-Arc] Called with Type: $Type, Model: $model, Prompt: $prompt"
    switch ($Type) {
        'skill' {
            Write-Verbose "[Invoke-Arc] Invoking PSSkills"
            Invoke-PSSkills -Prompt $prompt -Model $model -ShowToolCalls:$ShowToolCalls
        }
        'tool' {
            Write-Verbose "[Invoke-Arc] Invoking PSToolBoxAI"
            Invoke-PSToolBoxAI -Prompt $prompt #-Model $model
        }
    }
}

# $env:POWERSHELL_TOOLBOX_AI='d:\mygit\PowerShellAIAssistant-ScratchPad\PowerShell-Skills\toolbox'

# arc -Type tool
# arc -Type skill