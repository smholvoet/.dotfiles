# -----------
# Fetch files
# -----------
Set-Location -Path "~\repos\github"
git clone https://github.com/smholvoet/.dotfiles.git
Set-Location -Path "~\repos\github\.dotfiles"


# ----------
# oh-my-posh
# ----------
$OMPModuleDir = (Get-Module oh-my-posh).Path
Write-Host "oh-my-posh Module location: $($OMPModuleDir)" 

$OMPThemesDir = Join-Path -Path (Split-Path -Path $OMPModuleDir -Parent) -ChildPath "\themes"
Write-Host "oh-my-posh Themes location: $($OMPThemesDir)" 

$CustomTheme = "oh-my-posh\sander.omp.json" 
Copy-Item $CustomTheme -Destination $OMPThemesDir -Force -Verbose
Set-PoshPrompt -Theme sander


# ------------------
# PowerShell profile
# ------------------
$PSProfileDir = Split-Path -Path $PROFILE -Parent
Write-Host "PowerShell PSPROFILE location: $($PSProfileDir)" 

$PSProfile = "pwsh\Microsoft.PowerShell_profile.ps1"
Copy-Item $PSProfile -Destination $PSProfileDir -Force -Verbose


# ----------------
# Windows Terminal
# ----------------
$WindowsTerminalDir = Join-Path -Path $env:LocalAppData -ChildPath "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Write-Host "VS Code location: $($WindowsTerminalDir)" 

$WindowsTerminalSettings = "windows-terminal\settings.json"
Copy-Item $WindowsTerminalSettings -Destination $WindowsTerminalDir -Force -Verbose


# -------
# VS Code
# -------
$VSCodeDir = Join-Path -Path $env:APPDATA -ChildPath "\Roaming\Code\User"
Write-Host "VS Code location: $($VSCodeDir)" 

$VSCodeSettings = "vscode\settings.json"
$VSCodePsProfile = "vscode\Microsoft.VSCode_profile.ps1"
Copy-Item $VSCodeSettings $VSCodePsProfile -Destination $VSCodeDir -Force -Verbose