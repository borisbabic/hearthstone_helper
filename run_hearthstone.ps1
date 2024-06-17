$bnetPath="C:\\Program Files (x86)\\Battle.net\\Battle.net.exe"
$optionsPath="C:\\Users\\boris\\AppData\\Local\\Blizzard\\Hearthstone\\options.txt"
$overwolfPath="C:\\Program Files (x86)\\Overwolf\\OverwolfLauncher.exe"
# I think this is constant across installs, dunno, it might not be
$firestoneId="lnknbakkpommmjjdnelmfbjjdbocfpnpbkijjnob"
function Update-Options
{
    ((Get-Content $optionsPath) -replace 'targetframerate=\d+','targetframerate=0') | Set-Content $optionsPath
}
function Run-Firestone 
{
    if (!(Get-Process Firestone))  {
        Write-Host "Starting Firestone"
        .$overwolfPath -launchapp $firestoneId -startmenu
    } else {
        Write-Host "Firestone already running"
    }
}
if (Get-Process Hearthstone) {
    Write-Host "Hearthstone already running"
    Update-Options
    Run-Firestone
} else {
    if (!(Get-Process Battle.net)) {
        Write-Host "Can't find bnet"
        Update-Options
        .$bnetPath
    } 
    Run-Firestone
    while (!(Get-Process Hearthstone)) {
        Write-Host "Launching Hearthstone"
        Update-Options
        .$bnetPath --exec="launch WTCG"
        Start-Sleep 1
    }
}