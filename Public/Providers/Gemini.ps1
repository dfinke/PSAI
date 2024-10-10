@{
    # Provider section. Only configure a single provider. Do not type the API Key here!
    Provider   = @{
        Name     = "Gemini"
        Provider = "Gemini"
        Version  = "v1beta"
        BaseUri  = "https://generativelanguage.googleapis.com"
    }

    # Model section. Several models can be configured with the same provider
    Models     = @(
        "gemini-1.5-pro"
    )

    NewMessage = {
        [outputType([hashtable])]
        [CmdletBinding()]
        param(
            [ValidateSet('user', 'model', 'system')]
            [string]$role = "user",
            [string]$Content,
            [string]$type = "text",
            [array]$parts = @()
        )

        $message = @{
            role    = $role
            "parts" = $parts
        }
        if ($Content) {
            $message.parts += @{
                $type = $Content
            }
        }
        $message
    }

    Chat       = {
        [CmdletBinding()]
        param(
            $prompt,
            [switch]$ReturnObject,
            [hashtable]$BodyOptions = @{},
            [array]$messages = @()
        )

        #Add options to the body object
        $BodyOptions.Keys | ForEach-Object {
            $body[$_] = $BodyOptions[$_]
        }

        #Add prompt to messages
        if ($prompt) {
            $messages += $this.NewMessage("user", $prompt)
        }

        #Initiialize a body object
        $body = [ordered]@{
            contents = $messages
        }

        $params = @{
            Uri         = "$($this.Provider.BaseUri)/$($this.Provider.Version)/models/$($this.Name):generateContent?key=$($this.Provider.GetApiKey())"
            Method      = "Post"
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }
        $params | Convertto-json -Depth 10 -compress | Write-Verbose
    
        $r = Invoke-RestMethod @params

        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'Gemini'
                Response       = $r.candidates[0].content.parts[0].text
                ResponseObject = $r
            }
        }
        else {
            $r.candidates[0].content.parts[0].text
        }
    }
}

