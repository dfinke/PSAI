# Reuse one anonymous conversation identifier for this module instance.
$script:ParallelSessionId = [guid]::NewGuid().ToString()

function Invoke-ParallelMcpRequest {
    [CmdletBinding()]
    param(
        [hashtable]$Message,
        [hashtable]$Headers,
        [int]$TimeoutSec
    )

    try {
        $timeoutOptions = @{ TimeoutSec = $TimeoutSec }
        # Newer PowerShell versions split connection and operation timeouts.
        if ((Get-Command Invoke-WebRequest).Parameters.ContainsKey('OperationTimeoutSeconds')) {
            $timeoutOptions['OperationTimeoutSeconds'] = $TimeoutSec
        }
        $response = Invoke-WebRequest -Uri 'https://search.parallel.ai/mcp' -Method Post `
            -ContentType 'application/json; charset=utf-8' -Headers $Headers `
            -UserAgent "PSAI/$($ExecutionContext.SessionState.Module.Version) (https://github.com/dfinke/PSAI)" `
            -Body ($Message | ConvertTo-Json -Depth 20 -Compress) @timeoutOptions -ErrorAction Stop

        # Notifications have no JSON-RPC response body.
        if (-not $Message.ContainsKey('id')) {
            return
        }

        $contentType = $response.Headers['Content-Type'] -join ','
        if ($contentType -like 'text/event-stream*') {
            $replies = @(
                foreach ($sseEvent in ($response.Content -split '\r?\n\r?\n')) {
                    $data = @($sseEvent -split '\r?\n' | Where-Object { $_ -like 'data:*' } |
                        ForEach-Object { $_.Substring(5).TrimStart(' ') }) -join "`n"
                    if ($data) { $data | ConvertFrom-Json -Depth 30 }
                }
            )
        }
        else {
            $replies = @($response.Content | ConvertFrom-Json -Depth 30)
        }

        $reply = $replies | Where-Object { $_.id -eq $Message.id } | Select-Object -First 1
        if (-not $reply -or $reply.jsonrpc -ne '2.0') {
            throw 'Missing matching MCP response.'
        }
        if ($reply.error) {
            throw "MCP error $($reply.error.code): $($reply.error.message)"
        }
        if ($null -eq $reply.result) {
            throw 'Missing MCP result.'
        }

        [pscustomobject]@{ Result = $reply.result; Headers = $response.Headers }
    }
    catch {
        throw "Parallel MCP $($Message.method) failed: $_"
    }
}

function Invoke-ParallelMcp {
    [CmdletBinding()]
    param(
        [string]$ToolName,
        [hashtable]$Arguments,
        [int]$TimeoutSec
    )

    $headers = @{ Accept = 'application/json, text/event-stream' }
    $initialized = Invoke-ParallelMcpRequest -Headers $headers -TimeoutSec $TimeoutSec -Message @{
        jsonrpc = '2.0'; id = 1; method = 'initialize'
        params = @{
            protocolVersion = '2025-03-26'
            capabilities = @{}
            clientInfo = @{ name = 'PSAI'; version = "$($ExecutionContext.SessionState.Module.Version)" }
        }
    }
    $headers['MCP-Protocol-Version'] = $initialized.Result.protocolVersion
    $sessionId = $initialized.Headers['Mcp-Session-Id'] -join ''
    if ($sessionId) { $headers['Mcp-Session-Id'] = $sessionId }

    Invoke-ParallelMcpRequest -Headers $headers -TimeoutSec $TimeoutSec -Message @{
        jsonrpc = '2.0'; method = 'notifications/initialized'
    }
    $Arguments['session_id'] = $script:ParallelSessionId
    $called = Invoke-ParallelMcpRequest -Headers $headers -TimeoutSec $TimeoutSec -Message @{
        jsonrpc = '2.0'; id = 2; method = 'tools/call'
        params = @{ name = $ToolName; arguments = $Arguments }
    }

    $text = @($called.Result.content | Where-Object { $_.type -eq 'text' } |
        ForEach-Object { $_.text }) -join "`n"
    if ($called.Result.isError) { throw "Parallel MCP $ToolName failed: $text" }
    if (-not $text) { throw "Parallel MCP $ToolName returned no text content." }
    $text
}
