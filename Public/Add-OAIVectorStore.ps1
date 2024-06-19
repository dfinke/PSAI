<#
.SYNOPSIS
Uploads one or more files and creates a vector store.

.DESCRIPTION
The Add-OAIVectorStore function is a simple workflow using Invoke-OAIUploadFile and New-OAIVectorStore to upload files to OpenAI and create a vector store.

.PARAMETER Path
Specifies the path where the files to be uploaded are located.

.EXAMPLE
Add-OAIVectorStore -Path "C:\Files"

This example uploads all the files located in the "C:\Files" directory to OAI and creates a vector store.

#>
function Add-OAIVectorStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Path
    )

    $timeStamp = Get-Date -Format "yyyyMMddHHmmss" 
    Write-Host "Uploading files in $Path to OAI..." -ForegroundColor Cyan
    $files = Get-ChildItem $Path | Invoke-OAIUploadFile

    Write-Host "Creating vector store..." -ForegroundColor Cyan
    New-OAIVectorStore -Name "vs$($timeStamp)" -FileIds $files.id
}