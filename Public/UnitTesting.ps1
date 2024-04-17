<#
.SYNOPSIS
Enables unit testing.

.DESCRIPTION
The Enable-UnitTesting function sets the $EnableUnitTesting variable to $true, enabling unit testing.

.EXAMPLE
Enable-UnitTesting

This example enables unit testing by setting the $EnableUnitTesting variable to $true.
#>
function Enable-UnitTesting {
    $script:EnableUnitTesting = $true
}

<#
.SYNOPSIS
Disables unit testing.

.DESCRIPTION
The Disable-UnitTesting function sets the $EnableUnitTesting variable to $false, disabling unit testing.

.EXAMPLE
Disable-UnitTesting

This example disables unit testing by setting the $EnableUnitTesting variable to $false.
#>
function Disable-UnitTesting {
    $script:EnableUnitTesting = $false
}

<#
.SYNOPSIS
Gets the status of unit testing.

.DESCRIPTION
The Get-UnitTestingStatus function returns the current value of the $EnableUnitTesting variable, indicating whether unit testing is enabled or disabled.

.EXAMPLE
Get-UnitTestingStatus

This example retrieves the current status of unit testing.

.OUTPUTS
System.Boolean
#>

function Get-UnitTestingStatus {
    $script:EnableUnitTesting
}

<#
.SYNOPSIS
Tests if unit testing is enabled.

.DESCRIPTION
The Test-IsUnitTestingEnabled function returns the current value of the $EnableUnitTesting variable, indicating whether unit testing is enabled or disabled.

.EXAMPLE
Test-IsUnitTestingEnabled

This example tests if unit testing is enabled.

.OUTPUTS
System.Boolean
#>
function Test-IsUnitTestingEnabled {
    $script:EnableUnitTesting
}

function Get-UnitTestingData {
    $script:InvokeOAIUnitTestingData
}