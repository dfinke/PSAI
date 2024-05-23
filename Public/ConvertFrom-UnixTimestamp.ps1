function ConvertFrom-UnixTimestamp {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [int]$UnixTimestamp
    )
    process {
        (Get-Date "1970-01-01").AddSeconds($UnixTimestamp)
    }
}
