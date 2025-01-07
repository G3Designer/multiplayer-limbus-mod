function Read-InputFromHost {
    Param (
            [Parameter(Mandatory=$true)][String]$Title,
            [Parameter(Mandatory=$true)][String]$Message,
            [Parameter(Mandatory=$false)][Int]$DefaultOption = 0
        )
        
        $Disable = New-Object System.Management.Automation.Host.ChoiceDescription '&Disable', 'd'
        $Enable = New-Object System.Management.Automation.Host.ChoiceDescription '&enable', 'e'
        $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Disable, $Enable)
        
        return $host.ui.PromptForChoice($Title, $Message, $Options, $DefaultOption)
}

$choice = Read-InputFromHost -Title "Disable or enable mods for Limbus Company?" -Message "[d for disable, e for enable - default is disable]"
$winhttp_exist = Test-Path -Path "./winhttp.dll"
$modsoff_exist = Test-Path -Path "./mods_off.dll"
$mods_not_installed = $winhttp_exist -and $modsoff_exist

if ($choice -eq '1') {
    Write-Output "Enabling Limbus Company mods stored in the BepInEx/plugins folder.."
    if ($mods_not_installed) { Write-Output "Warning: winhttp.dll and mods_off.dll do not exist - you may not have BepInEx installed or may need to reinstall it. Mods cannot be enabled."; Start-Sleep -Seconds 5; exit $code }
    if (-not $modsoff_exist) { Write-Output "Mods are already enabled~ ^-^"; Start-Sleep -Seconds 5; exit $code }
    Rename-Item -Path "./mods_off.dll" -NewName "winhttp.dll" 
    Write-Output "Limbus Company mods have been enabled~ ^-^*"
} 

else {
    Write-Output "Disabling Limbus Company mods.."
    if ($mods_installed) { Write-Output "Warning: winhttp.dll does not exist - you may not have BepInEx installed or may need to reinstall it. Mods are already disabled."; Start-Sleep -Seconds 5; exit $code }
    if (-not $winhttp_exist) { Write-Output "Mods are already disabled :3"; Start-Sleep -Seconds 5; exit $code }
    Rename-Item -Path "./winhttp.dll" -NewName "mods_off.dll"
    Write-Output "Limbus Company mods have been disabled :3"
}
Read-Host -Prompt "Press Enter to exit.."