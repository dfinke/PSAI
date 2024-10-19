function New-RAGLibrary {
    [CmdletBinding()]
    param (
        [Parameter (
        Mandatory,
        HelpMessage ='The directory to save the RAG library to. Files in subfolders will be included. Subfolder names will be used to describe the content type of the files in RAG.'
        )]
        [System.IO.DirectoryInfo]
        $Directory,
        $Model = $(Get-AIModel)
    )
    
    begin {
        $Files = Get-ChildItem -Path $Directory -Recurse
    }
    
    process {
        $VectorStore = $Model.InvokeModel('',$true, @{name='RAGLibrary'}, @(),'/vector_stores')
    }
    
    end {
        
    }
}