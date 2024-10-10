
# Documentaition: https://docs.anthropic.com/en/api/getting-started
@{
    Provider   = @{
        Name     = "Anthropic"
        Provider = "Anthropic"
        BaseUri  = "https://api.anthropic.com"
        Version  = "2023-06-01"
    }

    Models     = @(
        "claude-3-5-sonnet-20240620"
    )

    NewMessage = {
        [outputType([hashtable])]
        [CmdletBinding()]
        param(
            [ValidateSet('user', 'assistant', 'system')]
            [string]$role = "user",
            $Content # Takes a string or an array of objects
        )
        @{
            role    = $role
            content = $Content
        }
    }

    Chat       = {
        [CmdletBinding()]
        param(
            $prompt,
            [switch]$ReturnObject,
            [hashtable]$BodyOptions = @{max_tokens=1024}, # max_tokens is required for Antropic
            [array]$messages = @()
        )
    
        #Initiialize a body object
        $body = [ordered]@{
            model = $this.Name
        }      
        
        #Add options to the body object
        $BodyOptions.Keys | ForEach-Object {
            $body[$_] = $BodyOptions[$_]
        }

        #Add prompt to messages
        if ($prompt) {
            $messages += $this.NewMessage("user", $prompt)
        }
        
        $body.Add('messages', $messages)

        $headers = @{
            'x-api-key' = $this.Provider.GetApiKey()
            'anthropic-version' = $this.Provider.Version
        }

        $params = @{
            Headers     = $headers
            Uri         = "$($this.Provider.BaseUri)/v1/messages"
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }

        $r = Invoke-RestMethod @params

        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'Anthropic'
                Response       = $r.content[0].text # There might come other stuff out here
                ResponseObject = $r
            }
        }
        else {
            $r.content[0].text
        }
    }

}