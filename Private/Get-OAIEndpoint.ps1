function Get-OAIEndpoint {
    [CmdletBinding()]
    param (
        $Url,
        $Parameters
    )
    
    begin {
        $AddPArameters = $Parameters -join '&'
        $Url = $Url.TrimEnd('/')
    }
    
    process {
        switch ($OAIProvider) {
            'OpenAI' {
                $endpoint = '{0}/{1}' -f $baseUrl, $Url
                $endpoint, $AddPArameters -join '?'
            }
            'AzureOpenAI' {
                $endpoint = '{0}/{1}?api-version={2}' -f $baseUrl, $Url, $AzOAISecrets.apiVersion
               $endpoint, $AddPArameters -join '&'
            }
        }
    }
    
    end {
        
    }
}