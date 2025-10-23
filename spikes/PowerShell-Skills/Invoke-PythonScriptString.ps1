function global:Invoke-PythonScriptString {
    <#
    .SYNOPSIS
    Runs a string of Python code using Python.

    .DESCRIPTION
    This function takes a string containing Python code, writes it to a temporary file, executes it, and returns the output.

    .PARAMETER PythonCode
    The Python code string to run.

    .EXAMPLE
    Invoke-PythonScriptString -PythonCode "print('Hello from Python!')"

    .NOTES
    Author: Copilot
    #>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$PythonCode
    )

    if ([string]::IsNullOrWhiteSpace($PythonCode)) {
        Write-Output "No Python code provided."
        return
    }

    $tempFile = [System.IO.Path]::GetTempFileName().Replace('.tmp', '.py')
    Set-Content -Path $tempFile -Value $PythonCode -Encoding UTF8

    try {
        $output = py $tempFile 2>&1
        return $output
    }
    finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}