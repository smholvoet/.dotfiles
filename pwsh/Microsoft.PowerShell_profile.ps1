# Variables
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$CheckMark = "✅"
$Timer = "⏱️"

# Show PS version
Write-Host "Loading PowerShell $($PSVersionTable.PSVersion)...`t$CheckMark"

# Import modules
Write-Host "Loading oh-my-posh...`t`t$CheckMark"
Import-Module -Name oh-my-posh
Write-Host "Loading Terminal-Icons...`t$CheckMark"
Import-Module -Name Terminal-Icons
Write-Host "Loading PSReadLine...`t`t$CheckMark"
Import-Module -Name PSReadLine

# Set oh-my-posh theme
Set-PoshPrompt -Theme sander

# Aliases and functions
Set-Alias grep findstr
New-Alias -Name cal -Value Show-Calendar -Force

function repo { Set-Location "~\repos" }
function home { Set-Location "~" }
function open { explorer . }
function google { Start-Process "https://www.google.com/" }

# PSReadLine options
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows

# Install-Module defaults
$PSDefaultParameterValues["Install-Module:Scope"] = "CurrentUser"
$PSDefaultParameterValues["Install-Module:Repository"] = "PSGallery"
$PSDefaultParameterValues["Install-Module:SkipDependencies"] = $true
$PSDefaultParameterValues["Install-Module:SkipPublisherCheck"] = $true
$PSDefaultParameterValues["Install-Module:Confirm"] = $false

# Cmdlets
function Show-Calendar {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [int]
        $Month = (Get-Date).Month,

        [Parameter(Position = 1)]
        [int]
        $Year = (Get-Date).Year,

        [Parameter()]
        [switch]
        $AsObject
    )

    $fgB = "`e[30m"
    $bgW = "`e[47m"
    $N = "`e[0m"

    $beginningOfMonth = Get-Date -Year $Year -Month $Month -Day 1
    $monthName = $beginningOfMonth.ToString("MMMM")
    $yearString = $beginningOfMonth.ToString("yyyy")
    $currentMonth = $beginningOfMonth.Month
    $currentDay = $beginningOfMonth
    $monthObject = while ($currentDay.Month -eq $currentMonth) {
        $currentDay
        try {
            $currentDay = Get-Date -Year $Year -Month $Month -Day ($currentDay.Day + 1)
        }
        catch {
            break
        }
    }

    if ($AsObject) {
        return $monthObject
    }

    $title = "$monthName $yearString"
    $sp = [Math]::Floor((21 - $monthName.Length - 5) / 2)

    $title.PadLeft((21 - $sp), ' ')
    "Su Mo Tu We Th Fr Sa"
    $line = ''
    foreach ($day in $monthObject) {
        $dayValue = $day.DayOfWeek.value__

        if ($day.Day -eq 1) {
            $line += ' ' * ($dayValue * 3)
        }

        if ($day.Date -eq (Get-Date).Date) {
            $line += $fgB + $bgW
        }

        $line += $day.Day.ToString().PadLeft(2)

        if ($day.Date -eq (Get-Date).Date) {
            $line += $N
        }

        if ($dayValue -eq 6) {
            $line += [Environment]::NewLine
        }
        else {
            $line += ' '
        }
    }

    if ($line[-1..-2] -notcontains "`n") {
        $line += [Environment]::NewLine
    }

    $line
}

Write-Host "`nProfile loaded in $($stopwatch.Elapsed.TotalMilliseconds) ms`t$Timer`n"