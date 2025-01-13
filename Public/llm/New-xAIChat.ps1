function New-xAIChat {
    [CmdletBinding()]
    param(
        $model = 'grok-2-1212'
    )

    $targetConfig = [PSCustomObject]@{
        config = [PSCustomObject]@{
            model = $model
        }
    }

    $verboseMessage = @"
$(Get-LogDate) 
New-xAIChat was called
$($targetConfig | dumpJson)
"@
  
    Write-Verbose $verboseMessage
    
    $targetConfig
}