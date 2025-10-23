function global:Invoke-NodeScriptString {
    <#
    .SYNOPSIS
    Runs a JavaScript script passed as a string using Node.js.

    .DESCRIPTION
    This function takes a string containing JavaScript code, writes it to a temporary file, executes it with Node.js, and then deletes the temp file.

    .PARAMETER Script
    The JavaScript code to run as a string.

    .EXAMPLE
    Invoke-NodeScriptString -Script "console.log('Hello from string!');"

    .NOTES
    Author: Copilot
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Script
    )

    $tempFile = [System.IO.Path]::GetTempFileName() + ".js"
    Set-Content -Path $tempFile -Value $Script -Encoding UTF8

    try {
        node $tempFile
    }
    finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}
