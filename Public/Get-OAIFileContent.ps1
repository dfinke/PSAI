<#
.SYNOPSIS
Retrieves the content of a file from the OpenAI API.

.DESCRIPTION
The Get-OAIFileContent function retrieves the content of a file from the OpenAI API using the specified FileId. The content can be returned as plain text or in a specified content type. Optionally, the content can be saved to a file.

.PARAMETER FileId
The ID of the file to retrieve the content from.

.PARAMETER ContentType
The type of content to retrieve. The default value is "text/plain".

.PARAMETER OutFile
The path to save the content to. If specified, the content will be saved to the specified file.

.EXAMPLE
Get-OAIFileContent -FileId "abc123" -ContentType "application/json" -OutFile "C:\output.json"
Retrieves the content of the file with ID "abc123" from the OpenAI API as JSON and saves it to "C:\output.json".

.LINK
https://platform.openai.com/docs/api-reference/files/retrieve-contents
#>
function Get-OAIFileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $FileId,
        $ContentType = "text/plain",
        $OutFile
    )

    process {

        $params = @{
            Uri         = "files/$FileId/content"
            Method      = "Get"
            ContentType = $ContentType
        }

        if ($OutFile) {
            $params["OutFile"] = $OutFile
        }
 
        Invoke-OAIBeta @params
    }
}