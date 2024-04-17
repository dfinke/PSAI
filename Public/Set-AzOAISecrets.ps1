function Set-AzOAISecrets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $apiURI,
        [Parameter(Mandatory)]
        $apiKEY,
        [Parameter(Mandatory)]
        $apiVersion,
        [Parameter(Mandatory)]
        $deploymentName
    )

    $script:AzOAISecrets['apiURI'] = $apiURI
    $script:AzOAISecrets['apiKEY'] = $apiKEY
    $script:AzOAISecrets['apiVersion'] = $apiVersion
    $script:AzOAISecrets['deploymentName'] = $deploymentName
}