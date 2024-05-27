<#
.SYNOPSIS
Converts a Unix timestamp to a DateTime object.

.DESCRIPTION
The ConvertFrom-UnixTimestamp function takes a Unix timestamp as input and converts it to a DateTime object. 
A Unix timestamp represents the number of seconds that have elapsed since January 1, 1970, 00:00:00 UTC.

.PARAMETER UnixTimestamp
The Unix timestamp to convert.

.EXAMPLE
ConvertFrom-UnixTimestamp -UnixTimestamp 1625097600

This example converts the Unix timestamp 1625097600 to a DateTime object.

.OUTPUTS
System.DateTime
The function returns a DateTime object representing the converted Unix timestamp.

#>
function ConvertFrom-UnixTimestamp {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [int]$UnixTimestamp
    )
    process {
        (Get-Date "1970-01-01").AddSeconds($UnixTimestamp)
    }
}
