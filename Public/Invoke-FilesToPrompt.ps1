<#
.SYNOPSIS
    Concatenate a directory full of files into a single prompt for use with LLMs

.DESCRIPTION
    Takes one or more paths to files or directories and outputs every file, recursively, each one preceded with its filename like this:

    path/to/file.py
    ----
    Contents of file.py goes here

    ---
    path/to/file2.py
    ---
    ...

.PARAMETER Path
    Specifies the path of the files to be processed.

.EXAMPLE
    Invoke-FilesToPrompt -Path "C:\MyFiles"

    This example invokes the Invoke-FilesToPrompt function to process files in the "C:\MyFiles" directory.

.EXAMPLE
    Invoke-FilesToPrompt -Path "C:\MyFiles\*.md"
    
    This example invokes the Invoke-FilesToPrompt function to process all Markdown files in the "C:\MyFiles" directory.

    .EXAMPLE
    Invoke-FilesToPrompt -Path "C:\MyFiles\*.md", "C:\MyOtherFiles\*.md"
    
    This example invokes the Invoke-FilesToPrompt function to process all Markdown files in the "C:\MyFiles" directory.

#>
function Invoke-FilesToPrompt {
    [CmdletBinding()]
    param (
        $Path
    )

    foreach ($item in $Path) {
        if (!(Test-Path $item) ) {
            Write-Host "$item does not exist." -ForegroundColor Red
            continue
        }

        Write-Host "Processing $item" -ForegroundColor Green
        foreach ($targetItem in Get-ChildItem $item -Recurse) {
            $content = Get-Content $targetItem.FullName -raw
            @"
$($targetItem.FullName)
---
$content

"@    
        }
    }
}