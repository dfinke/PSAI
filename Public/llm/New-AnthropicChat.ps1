function New-AnthropicChat {
    [CmdletBinding()]
    param(
        $model = 'claude-3-5-sonnet-20240620'
    )

    $targetConfig = [PSCustomObject]@{
        config = [PSCustomObject]@{
            model = $model
        }
    }

    $verboseMessage = @"
$(Get-LogDate) 
New-AnthropicChat was called
$($targetConfig | dumpJson)
"@
  
    Write-Verbose $verboseMessage
    
    Set-OAIProvider 'Anthropic'
    $targetConfig
}