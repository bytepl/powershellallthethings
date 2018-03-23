function Get-FolderSize {
    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Enter a path to the folder.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$path
    )

        if (!(Test-Path $path)) {

            throw [System.IO.FileNotFoundException] "Path $path not found."
        }

        if ($path.GetType().Name -eq "DirectoryInfo") {

            $path = $path.FullName
        }
        
        $robocopy = robocopy $path "c:\FakeTempDir" /e /l /r:1 /w:1 /nfl /ndl /nc /fp /bytes /np /njh
        [int]$folderSize = ($robocopy | Where-Object {$_ -match "Bytes"}).Trim().Split(":").Trim().Split(" ")[1]

        Return $folderSize
    }