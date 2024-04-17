<#
.SYNOPSIS
Uploads a file to a specified URL using the OpenAI API.

.DESCRIPTION
The Invoke-OAIUploadFile function uploads a file to a specified URL using the OpenAI API. It supports uploading files for fine-tuning or for use with assistants.

.PARAMETER Path
Specifies the path of the file to upload. This parameter accepts pipeline input by property name.

.PARAMETER Purpose
Specifies the purpose of the file upload. Valid values are 'fine-tune' and 'assistants'. The default value is 'assistants'.

.EXAMPLE
Invoke-OAIUploadFile -Path 'C:\Files\my_file.txt' -Purpose 'fine-tune'
Uploads the file 'my_file.txt' for fine-tuning using the OpenAI API.

.EXAMPLE
Get-ChildItem 'C:\Files' | Invoke-OAIUploadFile -Purpose 'assistants'
Uploads all files in the 'C:\Files' directory for use with assistants using the OpenAI API.
#>
function Invoke-OAIUploadFile {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path,
        [ValidateSet('fine-tune', 'assistants')]        
        $Purpose = 'assistants'
    )
    
    Process {
        $url = $baseUrl + '/files'
        $Method = 'POST'

        $FormData = Get-MultipartFormData -FilePath $Path -Purpose $Purpose

        Write-Host "Uploading file '$($Path)' with purpose '$Purpose' ..."
        Invoke-OAIBeta -Uri $url -Method $Method -Body $FormData['Stream'] -ContentType $FormData['ContentType']

        $FormData['Stream'].Close()
    }
}