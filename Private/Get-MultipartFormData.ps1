function Get-MultipartFormData {
    param (
        [Parameter(Mandatory)]
        $FilePath,
        [Parameter(Mandatory)]
        [ValidateSet('fine-tune', 'assistants', 'vision')]        
        $Purpose 
    )

    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = [System.Environment]::NewLine
    $encoding = [System.Text.Encoding]::UTF8
    $stream = [IO.MemoryStream]::new()

    # Write start boundary
    $bytes = $encoding.GetBytes("--$boundary$LF")
    $stream.Write($bytes, 0, $bytes.Length)

    # Write purpose part
    $bytes = $encoding.GetBytes("Content-Disposition: form-data; name=`"purpose`"$LF$LF$Purpose$LF")
    $stream.Write($bytes, 0, $bytes.Length)

    # Write separator boundary
    $bytes = $encoding.GetBytes("--$boundary$LF")
    $stream.Write($bytes, 0, $bytes.Length)

    $FileName = Split-Path -Leaf $FilePath
    # Write file part    
    $bytes = $encoding.GetBytes("Content-Disposition: form-data; name=`"file`"; filename=`"$FileName`"$LF")
    $stream.Write($bytes, 0, $bytes.Length)
    $bytes = $encoding.GetBytes("Content-Type: application/octet-stream$LF$LF")
    $stream.Write($bytes, 0, $bytes.Length)
    $fileBytes = [IO.File]::ReadAllBytes($FilePath)
    $stream.Write($fileBytes, 0, $fileBytes.Length)
    $bytes = $encoding.GetBytes($LF)
    $stream.Write($bytes, 0, $bytes.Length)

    # Write end boundary
    $bytes = $encoding.GetBytes("--$boundary--$LF")
    $stream.Write($bytes, 0, $bytes.Length)
    
    # Reset stream position to start
    $stream.Position = 0
    
    @{ 
        'Stream'      = $stream
        'ContentType' = "multipart/form-data; boundary=$boundary"
    }
}