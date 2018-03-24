<#
.SYNOPSIS
Retrieves the size of the folder.
.DESCRIPTION
The Get-FolderSize function retrieves size of the given folder and all the subfolders within it.
.PARAMETER path
Path to the folder. This parameter is mandatory.
.EXAMPLE
Get-FolderSize C:/Example
Gets the size of the C:/Example folder.
.NOTES
For the function to work, Robocopy must be installed in one of the directories included in PATH enviromental variable. This tool is a part of standard OS installation beginning with Windows Vista and Windows Server 2008.
#>
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