function Add-CustomModel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $ModelName
    )

    $AdditionalModelsPath = Join-Path $PSScriptRoot 'AdditionalModels.clixml'
    if (Test-Path -Path $AdditionalModelsPath) {
        $ExistingModels = Import-Clixml -Path $AdditionalModelsPath
        $($ExistingModels += $ModelName) | Select-Object -Unique | Export-Clixml -Path $AdditionalModelsPath
    }
    else {
        $ModelName | Export-Clixml -Path $AdditionalModelsPath
    }
}