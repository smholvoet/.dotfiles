# ----------
# Chocolatey
# ----------

# Install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Show version
choco info
choco list -li

# Confirm future prompts automatically
choco feature enable -n allowGlobalConfirmation

# Show preinstalled apps
Get-AppxPackage -AllUsers | Select Name, PackageFullName, Version, NonRemovable, SignatureKind | Format-Table

# Uninstall Edge stable channel
$EdgeVersion = (Get-AppxPackage "Microsoft.MicrosoftEdge.Stable" -AllUsers).Version
$EdgeSetupPath = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)") + '\Microsoft\Edge\Application\' + $EdgeVersion + '\Installer\setup.exe'
& $EdgeSetupPath --uninstall --system-level --verbose-logging --force-uninstall

# Uninstall Windows Terminal, manage it through Chocolatey
Get-AppxPackage Microsoft.WindowsTerminal | Remove-AppPackage

# Install packages
choco install 7zip.install
choco install advanced-ip-scanner
choco install azure-cli
choco install cascadia-code-nerd-font
choco install choco-cleaner
choco install chocolateygui
choco install cpu-z
choco install crystaldiskinfo
choco install curl
choco install discord
choco install docker-desktop
choco install git
choco install google-drive-file-stream
choco install gpg4win
choco install greenshot
choco install icue
choco install microsoft-edge-insider-dev
choco install microsoft-windows-terminal
choco install nordvpn
choco install nvidia-display-driver
choco install postman
choco install powershell-core
choco install powertoys
choco install python3
choco install qbittorrent
choco install sonos-controller
choco install spotify
choco install sysinternals
choco install vlc
choco install vscode
choco install whatsapp
choco install windirstat

# Show installed packages
choco list -li


# ----------
# PowerShell
# ----------

# Install Package Management provider
Install-PackageProvider -Name NuGet -Force;

# Install modules
Install-Module -Name PSReadLine -Force;
Install-Module -Name Terminal-Icons -Force;
Install-Module -Name oh-my-posh -Force;
Install-Module -Name posh-git -Force;

# List installed modules
Get-Module

# -------
# VS Code
# -------

# Theme
code --install-extension ahmadawais.shades-of-purple
code --install-extension GitHub.github-vscode-theme

# Icons
code --install-extension vscode-icons-team.vscode-icons

# Extension (MS)
code --install-extension docsmsft.docs-markdown
code --install-extension docsmsft.docs-preview
code --install-extension ms-azuretools.vscode-azurefunctions
code --install-extension ms-azuretools.vscode-azureresourcegroups
code --install-extension ms-azuretools.vscode-bicep
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.vscode-dotnet-runtime
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension ms-vscode.azurecli
code --install-extension ms-vscode.powershell

# Extensions (custom)
code --install-extension CoenraadS.bracket-pair-colorizer-2
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension eamodio.gitlens
code --install-extension hediet.vscode-drawio
code --install-extension streetsidesoftware.code-spell-checker

# List extensions
code --list-extensions

# Show status
code --status


# ----------------------------------------------------------------------
# Sophia Installer (https://github.com/farag2/Sophia-Script-for-Windows)
# ----------------------------------------------------------------------

# Install
Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression

# Run
Set-Location -Path "~/Downloads/Sophia Script for Windows 11 v6.0.7"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
# !!! Comment out unnecessary stuff in Sophia.ps1
.\Sophia.ps1
