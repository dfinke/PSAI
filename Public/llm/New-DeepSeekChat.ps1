function New-DeepSeekChat {
    [CmdletBinding()]
    param(
        $model = 'deepseek-chat'
    )

    $targetConfig = [PSCustomObject]@{
        config = [PSCustomObject]@{
            model = $model
        }
    }

    $verboseMessage = @"
$(Get-LogDate) 
New-DeepSeekChat was called
$($targetConfig | dumpJson)
"@
  
    Write-Verbose $verboseMessage
 
    Set-OAIProvider 'DeepSeek'
    $targetConfig
}