cls

<#
    This script assums that you have installed the iCloud app version 14.2.108.0
    If you do not. Or are unsure the installed version. Simply open up the Microsoft store and search iCloud. 
#>

# iCloud Photo folder
$iCloud = "C:\Users\$env:USERNAME\iCloudPhotos\Photos"

# Lets make sure inventory is empty...
$inventory = $null

# USB things
# Lets find the USB drive we want to use... If you dont know the drive name, set it or find it and update $volumeName.... Comeone you can do this...
$volumeName = "Windows 10 1709"

# USB volume things
$diskVolume = Get-Volume | Where-Object {$_.FileSystemLabel -eq $volumeName}

# USB drive letter things
$photoRoot = ($diskVolume.DriveLetter)+":\$env:USERNAME"+" iPhotos"


# folder to store the photos and videos
$checkPhotoFolder = Test-Path -Path $photoRoot

# Check to see if the destination folder exists on the USB drive. 
If($checkPhotoFolder -eq $false) {
    
    # Make new folder, if it does not exist. 
    New-Item -Path $photoRoot -ItemType Directory #-WhatIf

}

# get an enventory of your iCloud Photos
$inventory = Get-ChildItem -Path $iCloud

# OK, now check to see if any of your iCloud photos are on your USB drive, if not, then copy the missing files. 
Foreach ($i in $inventory) {
    
    # check to see if the current file exists on the USB drive
    $checkFile = Test-Path -Path $photoRoot\$i

    # if the file does not exist, then 
    if ($checkFile -eq $false) {
        
        # Copy the file over NOW!!!
        Copy-Item -Path $iCloud\$i -Destination $photoRoot -Force -Verbose -Confirm:$false #-WhatIf

    }

}
