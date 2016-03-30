Function Read-FolderSize {
    <#
    .SYNOPSIS
        Read the size of folders
 
    .DESCRIPTION
        Read the size of folders

    .PARAMETER Folder
        Specifies the root folder

    .PARAMETER subFolders
        Read the size of the subfolders
        Default value is true
 
    .EXAMPLE
         Read-FolderSize -Folder 'C:\Read\This Folder'

    .EXAMPLE
         Read-FolderSize -Folder 'C:\Read\This Folder\Without Sub Folders' -subFolders $false

    .INPUTS
        String
 
    .OUTPUTS
        Custom Object with the folder name and the size in MB and GB
 
    .NOTES
        Author:  Wouter de Dood
        Website: 
        Twitter: @WMouter
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Folder,

        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$subFolders = $true
    )
    Begin {
    }
    Process {
        Try {
            $ErrorActionPreference = "Stop"
            $folderSize            = ((Get-ChildItem $Folder -Recurse | Measure-Object -Property Length -Sum).Sum)
            [pscustomobject]@{
                Folder = "$Folder"
                SizeMb = "{0:N2}" -f ($folderSize / 1MB)
                SizeGb = "{0:N2}" -f ($folderSize / 1GB)
            }
            if ($subFolders -eq $true) {
                $colItems = (Get-ChildItem $Folder -Recurse | Where-Object {$_.PSIsContainer -eq $True} | Sort-Object)
                foreach ($i in $colItems) {
                    $subFolderSize = ((Get-ChildItem $($i.FullName) -Recurse | where { $_.Length > 0 } | Measure-Object -Property Length -Sum).Sum)
                    [pscustomobject]@{
                        Folder = "$($i.FullName)"
                        SizeMb = "{0:N2}" -f ($subFolderSize / 1MB)
                        SizeGb = "{0:N2}" -f ($subFolderSize / 1GB)
                    }
                }
            }
        }
        Catch {
            Write-Output $_.Exception.Message
        }
    }
    End {
        Remove-Variable subFolderSize, colItems, Folder, folderSize, subFolders
    }
} #end Function Read-FolderSize