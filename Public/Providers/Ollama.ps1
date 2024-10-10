# Documentation: https://github.com/ollama/ollama/blob/main/docs/api.md
@{
    Provider   = @{
        Name     = "Ollama"
        Provider = "Ollama"
        BaseUri  = "http://localhost:11434"
        Version  = "v1"
    }

    Models     = @(
        "llama3.1",
        "phi3:mini"
    )

    NewMessage = {
        [outputType([hashtable])]
        [CmdletBinding()]
        param(
            [ValidateSet('user', 'assistant')]
            [string]$role = "user",
            [string]$Content
        )
        @{
            role    = $Actor
            content = $Content
        }
    }

    Chat       = {
        [CmdletBinding()]
        param(
            $prompt,
            [switch]$ReturnObject,
            [hashtable]$BodyOptions = @{stream = $false}
        )
    
        #Initiialize a body object
        $body = [ordered]@{
            model = $this.Name
        }

        # Add the prompt to BodyOptions
        $BodyOptions.Add('prompt', $prompt)
    
        #Add options to the body object
        $BodyOptions.Keys | ForEach-Object {
            $body[$_] = $BodyOptions[$_]
        }

        $body |convertto-json -Depth 10 | Write-Verbose
        
        $params = @{
            Uri         = "$($this.Provider.BaseUri)/api/generate"
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }

        $r = Invoke-RestMethod @params

        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'Ollama'
                Response       = $r.response
                ResponseObject = $r
            }
        }
        else {
            $r.response
        }
    }

}