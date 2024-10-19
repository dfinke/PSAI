function New-AIModel {
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $Id,
        [switch] $Default,
        [string] $ProviderName,
        # [string] $Chat,
        # [string] $NewMessage,
        [switch] $PassThru,
        [hashtable] $ModelFunctions
    )
    
    begin {
    }
    
    process {
        $Model = [PSCustomObject]@{
            PSTypeName = 'AIModel'
            Name = $Name
            Provider = [PSCustomObject]@{}
        }

        # if ($Chat) {
        #     Add-Member -InputObject $Model -MemberType ScriptMethod -Name Chat -Value $([Scriptblock]::Create($Chat))
        # }
        # if ($NewMessage) {
        #     Add-Member -InputObject $Model -MemberType ScriptMethod -Name NewMessage -Value $([Scriptblock]::Create($NewMessage))
        # }
        
        $ModelFunctions.Keys | ForEach-Object {
            Add-Member -InputObject $Model -MemberType ScriptMethod -Name $_ -Value $([Scriptblock]::Create($ModelFunctions[$_]))
        }

        if ($ProviderName){
            [PSCustomObject]$AIProvider = Get-AIProvider -Name $ProviderName
            if (!$AIProvider) {
                Write-Error "Provider not found in the ProviderList. Please supply an existing Provider or ProviderName" -ErrorAction Stop
            }
            if ($AIProvider.AIModels.Count -eq 0) {
                $Default = $true
            }
            if ($AIProvider.AIModels?.ContainsKey($Model.Name)) {
                Write-Error "Model already exists in the Provider. Please supply a new Model Name" -ErrorAction Stop
            }
            $Model.Provider = $AIProvider
            $AIProvider.AddModel($Model, $Default)
        }

        if ($PassThru) {$Model}
    }
    
    end {
        # Update tab completion on Get-AIProvider
        Update-ArgumentCompleter -Function 'Get-AIModel' -Provider -Model
    }
}