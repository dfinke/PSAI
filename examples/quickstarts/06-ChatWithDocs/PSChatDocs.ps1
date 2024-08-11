function PSChatDocs {
    param(
        [Parameter(Mandatory)]
        $Question,
        [Parameter(Mandatory)]
        $Path 
    )

    Write-Host "Uploading files..." -ForegroundColor Cyan
    
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        # slower sequential upload
        # use a newer version of PowerShell for parallel processing
        $files = Get-ChildItem $Path | ForEach-Object {
            Invoke-OAIUploadFile -Path $_.FullName
        }
    } else {
        $files = Get-ChildItem $Path | ForEach-Object -Parallel {
            Invoke-OAIUploadFile -Path $_.FullName
        }
    }


    Write-Host "Creating Assistant..." -ForegroundColor Cyan
    $ToolResources = @{
        file_search = @{
            vector_stores = @(
                @{
                    file_ids = @($files.id) 
                }
            )
        }
    }

    $assistant = New-OAIAssistant -Name 'Test' -ToolResources $ToolResources -Tools (Enable-OAIFileSearchTool)

    $assistant | Invoke-SimpleQuestion -Question $Question
}