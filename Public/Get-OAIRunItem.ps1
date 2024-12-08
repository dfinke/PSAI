<#
.SYNOPSIS
Retrieves information about a specific run item.

.DESCRIPTION
The Get-OAIRunItem function retrieves information about a specific run item based on the provided thread ID and run ID.

.PARAMETER threadId
The ID of the thread associated with the run item. This parameter is mandatory.

.PARAMETER runId
The ID of the run item to retrieve information for. This parameter is mandatory.

.EXAMPLE
Get-OAIRunItem -threadId 123 -runId 456
Retrieves information about the run item with thread ID 123 and run ID 456.

.LINK
https://platform.openai.com/docs/api-reference/runs/getRun
#>

function Get-OAIRunItem {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]        
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('run_id')]
        $RunId
    )

    Process {
        if ($null -eq $ThreadID -or $null -eq $RunId) {
            return
        }

        $url = "/threads/$ThreadID/runs/$RunId"
        $Method = 'Get'

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}
