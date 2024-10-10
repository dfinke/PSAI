
@{
    Provider   = @{
        Name     = "OpenAI"
        Provider = "OpenAI"
        BaseUri  = "https://api.openai.com/"
        Version  = "v1"
    }

    Models     = @(
        "gpt-4o-mini"
   )

    NewMessage = {
        [outputType([hashtable])]
        [CmdletBinding()]
        param(
            [ValidateSet('user', 'assistant', 'system')]
            [string]$role = "user",
            [string]$Content
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
            [hashtable]$BodyOptions = @{},
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
            $body.Add('messages', $messages)
        }

        $params = @{
            Headers     = @{ Authorization = "Bearer $($this.Provider.GetApiKey())" }
            Uri         = "$($this.Provider.BaseUri)/$($this.Provider.Version)/chat/completions"
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }

        $r = Invoke-RestMethod @params

        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'OpenAI'
                Response       = $r.choices[0].message.content
                ResponseObject = $r
            }
        }
        else {
            $r.choices[0].message.content
        }
    }

}