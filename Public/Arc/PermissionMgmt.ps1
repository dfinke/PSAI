Clear-Host

$corePermissions = [System.Collections.Generic.HashSet[string]]::new()
$tempPermissions = [System.Collections.Generic.HashSet[string]]::new()

function Add-Permission {
    param (
        [string]$permission
    )
    
    $permission -split ",\s*" | ForEach-Object {
        $null = $corePermissions.Add($_)
    }
}

function Add-TempPermission {
    param (
        [string]$permission
    )
    
    $permission -split ",\s*" | ForEach-Object {
        $null = $tempPermissions.Add($_)
    }
}

$tempPermissions.Clear()

Add-Permission -permission "get-content,git status, get-childitem:*"

Add-TempPermission "invoke-webrequest:*,select-string:*,measure-object"
Add-TempPermission "get-date -format:*"

$tempPermissions.Clear()

Add-TempPermission "gh PR view:*"
Add-TempPermission "git commit:*"

$currentPermissions = $corePermissions + $tempPermissions
$currentPermissions
