function Invoke-QuickPrompt {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $additionalInstructions,
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$targetPrompt
    )
 
    Process {
        $null = $additionalInstructions
    }

    End {
    
        $prompt = $targetPrompt -join ' '
        $instructions = @"
You are a terminal assistant. Turn the natural language instructions into a terminal command. 

By default use PowerShell unless otherwise specified. Always only output code, no usage, explanation or examples. 

- just the code
- no fence blocks

However, if the user is clearly asking a question then answer it very briefly and well.

Here is additional context for the current console session:

<date>$(Get-Date)</date>
<current directory>$($pwd)</current directory>

<history>
$(Get-History | Format-List | Out-String)
</history>

<errors>
$Error
</errors>
"@
    
        $agent = New-Agent -Instructions $instructions

        While ($true) { 
            $agentResponse = $agent | Get-AgentResponse $prompt

            Format-SpectrePanel -Data (Get-SpectreEscapedText -Text $agentResponse) -Title "Agent Response" -Border "Rounded" -Color "Blue"
            Format-SpectrePanel -Data "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -Border "Rounded" -Color "Cyan1"

            $prompt = Read-Host '> '
            if ([string]::IsNullOrEmpty($prompt)) {            
                Format-SpectrePanel -Data "Copied to clipboard." -Title "Information" -Border "Rounded" -Color "Green"

                $agentResponse | Set-Clipboard
                break            
            }
        }    
    }
}