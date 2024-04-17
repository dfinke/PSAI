<#
.SYNOPSIS
Removes a file from the OpenAPI server.

.DESCRIPTION
The Remove-OAIFile function removes a file from the OpenAPI server using the specified file ID.

.PARAMETER id
The ID of the file to be removed.

.EXAMPLE
Remove-OAIFile -id "12345"

This example removes the file with the ID "12345" from the OpenAPI server.

.LINK
https://platform.openai.com/docs/api-reference/files/delete
#>
function Remove-OAIFile {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $id
    )

    Process {
        $url = $baseUrl + "/files/$id"
        $Method = 'Delete'

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}