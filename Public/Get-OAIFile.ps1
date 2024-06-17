<#
.SYNOPSIS
Retrieves files from a specified URL.

.DESCRIPTION
The Get-OAIFile function retrieves files from a specified URL using the specified HTTP method. It supports filtering files based on the purpose parameter.

.PARAMETER purpose
Specifies the purpose of the files to retrieve. Valid values are 'fine-tune', 'fine-tune-results', and 'assistants'.

.EXAMPLE
Get-OAIFile -purpose fine-tune
Retrieves files from the specified URL with the purpose set to 'fine-tune'.

.LINK
https://platform.openai.com/docs/api-reference/files/list
#>
function Get-OAIFile {
    [CmdletBinding()]
    param (
        [ValidateSet('fine-tune', 'fine-tune-results', 'assistants')]
        $purpose,
        [Switch]$Raw
    )
    
    $url = $url = Get-OAIEndpoint -Url "files"
    $Method = 'Get'

    if ($purpose) {
        $url += "?purpose=$purpose"
    }

    $params = @{
        Uri    = $url
        Method = $Method
    }
    
    $result = Invoke-OAIBeta @params

    if ($Raw) {
        return $result
    } 
    else {
        return $result.data
    }
}