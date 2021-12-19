# ⚙ .dotfiles

## Steps

### ✅ Installation

Open `Invoke-Install.ps1` in an elevated [PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/introducing-the-windows-powershell-ise) prompt and run the required sections.

By default, this script will:

- [Uninstall Microsoft Edge (Stable channel)](https://www.sanderh.dev/remove-Microsoft-Edge-PowerShell/) and Windows Terminal. These will be reinstalled via Chocolatey
- Install [Chocolatey](https://chocolatey.org/), along with all packages defined in `$ChocoPackages`
- Install [Visual Studio Code](https://code.visualstudio.com/) along with all extensions defined in the following variables:

  - `$VsCodeThemes`: Themes
  - `$VsCodeIcons`: Icons
  - `$VsCodeExtensionsCustom`: Custom extensions
  - `$VsCodeExtensionsMs`: Microsoft extensions

- Install the NuGet [package provider](https://docs.microsoft.com/en-us/powershell/module/packagemanagement/install-packageprovider) for PowerShell
- Install all PowerShell modules defined in `$PwshModules` and list them after installation

### ✅ Configuration

Open `Invoke-Config.ps1` in VS Code and run the required sections using the integrated terminal. 

By default, this script will:

- Clone this repo in `~\repos\github`
- Configure [oh-my-posh](https://ohmyposh.dev/) to use a custom theme, defined in `oh-my-posh\sander.omp.json`
- Load my [PowerShell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles), defined in `pwsh\Microsoft.PowerShell_profile.ps1`
- Load my Windows Terminal settings, defined in `windows-terminal\settings.json`
- Load my VS Code settings, defined in `vscode\settings.json`
- Run [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows) with a custom configuration, defined in `sophia\Sophia_custom.ps1`

### ✅ Updates

Run `Invoke-Update.ps1` manually or create a [scheduled task](https://www.technipages.com/scheduled-task-windows). This script will update:

- All Chocolatey packages
- All PowerShell modules
