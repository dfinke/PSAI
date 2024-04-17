<#
.SYNOPSIS
Waits for a run to complete in an Azure Machine Learning service workspace.

.DESCRIPTION
The Wait-OAIOnRun function waits for a run to complete in an Azure Machine Learning service workspace. It continuously checks the status of the run and sleeps for a short duration until the run is no longer in the 'queued' or 'in_progress' state.

.PARAMETER Run
The run object representing the run to wait for.

.PARAMETER Thread
The thread object representing the thread associated with the run.

.EXAMPLE
$run = Get-OAIRunItem -ThreadId $thread.id -RunId $run.id
Wait-OAIOnRun -Run $run -Thread $thread
#>
function Wait-OAIOnRun {
    [CmdletBinding()]
    param(
        $Run,
        $Thread
    )

    Write-Verbose "[$(Get-Date)] Waiting for run to complete..."
    while ($Run.status -eq 'queued' -or $Run.status -eq 'in_progress') {
        $Run = Get-OAIRunItem -ThreadId $Thread.id -RunId $Run.id
        Start-Sleep -Seconds 0.5
    }
    
    $Run
}
