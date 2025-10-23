<#
.SYNOPSIS
Date and time toolbox for PSAI agents.

.DESCRIPTION
Provides date and time operations as tools for AI agents.
Tools include: getting current time, formatting dates, calculating date differences.

.NOTES
This toolbox is automatically discovered when $env:PSAI_TOOLBOX_PATH is set
or when using the default toolbox path.
#>

<#
.SYNOPSIS
Gets the current date and time.

.DESCRIPTION
Returns the current date and time in various formats.

.PARAMETER Format
The format to return: ISO8601, Unix, Readable, or All (default).

.PARAMETER TimeZone
Optional timezone name (e.g., "UTC", "Eastern Standard Time").

.EXAMPLE
Get-CurrentDateTime -Format ISO8601
Returns current time in ISO8601 format.
#>
function Global:Get-CurrentDateTime {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('ISO8601', 'Unix', 'Readable', 'All')]
        [string]$Format = 'All',
        
        [Parameter()]
        [string]$TimeZone
    )
    
    try {
        $now = Get-Date
        
        if ($TimeZone) {
            try {
                $tz = [System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZone)
                $now = [System.TimeZoneInfo]::ConvertTime($now, $tz)
            }
            catch {
                Write-Warning "Invalid timezone: $TimeZone, using local time"
            }
        }
        
        $result = @{
            requested_format = $Format
            timezone = if ($TimeZone) { $TimeZone } else { 'Local' }
        }
        
        switch ($Format) {
            'ISO8601' {
                $result['datetime'] = $now.ToString("o")
            }
            'Unix' {
                $result['datetime'] = [int][double]::Parse(($now.ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds)
            }
            'Readable' {
                $result['datetime'] = $now.ToString("yyyy-MM-dd HH:mm:ss")
            }
            'All' {
                $result['iso8601'] = $now.ToString("o")
                $result['unix'] = [int][double]::Parse(($now.ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds)
                $result['readable'] = $now.ToString("yyyy-MM-dd HH:mm:ss")
                $result['day_of_week'] = $now.DayOfWeek.ToString()
            }
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Formats a date/time string.

.DESCRIPTION
Converts a date/time string from one format to another.

.PARAMETER DateTime
The date/time to format (string or DateTime object).

.PARAMETER OutputFormat
The desired output format.

.EXAMPLE
Format-DateTime -DateTime "2025-01-01" -OutputFormat "yyyy-MM-dd HH:mm:ss"
Formats the date in the specified format.
#>
function Global:Format-DateTime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DateTime,
        
        [Parameter()]
        [string]$OutputFormat = "yyyy-MM-dd HH:mm:ss"
    )
    
    try {
        $dt = [DateTime]::Parse($DateTime)
        
        $result = @{
            input = $DateTime
            output_format = $OutputFormat
            formatted = $dt.ToString($OutputFormat)
            day_of_week = $dt.DayOfWeek.ToString()
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            input = $DateTime
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Calculates the difference between two dates.

.DESCRIPTION
Returns the time span between two dates in various units.

.PARAMETER StartDate
The start date/time.

.PARAMETER EndDate
The end date/time (defaults to now if not specified).

.PARAMETER Unit
The unit to return: Days, Hours, Minutes, Seconds, or All (default).

.EXAMPLE
Get-DateDifference -StartDate "2025-01-01" -Unit Days
Returns the number of days between the start date and now.
#>
function Global:Get-DateDifference {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$StartDate,
        
        [Parameter()]
        [string]$EndDate,
        
        [Parameter()]
        [ValidateSet('Days', 'Hours', 'Minutes', 'Seconds', 'All')]
        [string]$Unit = 'All'
    )
    
    try {
        $start = [DateTime]::Parse($StartDate)
        $end = if ($EndDate) { [DateTime]::Parse($EndDate) } else { Get-Date }
        
        $diff = $end - $start
        
        $result = @{
            start_date = $start.ToString("o")
            end_date = $end.ToString("o")
            unit = $Unit
        }
        
        switch ($Unit) {
            'Days' { $result['difference'] = $diff.TotalDays }
            'Hours' { $result['difference'] = $diff.TotalHours }
            'Minutes' { $result['difference'] = $diff.TotalMinutes }
            'Seconds' { $result['difference'] = $diff.TotalSeconds }
            'All' {
                $result['days'] = $diff.TotalDays
                $result['hours'] = $diff.TotalHours
                $result['minutes'] = $diff.TotalMinutes
                $result['seconds'] = $diff.TotalSeconds
                $result['readable'] = "$($diff.Days) days, $($diff.Hours) hours, $($diff.Minutes) minutes"
            }
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            start_date = $StartDate
            end_date = $EndDate
        } | ConvertTo-Json -Compress)
    }
}

# Registration function - called by Get-PSAIToolbox
function DateTimeTools {
    [CmdletBinding()]
    param()
    
    # Check if we should register tools based on environment variable
    if ($env:PSAI_ENABLE_TOOLBOX -eq $false) {
        Write-Verbose "Toolbox registration skipped (PSAI_ENABLE_TOOLBOX is false)"
        return @()
    }
    
    Write-Verbose "Registering DateTime toolbox tools"
    
    # Register the tools using PSAI's Register-Tool function
    $tools = @(
        Register-Tool -FunctionName Get-CurrentDateTime
        Register-Tool -FunctionName Format-DateTime
        Register-Tool -FunctionName Get-DateDifference
    )
    
    return $tools
}
