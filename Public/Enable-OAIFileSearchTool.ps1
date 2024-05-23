<#
.SYNOPSIS
Enables the file searcch tool.

.DESCRIPTION
The Enable-OAIFileSearchTool function enables the file search tool.

.OUTPUTS
Hashtable
Returns a hashtable with the 'type' property set to 'retrieval'.
#>

function Enable-OAIFileSearchTool {
    [CmdletBinding()]
    param()
    
    @{'type' = 'file_search' }
}
