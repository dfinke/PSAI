function Invoke-QuickPrompt {
    [CmdletBinding()]
    param(
        [string]$targetPrompt,
        [Parameter(ValueFromPipeline = $true)]
        [object]$pipelineInput,
        [switch]$OutputOnly
    )
 
    Begin {
        $additionalInstructions = @()

    }

    Process {
        $additionalInstructions += $pipelineInput
    }

    End {
    
        $prompt = "work it"
        if ($targetPrompt) {
            $prompt = $targetPrompt
        }

        $instructions += @"
<date>$(Get-Date)</date>
<current directory>$($pwd)</current directory>

- You are a terminal assistant. You are a software and data science expert. Your preference is PowerShell, unless otherwise directed. 

for code answers:
- do not include fence blocks around the code ``````  ``````
- do not include explanation
- do not include usage information
- just code

"@


        if ($additionalInstructions) {
            $prompt += @"
Here are the additional instructions Fthe user piped in:
<additional instructions>
$($additionalInstructions -join "`n")
</additional instructions>
"@
        }

        Write-Verbose @"
Instructions: $instructions
Prompt: $prompt
"@

        $agent = New-Agent -Instructions $instructions

        if($OutputOnly) {
            $agent | Get-AgentResponse -Prompt $prompt
            return
        } 

        While ($true) { 
            $agentResponse = $agent | Get-AgentResponse $prompt

            # Format-SpectrePanel -Data (Get-SpectreEscapedText -Text $agentResponse) -Title "Agent Response" -Border "Rounded" -Color "Blue"
            # Format-SpectrePanel -Data "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -Border "Rounded" -Color "Cyan1"

            Out-BoxedText -Text $agentResponse -Title "Agent Response" -BoxColor "Blue" 
            Out-BoxedText -Text "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -BoxColor Cyan 

            $prompt = Read-Host '> '
            if ([string]::IsNullOrEmpty($prompt)) {            
                # Format-SpectrePanel -Data "Copied to clipboard." -Title "Information" -Border "Rounded" -Color "Green"
                Out-BoxedText -Text "Copied to clipboard." -Title "Information" -BoxColor "Green"

                $agentResponse | Set-Clipboard
                break            
            }
        }    
    }
}