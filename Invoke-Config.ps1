# -----------
# Fetch files
# -----------
Set-Location -Path "~\repos\github"
git clone https://github.com/smholvoet/.dotfiles.git
Set-Location -Path "~\repos\github\.dotfiles"

# ---------------------------------------------------
# Nerd Fonts | https://www.nerdfonts.com
# replaced by 'choco install cascadia-code-nerd-font'
# ---------------------------------------------------

# $NFUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip'
# $NFZipFile = 'nerd-fonts.zip'
# $NFDir = 'nerd-fonts'
# $NFTempFolder  = 'C:\Windows\Temp\Fonts'
# $NFDestination = (New-Object -ComObject Shell.Application).Namespace(0x14)

# Invoke-WebRequest -Uri $NFUrl -Outfile $NFZipFile
# Expand-Archive -Path $NFZipFile -DestinationPath $NFDir
# New-Item $NFTempFolder -Type Directory -Force | Out-Null

# Get-ChildItem -Path $NFDir -Recurse | ForEach {
#     If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
#         Write-Host "Installing $($_.Name)"
#         $Font = "$NFTempFolder\$($_.Name)"
#         Copy-Item $($_.FullName) -Destination $NFTempFolder -Verbose     
#         $NFDestination.CopyHere($Font,0x10)
#         Start-Sleep -s 15
#         Remove-Item $Font -Force -Verbose
#     }
# }

# Remove-Item $NFZipFile -Force -Verbose
# Remove-Item $NFDir -Recurse -Force -Verbose 

# ---------------------------------
# oh-my-posh | https://ohmyposh.dev
# ---------------------------------
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
Write-Host "Windows Terminal location: $($WindowsTerminalDir)" 

$WindowsTerminalSettings = "windows-terminal\settings.json"
Copy-Item $WindowsTerminalSettings -Destination $WindowsTerminalDir -Force -Verbose


# -------
# VS Code
# -------
$VSCodeDir = Join-Path -Path $env:APPDATA -ChildPath "\Code\User"
Write-Host "VS Code location: $($VSCodeDir)" 

$VSCodeSettings = "vscode\settings.json"
$VSCodePsProfile = "vscode\Microsoft.VSCode_profile.ps1"
Copy-Item $VSCodeSettings -Destination $VSCodeDir -Force -Verbose
Copy-Item $VSCodePsProfile -Destination $VSCodeDir -Force -Verbose


# ----------------------------------------------------------------------
# Sophia Installer | https://github.com/farag2/Sophia-Script-for-Windows
# ----------------------------------------------------------------------

Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression

$SophiaDir = "~/Downloads/Sophia Script for Windows 11 v6.0.7"
$SophiaCustom = "sophia\Sophia_custom.ps1"

Copy-Item $SophiaCustom -Destination $SophiaDir -Force -Verbose
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Set-Location -Path $SophiaDir
.\Sophia_custom.ps1
