# ----------
# Variables
# ----------

# Chocolatey packages
$ChocoPackages = @(         '7zip.install',
                            'advanced-ipscanner',
                            'azure-cli',
                            'bind-toolsonly',
                            'cascadia-code-nerd-font',
                            'choco-cleaner',
                            'chocolateygui',
                            'cpu-z',
                            'crystaldiskinfo',
                            'curl',
                            'discord',
                            'docker-desktop',
                            'etcher',
                            'gimp',
                            'git',
                            'google-drive-file-stream',
                            'gpg4win',
                            'greenshot',
                            'gsudo',
                            'icue',
                            'microsoft-edge-insider-dev',
                            'microsoft-windows-terminal',
                            'nordvpn',
                            'nvidia-display-driver',
                            'postman',
                            'powershell-core',
                            'powertoys',
                            'python3',
                            'qbittorrent',
                            'rpi-imager',
                            'sonos-controller',
                            'streamdeck',
                            'spotify',
                            'sysinternals',
                            'vlc',
                            'vscode',
                            'whatsapp',
                            'windirstat')

# PowerShell modules
$PwshModules = @(           'PSReadLine',
                            'Terminal-Icons',
                            'oh-my-posh',
                            'posh-git')

# VS Code extensions
$VsCodeThemes = @(          'GitHub.github-vscode-theme')

$VsCodeIcons = @(           'vscode-icons-team.vscode-icons')

$VsCodeExtensionsMs = @(    'docsmsft.docs-markdown',
                            'docsmsft.docs-preview',
                            'ms-azuretools.vscode-azurefunctions',
                            'ms-azuretools.vscode-azureresourcegroups',
                            'ms-azuretools.vscode-bicep',
                            'ms-azuretools.vscode-docker',
                            'ms-dotnettools.csharp',
                            'ms-dotnettools.vscode-dotnet-runtime',
                            'ms-vscode-remote.remote-containers',
                            'ms-vscode-remote.remote-ssh',
                            'ms-vscode-remote.remote-ssh-edit',
                            'ms-vscode-remote.remote-wsl',
                            'ms-vscode-remote.vscode-remote-extensionpack',
                            'ms-vscode.azurecli',
                            'ms-vscode.powershell')

$VsCodeExtensionsCustom = @('DavidAnson.vscode-markdownlint',
                            'eamodio.gitlens',
                            'hediet.vscode-drawio',
                            'streetsidesoftware.code-spell-checker')

         
# ----------
# Chocolatey
# ----------

# Install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Show version
choco info
choco list -li

# Confirm future prompts automatically
choco feature enable -n allowGlobalConfirmation

# Show preinstalled apps
Get-AppxPackage -AllUsers | Select-Object Name, PackageFullName, Version, NonRemovable, SignatureKind | Format-Table

# Uninstall Edge stable channel
$EdgeVersion = (Get-AppxPackage "Microsoft.MicrosoftEdge.Stable" -AllUsers).Version
$EdgeSetupPath = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)") + '\Microsoft\Edge\Application\' + $EdgeVersion + '\Installer\setup.exe'
& $EdgeSetupPath --uninstall --system-level --verbose-logging --force-uninstall

# Uninstall Windows Terminal, manage it through Chocolatey
Get-AppxPackage Microsoft.WindowsTerminal | Remove-AppPackage

# Install choco packages
$ChocoPackages | ForEach-Object { choco install $_ }

# Show installed packages
choco list -li


# -------
# VS Code
# -------

# Theme
$VsCodeThemes | ForEach-Object { code --install-extension $_ }

# Icons
$VsCodeIcons | ForEach-Object { code --install-extension $_ }

# Extension (MS)
$VsCodeExtensionsMs | ForEach-Object { code --install-extension $_ }

# Extensions (custom)
$VsCodeExtensionsCustom | ForEach-Object { code --install-extension $_ }

# List extensions
code --list-extensions

# Show status
code --status


# ----------
# PowerShell
# ----------

# Install Package Management provider
Install-PackageProvider -Name NuGet -Force;

# Install modules
$PwshModules | ForEach-Object { Install-Module -Name $_ -Force -Verbose }

# Import modules
$PwshModules | ForEach-Object { Import-Module -Name $_  -Force -Verbose }

# List installed modules
Get-Module
