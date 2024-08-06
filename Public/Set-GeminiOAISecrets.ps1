<#
.SYNOPSIS
    Set Gemini secrets

.DESCRIPTION
    This cmdlet sets the API key, version and model name for the Gemini API.

.PARAMETER apiKEY
    The API key for accessing the Gemini API.

.PARAMETER apiVersion
    The version of the Gemini API. The default value is 'v1beta'.

.PARAMETER modelName
    The model name for the Gemini API. The default value is 'gemini-1.5-flash:generateContent'.

.EXAMPLE
    Set-GeminiSecrets -apiKEY $(Get-Secret -Name 'GeminiAPIKey' -AsPlainText)
#>


function Set-GeminiOAISecrets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $apiKEY,
        $apiVersion='v1beta',
        $modelName='gemini-1.5-flash:generateContent'
    )
    $script:GeminiOAISecrets = @{}
    $script:GeminiOAISecrets['apiKEY'] = $apiKEY
    $script:GeminiOAISecrets['apiVersion'] = $apiVersion
    $script:GeminiOAISecrets['modelName'] = $modelName
}