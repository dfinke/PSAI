function Remove-CustomModel {
    param (
        [Parameter(Mandatory)]
        [string[]]
        $ModelName
    )

    $AdditionalModelsPath = Join-Path $PSScriptRoot 'AdditionalModels.clixml'
    if (Test-Path -Path $AdditionalModelsPath) {
        $ExistingModels = Import-Clixml -Path $AdditionalModelsPath
        $ExistingModels = $ExistingModels | Where-Object { $ModelName -notcontains $_ }
        $ExistingModels | Export-Clixml -Path $AdditionalModelsPath
    }
}