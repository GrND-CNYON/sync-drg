$drives = Get-PSDrive | Where-Object {$_.Provider.Name -eq 'FileSystem'}

$steamSave = New-Object PSObject
Add-Member -InputObject $steamSave -MemberType NoteProperty -Name Store -Value "Steam"

$winStoreSave = New-Object PSObject
Add-Member -InputObject $winStoreSave -MemberType NoteProperty -Name Store -Value "Windows Store"

# Find steam save
foreach ($drive in $drives) {
    $steamLibrary = Get-ChildItem $drive.Root -Directory | Where-Object {$_.Name -eq 'SteamLibrary' -or $_.Name -eq 'Steam_Library'} | Select-Object -First 1

    if ($steamLibrary -ne $null -and (Test-Path -Path "$($steamLibrary.FullName)\steamapps\common\Deep Rock Galactic\FSD\Saved\SaveGames")) {
        $mostRecentSave = Get-ChildItem "$($steamLibrary.FullName)\steamapps\common\Deep Rock Galactic\FSD\Saved\SaveGames" | Where-Object {$_.Name.EndsWith('Player.sav')} | Sort-Object -Descending -Property LastWriteTimeUtc | Select-Object -First 1
        Add-Member -InputObject $steamSave -MemberType NoteProperty -Name FileInfo -Value $mostRecentSave
        break
    }
}

#Find Windows Store save
Invoke-Command -ScriptBlock {
    $windowsStoreSavePath = "$($env:APPDATA)\..\Local\Packages\CoffeeStainStudios.DeepRockGalactic_496a1srhmar9w\SystemAppData\wgs"

    $largeNumber1 = Get-ChildItem $windowsStoreSavePath -Directory | Sort-Object -Descending -Property {$_.Name.Length} | Select-Object -First 1
    $largeNumber2 = Get-ChildItem "$windowsStoreSavePath\$largeNumber1" -Directory | Sort-Object -Descending -Property {$_.Name.Length} | Select-Object -First 1
    $mostRecentSave = Get-ChildItem "$windowsStoreSavePath\$largeNumber1\$largeNumber2" | Where-Object {$_.Extension -eq ''} | Sort-Object -Descending -Property LastWriteTimeUtc | Select-Object -First 1
    Add-Member -InputObject $winStoreSave -MemberType NoteProperty -Name FileInfo -Value $mostRecentSave
}

if ($steamSave.FileInfo -eq $null) {
    Write-Host 'Apologies, miner. I could not find your Steam save.'
    Read-Host 'Press any key to close'
    Exit
}

if ($winStoreSave.FileInfo -eq $null) {
    Write-Host 'Apologies, miner. I could not find your Windows Store save. Perhaps try launching the (Windows Store) game first?'
    Read-Host 'Press any key to close'
    Exit
}

Write-Host "Greetings, miner. I discovered the following saves:"
$saves = $steamSave, $winStoreSave | Sort-Object -Descending -Property {$_.FileInfo.LastWriteTimeUtc}
$saves | Format-Table -AutoSize Store, @{Label="FileName"; Expression={$_.FileInfo.Name}}, @{Label="LastSaveTime"; Expression={$_.FileInfo.LastWriteTime}}, @{Label="Directory"; Expression={$_.FileInfo.DirectoryName}}

if ($steamSave.FileInfo.LastWriteTimeUtc -gt $winStoreSave.FileInfo.LastWriteTimeUtc) {
    $latestDirection = 'stm->win'
} else {
    $latestDirection = 'win->stm'
}

$commands = [PSCustomObject]@{
    Command="stm->win"
    Description="Transfer save from Steam to Windows Store"
}, [PSCustomObject]@{
    Command="win->stm"
    Description="Transfer save from Windows Store to Steam"
}, [PSCustomObject]@{
    Command="latest"
    Description="Transfer save that was most recently saved ($latestDirection)"
}, [PSCustomObject]@{
    Command="exit"
    Description="Close the window"
}

$commands | Format-Table Command, Description

$matchedCommand = $false
while (-not $matchedCommand) {
    $command = Read-Host 'Enter one command from above'
    if ($command -eq 'exit') {
        Exit
    } elseif ($commands | where {$_.Command -eq $command}) {
        $matchedCommand = $true
        break
    } else {
        Write-Host "Could not understand '$command' (is it Elvish?). Please try again."
    }
}

$sourc = $null
$dest = $null

if ($command -eq 'stm->win') {
    $source = $steamSave.FileInfo
    $dest = $winStoreSave.FileInfo
} elseif ($command -eq 'win->stm') {
    $source = $winStoreSave.FileInfo
    $dest = $steamSave.FileInfo
} else {
    $source = $saves[0].FileInfo
    $dest = $saves[1].FileInfo
}


Write-Host "You selected '$command'."

# Make back up of destination file
Write-Host "Making backup of $($dest.Name)..."
Copy-Item -Path $dest.FullName -Destination "$($dest.FullName).bak"
Write-Host "Backup created (.bak)"

Write-Host 'Transferring save...'
# Actual save transfer
Copy-Item -Path $source.FullName -Destination $dest.FullName
Write-Host 'Rock and stone! Transfer was successful.'
Read-Host 'Press any key to close'