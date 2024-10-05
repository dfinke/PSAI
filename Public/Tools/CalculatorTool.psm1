<#
.SYNOPSIS
Provides a set of mathematical operations as tools.

.DESCRIPTION
The CalculatorTool module includes functions for various mathematical operations such as addition, subtraction, multiplication, division, exponentiation, factorial calculation, prime checking, and square root calculation. Each function returns the result in JSON format.

.FUNCTIONS
New-CalculatorTool
    Initializes and registers the CalculatorTool functions.

Invoke-Add
    Adds two floating-point numbers and returns the result in JSON format.

Invoke-Subtract
    Subtracts the second floating-point number from the first and returns the result in JSON format.

Invoke-Multiply
    Multiplies two floating-point numbers and returns the result in JSON format.

Invoke-Divide
    Divides the first floating-point number by the second and returns the result in JSON format. Handles division by zero.

Invoke-Exponentiate
    Raises the first floating-point number to the power of the second and returns the result in JSON format.

Invoke-Factorial
    Calculates the factorial of a non-negative integer and returns the result. Returns "NaN" for negative inputs.

Invoke-IsPrime
    Checks if an integer is a prime number and returns the result in JSON format.

Invoke-SquareRoot
    Calculates the square root of a non-negative floating-point number and returns the result in JSON format. Handles negative inputs.

.EXAMPLE
# Initialize the CalculatorTool
New-CalculatorTool

# Perform addition
Invoke-Add -a 5 -b 3

# Perform subtraction
Invoke-Subtract -a 10 -b 4

# Perform multiplication
Invoke-Multiply -a 6 -b 7

# Perform division
Invoke-Divide -a 20 -b 4

# Perform exponentiation
Invoke-Exponentiate -a 2 -b 3

# Calculate factorial
Invoke-Factorial -n 5

# Check if a number is prime
Invoke-IsPrime -n 11

# Calculate square root
Invoke-SquareRoot -n 16
#>
function New-CalculatorTool {
    [CmdletBinding()]
    param()

    Write-Verbose "New-CalculatorTool was called"
    Write-Verbose "Registering tools for CalculatorTool"
   
    Register-Tool Invoke-Add
    Register-Tool Invoke-Subtract
    Register-Tool Invoke-Multiply
    Register-Tool Invoke-Divide
    Register-Tool Invoke-Exponentiate
    Register-Tool Invoke-Factorial
    Register-Tool Invoke-IsPrime
    Register-Tool Invoke-SquareRoot
}

function Invoke-Add {
    [CmdletBinding()]
    param(
        [float] $a,
        [float] $b
    )

    $result = $a + $b
    Write-Host "Adding $a and $b to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'addition'; result = $result })
}

function Invoke-Subtract {
    [CmdletBinding()]
    param(
        [float] $a,
        [float] $b
    )

    $result = $a - $b
    Write-Host "Subtracting $b from $a to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'subtraction'; result = $result })
}

function Invoke-Multiply {
    [CmdletBinding()]
    param(
        [float] $a,
        [float] $b
    )

    $result = $a * $b
    Write-Host "Multiplying $a and $b to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'multiplication'; result = $result })
}

function Invoke-Divide {
    [CmdletBinding()]
    param(
        [float] $a,
        [float] $b
    )

    if ($b -eq 0) {
        Write-Host "Attempt to divide by zero"
        return (ConvertTo-Json -Compress -InputObject @{operation = 'division'; error = 'Division by zero is undefined' })
    }
    try {
        $result = $a / $b
    }
    catch {
        return (ConvertTo-Json -Compress -InputObject @{operation = 'division'; error = $_; result = 'Error' })
    }
    Write-Host "Dividing $a by $b to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'division'; result = $result })
}

function Invoke-Exponentiate {
    [CmdletBinding()]
    param(
        [float] $a,
        [float] $b
    )

    $result = [math]::Pow($a, $b)
    Write-Host "Raising $a to the power of $b to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'exponentiation'; result = $result })
}

function Invoke-Factorial {
    [CmdletBinding()]
    param(
        [bigint]$n
    )

    if ($n -ge 1) {
        return $n * (Invoke-Factorial ($n = $n - 1))
    }
    elseif ($n -eq 0) { 
        return 1 
    }
    else {
        Write-Host "Attempt to calculate factorial of a negative number"
        return "NaN"
    }
}

function Invoke-IsPrime {
    [CmdletBinding()]
    param(
        [int] $n
    )

    if ($n -le 1) {
        return (ConvertTo-Json -Compress -InputObject @{operation = 'prime_check'; result = $false })
    }
    for ($i = 2; $i -le [math]::Sqrt($n); $i++) {
        if ($n % $i -eq 0) {
            return (ConvertTo-Json -Compress -InputObject @{operation = 'prime_check'; result = $false })
        }
    }
    return (ConvertTo-Json -Compress -InputObject @{operation = 'prime_check'; result = $true })
}

function Invoke-SquareRoot {
    [CmdletBinding()]
    param(
        [float] $n
    )

    if ($n -lt 0) {
        Write-Host "Attempt to calculate square root of a negative number"
        return (ConvertTo-Json -Compress -InputObject @{operation = 'square_root'; error = 'Square root of a negative number is undefined' })
    }

    $result = [math]::Sqrt($n)
    Write-Host "Calculating square root of $n to get $result"
    return (ConvertTo-Json -Compress -InputObject @{operation = 'square_root'; result = $result })
}