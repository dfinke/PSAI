function Get-AIToolInfo {
    [CmdletBinding()]
    param (
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
        if ($CmdletName) {
            $CommandInfo = Get-Command -Name $CmdletName
            if ($CommandInfo.ParameterSets.Count -lt $parameterset+1) {
                Write-Error "ParameterSet $ParameterSet does not exist for $CmdletName. These ParameterSets are available: $($CommandInfo.ParameterSets.Name -join ', ')" -ErrorAction Stop
            }
            Write-Verbose "Preparing to generate specification for $CmdletName ParameterSet $($CommandInfo.ParameterSets[$ParameterSet].Name)"
        }
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
                $_.Name -notmatch 'Verbose|Debug|ErrorAction|WarningAction|InformationAction|ErrorVariable|WarningVariable|InformationVariable|OutVariable|OutBuffer|PipelineVariable|WhatIf|Confirm'
            } | Select-Object Name, ParameterType, IsMandatory, HelpMessage, Attributes -Unique
            
            foreach ($Parameter in $Parameters) {
                Write-Verbose "Processing parameter $($Parameter.Name)"
                $property = Get-ToolProperty $Parameter
                if ($property){$FunctionSpec.parameters.properties.Add($Parameter.Name, $property)}
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