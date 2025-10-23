function global:Invoke-PythonScript {
    <#
    .SYNOPSIS
    Runs a specified Python file using Python.

    .DESCRIPTION
    This function takes a file path to a Python file and executes it with Python.

    .PARAMETER FilePath
    The path to the Python file to run.

    .EXAMPLE
    Invoke-PythonScript -FilePath './script.py'

    .NOTES
    Author: Copilot
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$FilePath
    )

    if ($null -eq $FilePath -or -not (Test-Path $FilePath)) {
        "File not found: $FilePath"
        return
    }
     
    python $FilePath
}