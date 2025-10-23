function global:Invoke-NodeScript {
    <#
    .SYNOPSIS
    Runs a specified JavaScript file using Node.js.

    .DESCRIPTION
    This function takes a file path to a JavaScript file and executes it with Node.js.

    .PARAMETER FilePath
    The path to the JavaScript file to run.

    .EXAMPLE
    Invoke-NodeScript -FilePath './hello.js'

    .NOTES
    Author: Copilot
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$FilePath
    )

    if (-not (Test-Path $FilePath)) {
        "File not found: $FilePath"
        return
    }

    node $FilePath
}
