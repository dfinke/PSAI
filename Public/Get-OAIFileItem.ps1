<#
.SYNOPSIS
Retrieves information about a file from the OpenAI API.

.DESCRIPTION
The Get-OAIFileItem function retrieves information about a file from the OpenAI API by providing the file ID.

.PARAMETER FileId
The ID of the file to retrieve information for.

.EXAMPLE
Get-OAIFileItem -FileId "abc123"
Retrieves information about the file with the ID "abc123" from the OpenAI API.

.LINK
https://beta.openai.com/docs/api-reference/files/retrieve
#>
function Get-OAIFileItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $FileId
    )
    process {
        $uri = $baseUrl + "/files/$FileId"
        $Method = "Get"

        Invoke-OAIBeta -Uri $uri -Method $Method 
    }
}
