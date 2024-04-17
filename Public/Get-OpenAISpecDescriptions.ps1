function Get-OpenAISpecDescriptions {
    [CmdletBinding()]
    param(        
        $target
    )

    if ($null -eq $target) {
        Write-Warning "Empty. Could not find any descriptions."
        return
    }

    $pattern = '(?s)(?<=<#)(.*?)(?=#>)'

    $targetMatches = [regex]::Matches($target, $pattern)

    $r = $targetMatches[0].Value -split "`n" | ForEach-Object { $_.Trim() } 

    $result = @{
        FunctionDescription  = $null
        ParameterDescription = @{}
    }

    for ($idx = 0; $idx -lt $r.Count; $idx++) {
        $item = $r[$idx]
        if ($item) {        
            if ($item -match '^\.FUNCTIONDESCRIPTION') {
                $result.FunctionDescription = $r[$idx + 1]
            }
            elseif ($item -match '^\.PARAMETERDESCRIPTION') {
                $kw, $name = $item -split ' '                
                $result.ParameterDescription.$name = $ExecutionContext.InvokeCommand.ExpandString($r[$idx + 1])
            }
        }
    }

    $result
}