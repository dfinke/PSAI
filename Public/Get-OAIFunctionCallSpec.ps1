<#
.SYNOPSIS
Generates a specification for a given PowerShell cmdlet.

.DESCRIPTION
The Get-OAIFunctionCallSpec function generates a specification for a specified PowerShell cmdlet. 
It retrieves the cmdlet's parameters and their details, and optionally returns the specification in hash or JSON format.

.PARAMETER CmdletName
The name of the cmdlet for which to generate the specification.

.PARAMETER Strict
If specified, the generated specification will not allow additional properties.

.PARAMETER ParameterSet
The ParameterSet to use. Defaults to 0. Iterate according to documentation.

.PARAMETER ReturnJson
If specified, the function returns the specification in JSON format.

.PARAMETER ClearRequired
If specified, the function will not mark mandatory parameters as required in the specification.

.EXAMPLE
Get-OAIFunctionCallSpec -CmdletName Get-Process -ReturnJson

This command generates a JSON specification for the Get-Process cmdlet.

#>

function Get-OAIFunctionCallSpec {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]
        $CmdletName,
        [switch]
        $Strict,
        [Parameter(HelpMessage = "The ParameterSet to use. Iterate according to documentation")]
        [int]
        $ParameterSet = 0,
        [switch]
        $ReturnJson,
        [switch]
        $ClearRequired
    )
    
    begin {
        $CommandInfo = try {Get-Command -Name $CmdletName -ErrorAction Stop} catch {$null}
        if ($null -eq $CommandInfo) {
            Write-Warning "$CmdletName not found!"
            return $null
        }
        if ($CommandInfo -is [System.Management.Automation.AliasInfo]) {
            Write-Verbose "$CmdletName is an alias for $($CommandInfo.ResolvedCommand.Name)"
            $CommandInfo = $CommandInfo.ResolvedCommand
        }
        if ($CommandInfo.ParameterSets.Count -lt $parameterset + 1) {
            Write-Error "ParameterSet $ParameterSet does not exist for $CmdletName. These ParameterSets are available: $($CommandInfo.ParameterSets.Name -join ', ')" -ErrorAction Stop
        }
        Write-Verbose "Preparing to generate specification for $CmdletName ParameterSet $($CommandInfo.ParameterSets[$ParameterSet].Name)"
    }
    
    process {
        # There are not going to be more then one - remove this loop
        foreach ($Command in $CommandInfo) {
            # FunctionSpec scaffold:
            Write-Verbose "Generating specification for $($Command.Name)"
            $help = Get-Help $Command.Name
            $description = $help.description.text | Out-String
            if ($description.Length -gt 1024) {
                $description = $description.Substring(0, 1024)
            }
            $FunctionSpec = [ordered]@{
                name        = $Command.Name
                description = $description
                parameters  = [ordered]@{
                    type       = 'object'
                    properties = [ordered]@{}
                    required   = [System.Collections.Generic.List[string]]@()
                }
            }

            if (!$help.description.text) {
                $FunctionSpec.Remove("description")
            }

            if ($Strict) {
                $FunctionSpec.parameters["additionalProperties"] = $false
                $FunctionSpec["strict"] = $true
            }
            $Parameters = $Command.ParameterSets[$ParameterSet].Parameters | Where-Object {
                $_.Name -notmatch 'Verbose|Debug|ErrorAction|WarningAction|InformationAction|ErrorVariable|WarningVariable|InformationVariable|OutVariable|OutBuffer|PipelineVariable|WhatIf|Confirm|NoHyperLinkConversion|ProgressAction'
            } | Select-Object Name, ParameterType, IsMandatory, HelpMessage, Attributes -Unique
            
            foreach ($Parameter in $Parameters) {
                $property = Get-ToolProperty $Parameter
                if ($null -eq $property) {
                    Write-Verbose "No type translation found for $($Parameter.Name). Type is $($Parameter.ParameterType)"
                    continue
                }
                try {
                    $ParameterDescription = Get-Help $Command.Name -Parameter $Parameter.Name -ErrorAction Stop |
                    Select-Object -ExpandProperty Description -ErrorAction Stop |
                    Select-Object -ExpandProperty Text -ErrorAction Stop | Out-String
                }
                catch { Write-Verbose "No description found for $($Parameter.Name)" }
                if ($ParameterDescription) {
                    $property['description'] = $ParameterDescription
                }
                if ($property) { $FunctionSpec.parameters.properties.Add($Parameter.Name, $property) }
                if ($Parameter.IsMandatory -and !$ClearRequired) {
                    $FunctionSpec.parameters.required.Add($Parameter.Name)
                }
            }

            $result = @{
                type     = 'function'
                function = $FunctionSpec
            }
            if ($ReturnJson) {
                return ($result | ConvertTo-Json -Depth 10)
            }
            $result
        }
    }
    
    end {
        
    }
}