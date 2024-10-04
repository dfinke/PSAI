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

    # if ($n -lt 0) {
    #     Write-Host "Attempt to calculate factorial of a negative number"
    #     return (ConvertTo-Json -Compress -InputObject @{operation = 'factorial'; error = 'Factorial of a negative number is undefined' })
    # }
    # $result = [math]::Factorial($n)
    # Write-Host "Calculating factorial of $n to get $result"
    # return (ConvertTo-Json -Compress -InputObject @{operation = 'factorial'; result = $result })
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