function New-GeminiChat {
    [CmdletBinding()]
    param(
        $model = 'gemini-1.5-flash'
    )

    $targetConfig = [PSCustomObject]@{
        config = [PSCustomObject]@{
            model = $model
        }
    }

    $verboseMessage = @"
$(Get-LogDate) 
New-GeminiChat was called
$($targetConfig | dumpJson)
"@
  
    Write-Verbose $verboseMessage
 
    Set-OAIProvider 'Gemini'
    $targetConfig
}