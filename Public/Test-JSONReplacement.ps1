function Test-JsonReplacement {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $JSON
    )

    Write-Verbose "Using ConvertFrom-Json"
    try {
        ConvertFrom-Json -InputObject $Json | Out-Null
        $true
    }
    catch {
        $false
    }

}