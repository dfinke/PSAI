<#
.SYNOPSIS
    Invokes an OpenAI API endpoint using the OpenAI-Beta header.

.DESCRIPTION
    The Invoke-OAIBeta function is used to send requests to an OpenAI API endpoint. It supports various parameters such as the URI, HTTP method, request body, content type, output file, and more.

.PARAMETER Uri
    Specifies the URI of the OpenAI API endpoint.

.PARAMETER Method
    Specifies the HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE).

.PARAMETER Body
    Specifies the request body to be sent with the API request.

.PARAMETER ContentType
    Specifies the content type of the request body. The default value is 'application/json'.

.PARAMETER OutFile
    Specifies the path to save the response content to a file.

.PARAMETER NotOpenAIBeta
    If specified, removes the 'OpenAI-Beta' header from the request.

.EXAMPLE
    Invoke-OAIBeta -Uri 'https://api.openai.com/v1/endpoint' -Method 'GET' -OutFile 'response.json'

    This example sends a GET request to the specified API endpoint and saves the response content to a file named 'response.json'.

#>
function Invoke-OAIBeta {
    [CmdletBinding()]
    param(
        $Uri,
        $Method,
        $Body = [ordered]@{},
        $ContentType = 'application/json',
        $OutFile,
        $Model,
        $Provider,
        [Switch]$NotOpenAIBeta        
    )        
    

    $ProviderList = Get-AIProviderList

    # If the Provider List is empty, try to load legacy credentials
    if ($null -eq $ProviderList) { New-ProviderListFromEnv }

    $ModelName = $Body['model']
    # Remove model from body - handled by modelobject
    try {$Body.Remove('model')} catch{} #MemoryStreams don't have a remove method
    # Get default providers default model.
    if ($model.pstypenames -notcontains 'AIModel'){
        $params = @{}
        if ($Provider){$params['ProviderName'] = $Provider}
        if ($Model){$params['ModelName'] = $Model}
        elseif ($ModelName){$params['ModelName'] = $ModelName}
        $model = Get-AIModel @params
    }
    Write-Verbose "Using provider: $($model.Provider.Name)"
    Write-Verbose "Using model: $($model.Name)"

    # TODO remove this unit testing block - new code does it differently
    if (Test-IsUnitTestingEnabled) {
        $provider = Get-AIProvider | Select-Object -ExpandProperty Name
        Write-Host "Data saved. Use Get-UnitTestingData to retrieve the data."
        $headers = @{
            'OpenAI-Beta'  = 'assistants=v2'
            'Content-Type' = 'application/json'
            }
        if ($provider -eq 'OpenAI') {
            $headers.Add('Authorization', 'Bearer ')
        }
        if ($provider -eq 'AzureOpenAI') {
            $headers.Add('api-key',(Get-AIProvider).GetApiKey())
        }
        $script:InvokeOAIUnitTestingData = @{
            Uri           = $Uri
            Method        = $Method
            Headers       = $headers.Clone() 
            Body          = $Body
            OAIProvider   = Get-OAIProvider
            ContentType   = $ContentType
            OutFile       = $OutFile
            NotOpenAIBeta = $NotOpenAIBeta
        }        
        return
    }

    $Response = $model.InvokeModel('', $true, $Body, @(), $Uri, $Method, $ContentType)
    if ($response.ResponseObject) {
        return $response
    }
    throw $Response
}
