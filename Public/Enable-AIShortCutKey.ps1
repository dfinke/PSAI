$script:messages = @()

function Enable-AIShortCutKey {
    param(
        $ShortcutKey = $(
            # In Visual Studio Code, CTRL+G is "goto",
            if ((Get-Process -id $pid).Parent.ProcessName -eq 'code') {
                "ALT+G" # so we'll use ALT+G by default.
            }
            else {
                "CTRL+G" # If we're not running in code, use CTRL+G by default
            }
        )
    )

    Begin {
        $script:messages += New-ChatRequestSystemMessage @'
you are a helpful powershell expert. be concise, accurate, and friendly.
- you are in a powershell console
- no need for extra details
- no need for usage
- no need for examples
- just code, no fence blocks
- again just code, no fence blocks
'@
    }

    End {
        Set-PSReadLineKeyHandler -Key $ShortcutKey -BriefDescription OpenAICli -LongDescription "Calls Open AI on the current buffer" `
            -ScriptBlock {
            param($key, $arg)

            $line = $null
            $cursor = $null

            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

            $script:messages += New-ChatRequestUserMessage $line
            
            # $output = Get-GPT3Completion $prompt -max_tokens 256 
            # $output = $output -replace "`r", ""
            $response = Invoke-OAIChatCompletion -Messages $script:messages 

            $script:messages += $response.choices[0].message | ConvertTo-Json | ConvertFrom-Json -AsHashtable
            $output = $response.choices[0].message.content

            # check if output is not null
            if ($null -ne $output) {        
                foreach ($str in $output) {
                    if ($null -ne $str -and $str -ne "") {
                        [Microsoft.PowerShell.PSConsoleReadLine]::AddLine()
                        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($str)
                    }
                }
            }
        }
    }
}