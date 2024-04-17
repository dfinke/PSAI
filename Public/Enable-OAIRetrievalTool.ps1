<#
.SYNOPSIS
Enables the retrieval tool.

.DESCRIPTION
The Enable-OAIRetrievalTool function enables the retrieval tool.

.PARAMETER None
This function does not accept any parameters.

.OUTPUTS
Hashtable
Returns a hashtable with the 'type' property set to 'retrieval'.

#>
function Enable-OAIRetrievalTool {
    [CmdletBinding()]
    param()
    
    @{'type' = 'retrieval' }
}
