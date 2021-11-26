<#
	.SYNOPSIS
	Default preset file for "Sophia Script for Windows 11"

	Version: v6.0.7
	Date: 23.11.2021

	Copyright (c) 2014—2021 farag
	Copyright (c) 2019—2021 farag & Inestic

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Place the "#" char before function if you don't want to run it
	Remove the "#" char before function if you want to run it
	Every tweak in the preset file has its' corresponding function to restore the default settings

	.EXAMPLE Run the whole script
	.\Sophia.ps1

	.EXAMPLE Run the script by specifying the module functions as an argument
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.EXAMPLE Download and expand the latest Sophia Script version archive (without running) according which Windows and PowerShell versions it is run on
	irm script.sophi.app | iex
	Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression

	.NOTES
	Supported Windows 11 version
	Version: 21H2
	Build: 22000.282
	Editions: Home/Pro/Enterprise

	.NOTES
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.NOTES
	To use the TAB completion for functions and their arguments dot source the Function.ps1 script first:
		. .\Function.ps1 (with a dot at the beginning)
	Read more in the Functions.ps1 file

	.LINK GitHub link
	https://github.com/farag2/Sophia-Script-for-Windows

	.LINK Telegram channel & group
	https://t.me/sophianews
	https://t.me/sophia_chat

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/company/skillfactory/blog/553800/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK Authors
	https://github.com/farag2
	https://github.com/Inestic
#>

#Requires -RunAsAdministrator
#Requires -Version 7.2

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v6.0.7 (PowerShell 7) | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows | $([char]0x00A9) farag & Inestic, 2014$([char]0x2013)2021"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia -BaseDirectory $PSScriptRoot\Localizations

<#
	.SYNOPSIS
	Run the script by specifying functions as an argument
	Запустить скрипт, указав в качестве аргумента функции

	.EXAMPLE
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Separate functions with a comma
	Разделяйте функции запятыми
#>
if ($Functions)
{
	Invoke-Command -ScriptBlock {Checkings}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	# The "RefreshEnvironment" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {RefreshEnvironment; Errors}

	exit
}

#region Protection
<#
	The mandatory checkings. If you want to disable a warning message about whether the preset file was customized, remove the "-Warning" argument
	Please, do not comment out this function

	Обязательные проверки. Чтобы выключить предупреждение о необходимости настройки пресет-файла, удалите аргумент "-Warning"
	Пожалуйста, не комментируйте данную функцию
#>
Checkings -Warning

<#
	Enable script logging. Log will be recorded into the script folder
	To stop logging just close console or type "Stop-Transcript"

	Включить логирование работы скрипта. Лог будет записываться в папку скрипта
	Чтобы остановить логгирование, закройте консоль или наберите "Stop-Transcript"
#>
# Logging

# Create a restore point
# Создать точку восстановления
CreateRestorePoint
#endregion Protection

#region Privacy & Telemetry
# Disable the "Connected User Experiences and Telemetry" service (DiagTrack), and block the connection for the Unified Telemetry Client Outbound Traffic
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и блокировать соединение для исходящего трафик клиента единой телеметрии
DiagTrackService -Disable

# Enable the "Connected User Experiences and Telemetry" service (DiagTrack), and allow the connection for the Unified Telemetry Client Outbound Traffic (default value)
# Включить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и разрешить подключение для исходящего трафик клиента единой телеметрии  (значение по умолчанию)
# DiagTrackService -Enable

# Set the diagnostic data collection to minimum
# Установить уровень сбора диагностических данных ОС на минимальный
DiagnosticDataLevel -Minimal

# Set the diagnostic data collection to default (default value)
# Установить уровень сбора диагностических данных ОС по умолчанию (значение по умолчанию)
# DiagnosticDataLevel -Default

# Turn off the Windows Error Reporting
# Отключить запись отчетов об ошибках Windows
ErrorReporting -Disable

# Turn on the Windows Error Reporting (default value)
# Включить отчеты об ошибках Windows (значение по умолчанию)
# ErrorReporting -Enable

# Change the feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
FeedbackFrequency -Never

# Change the feedback frequency to "Automatically" (default value)
# Изменить частоту формирования отзывов на "Автоматически" (значение по умолчанию)
# FeedbackFrequency -Automatically

# Turn off the diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
ScheduledTasks -Disable

# Turn on the diagnostics tracking scheduled tasks (default value)
# Включить задачи диагностического отслеживания (значение по умолчанию)
# ScheduledTasks -Enable

# Do not use sign-in info to automatically finish setting up device after an update
# Не использовать данные для входа для автоматического завершения настройки устройства после перезапуска
SigninInfo -Disable

# Use sign-in info to automatically finish setting up device after an update (default value)
# Использовать данные для входа, чтобы автоматически завершить настройку после обновления (значение по умолчанию)
# SigninInfo -Enable

# Do not let websites provide locally relevant content by accessing language list
# Не позволить веб-сайтам предоставлять местную информацию за счет доступа к списку языков
LanguageListAccess -Disable

# Let websites provide locally relevant content by accessing language list (default value)
# Позволить веб-сайтам предоставлять местную информацию за счет доступа к списку языков (значение по умолчанию)
# LanguageListAccess -Enable

# Do not let apps show me personalized ads by using my advertising ID
# Не разрешать приложениям показывать персонализированную рекламу с помощью моего идентификатора рекламы
AdvertisingID -Disable

# Let apps show me personalized ads by using my advertising ID (default value)
# Разрешить приложениям показывать персонализированную рекламу с помощью моего идентификатора рекламы (значение по умолчанию)
# AdvertisingID -Enable

# Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
# Скрывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях
WindowsWelcomeExperience -Hide

# Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested (default value)
# Показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях (значение по умолчанию)
# WindowsWelcomeExperience -Show

# Get tips and suggestions when I use Windows (default value)
# Получать советы и предложения при использованию Windows (значение по умолчанию)
WindowsTips -Enable

# Do not get tips and suggestions when I use Windows
# Не получать советы и предложения при использованию Windows
# WindowsTips -Disable

# Hide from me suggested content in the Settings app
# Скрывать рекомендуемое содержимое в приложении "Параметры"
SettingsSuggestedContent -Hide

# Show me suggested content in the Settings app (default value)
# Показывать рекомендуемое содержимое в приложении "Параметры" (значение по умолчанию)
# SettingsSuggestedContent -Show

# Turn off automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
AppsSilentInstalling -Disable

# Turn on automatic installing suggested apps (default value)
# Включить автоматическую установку рекомендованных приложений (значение по умолчанию)
# AppsSilentInstalling -Enable

# Disable suggestions on how I can set up my device
# Не показывать предложения по настройке устройства
WhatsNewInWindows -Disable

# Let Microsoft offer you tailored expereinces based on the diagnostic data setting you have chosen (default value)
# Разрешите корпорации Майкософт использовать ваши диагностические данные для улучшения вашей работы со службами Майкрософт с помощью персонализированных советов, рекламы и рекомендаций (значение по умолчанию)
# WhatsNewInWindows -Enable

# Don't let Microsoft use your diagnostic data for personalized tips, ads, and recommendations
# Не разрешать корпорации Майкрософт использовать диагностические данные персонализированных советов, рекламы и рекомендаций
TailoredExperiences -Disable

# Let Microsoft use your diagnostic data for personalized tips, ads, and recommendations (default value)
# Разрешить корпорации Майкрософт использовать диагностические данные для персонализированных советов, рекламы и рекомендаций (значение по умолчанию)
# TailoredExperiences -Enable

# Disable Bing search in the Start Menu
# Отключить в меню "Пуск" поиск через Bing
BingSearch -Disable

# Enable Bing search in the Start Menu (default value)
# Включить поиск через Bing в меню "Пуск" (значение по умолчанию)
# BingSearch -Enable
#endregion Privacy & Telemetry

#region UI & Personalization
# Show the "This PC" icon on Desktop
# Отобразить значок "Этот компьютер" на рабочем столе
# ThisPC -Show

# Hide the "This PC" icon on Desktop (default value)
# Скрыть "Этот компьютер" на рабочем столе (значение по умолчанию)
# ThisPC -Hide

# Enable the Windows 10 File Explorer
# Включить проводник из Windows 10
# Windows10FileExplorer -Enable

# Disable the Windows 10 File Explorer (default value)
# Выключить проводник из Windows 10 (значение по умолчанию)
# Windows10FileExplorer -Disable

# Do not use item check boxes
# Не использовать флажки для выбора элементов
# CheckBoxes -Disable

# Use check item check boxes (default value)
# Использовать флажки для выбора элементов (значение по умолчанию)
# CheckBoxes -Enable

# Show hidden files, folders, and drives
# Отобразить скрытые файлы, папки и диски
HiddenItems -Enable

# Do not show hidden files, folders, and drives (default value)
# Не показывать скрытые файлы, папки и диски (значение по умолчанию)
# HiddenItems -Disable

# Show file name extensions
# Отобразить расширения имён файлов
FileExtensions -Show

# Hide file name extensions (default value)
# Скрывать расширения имён файлов файлов (значение по умолчанию)
# FileExtensions -Hide

# Show folder merge conflicts
# Не скрывать конфликт слияния папок
MergeConflicts -Show

# Hide folder merge conflicts (default value)
# Скрывать конфликт слияния папок (значение по умолчанию)
# MergeConflicts -Hide

# Open File Explorer to "This PC"
# Открывать проводник для "Этот компьютер"
OpenFileExplorerTo -ThisPC

# Open File Explorer to Quick access (default value)
# Открывать проводник для "Быстрый доступ" (значение по умолчанию)
# OpenFileExplorerTo -QuickAccess

# Disable the File Explorer compact mode (default value)
# Отключить компактный вид проводника (значение по умолчанию)
# FileExplorerCompactMode -Disable

# Enable the File Explorer compact mode
# Включить компактный вид проводника
# FileExplorerCompactMode -Enable

# Do not show sync provider notification within File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
OneDriveFileExplorerAd -Hide

# Show sync provider notification within File Explorer (default value)
# Показывать уведомления поставщика синхронизации в проводнике (значение по умолчанию)
# OneDriveFileExplorerAd -Show

# When I snap a window, do not show what I can snap next to it
# При прикреплении окна не показывать, что можно прикрепить рядом с ним
SnapAssist -Disable

# When I snap a window, show what I can snap next to it (default value)
# При прикреплении окна показывать, что можно прикрепить рядом с ним (значение по умолчанию)
# SnapAssist -Enable

# Show snap layouts when I hover over a windows's maximaze button (default value)
# Показывать макеты прикрепления, частью которых является приложение, при наведении указателя мыши на кнопки панели задач (значение по умолчанию)
SnapAssistFlyout -Enable

# Hide snap layouts when I hover over a windows's maximaze button
# Не показывать макеты прикрепления, частью которых является приложение, при наведении указателя мыши на кнопки панели задач
# SnapAssistFlyout -Disable

# Show the file transfer dialog box in the detailed mode
# Отображать диалоговое окно передачи файлов в развернутом виде
FileTransferDialog -Detailed

# Show the file transfer dialog box in the compact mode (default value)
# Отображать диалоговое окно передачи файлов в свернутом виде (значение по умолчанию)
# FileTransferDialog -Compact

# Display the recycle bin files delete confirmation dialog
# Запрашивать подтверждение на удаление файлов в корзину
RecycleBinDeleteConfirmation -Enable

# Do not display the recycle bin files delete confirmation dialog (default value)
# Не запрашивать подтверждение на удаление файлов в корзину (значение по умолчанию)
# RecycleBinDeleteConfirmation -Disable

# Hide recently used files in Quick access
# Скрыть недавно использовавшиеся файлы на панели быстрого доступа
QuickAccessRecentFiles -Hide

# Show recently used files in Quick access (default value)
# Показать недавно использовавшиеся файлы на панели быстрого доступа (значение по умолчанию)
# QuickAccessRecentFiles -Show

# Hide frequently used folders in Quick access
# Скрыть недавно используемые папки на панели быстрого доступа
QuickAccessFrequentFolders -Hide

# Show frequently used folders in Quick access (default value)
# Показать часто используемые папки на панели быстрого доступа (значение по умолчанию)
# QuickAccessFrequentFolders -Show

# Set the taskbar alignment to the left
# Установить выравнивание панели задач по левому краю
# TaskbarAlignment -Left

# Set the taskbar alignment to the center (default value)
# Установить выравнивание панели задач по центру (значение по умолчанию)
# TaskbarAlignment -Center

# Hide the search button from the taskbar
# Скрыть кнопку поиска с панели задач
# TaskbarSearch -Hide

# Show the search icon on the taskbar
# Отобразить кнопку поиска на панели задач
# TaskbarSearch -Show

# Hide the Task view button on the taskbar
# Скрыть кнопку "Представление задач" с панели задач
# TaskViewButton -Hide

# Show the Task view button on the taskbar (default value)
# Отобразить кнопку "Представление задач" на панели задач (значение по умолчанию)
# TaskViewButton -Show

# Hide the widgets icon on the taskbar
# Скрыть кнопку "Мини-приложения" с панели задач
# TaskbarWidgets -Hide

# Show the widgets icon on the taskbar (default value)
# Отобразить кнопку "Мини-приложения" на панели задач (значение по умолчанию)
# TaskbarWidgets -Show

# Hide the Chat icon (Microsoft Teams) on the taskbar
# Скрыть кнопку чата (Microsoft Teams) с панели задач
TaskbarChat -Hide

# Show the Chat icon (Microsoft Teams) on the taskbar (default value)
# Отобразить кнопку чата (Microsoft Teams) на панели задач (значение по умолчанию)
# TaskbarChat -Show

# Unpin the "Microsoft Edge", "Microsoft Store" shortcuts from the taskbar
# Открепить ярлыки "Microsoft Edge", "Microsoft Store" или "Почта" от панели задач
# UnpinTaskbarShortcuts -Shortcuts Edge, Store

# View the Control Panel icons by large icons
# Просмотр иконок Панели управления как: крупные значки
ControlPanelView -LargeIcons

# View the Control Panel icons by small icons
# Просмотр иконок Панели управления как: маленькие значки
# ControlPanelView -SmallIcons

# View the Control Panel icons by category (default value)
# Просмотр иконок Панели управления как: категория (значение по умолчанию)
# ControlPanelView -Category

# Set the default Windows mode to dark
# Установить режим Windows по умолчанию на темный
WindowsColorMode -Dark

# Set the default Windows mode to light (default value)
# Установить режим Windows по умолчанию на светлый (значение по умолчанию)
# WindowsColorMode -Light

# Set the default app mode to dark
# Установить цвет режима приложения на темный
AppColorMode -Dark

# Set the default app mode to light (default value)
# Установить цвет режима приложения на светлый (значение по умолчанию)
# AppColorMode -Light

# Hide first sign-in animation after the upgrade
# Скрывать анимацию при первом входе в систему после обновления
FirstLogonAnimation -Disable

# Show first sign-in animation after the upgrade (default value)
# Показывать анимацию при первом входе в систему после обновления (значение по умолчанию)
# FirstLogonAnimation -Enable

# Set the quality factor of the JPEG desktop wallpapers to maximum
# Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный
JPEGWallpapersQuality -Max

# Set the quality factor of the JPEG desktop wallpapers to default
# Установить коэффициент качества обоев рабочего стола в формате JPEG по умолчанию
# JPEGWallpapersQuality -Default

# Start Task Manager in the expanded mode
# Запускать Диспетчера задач в развернутом виде
TaskManagerWindow -Expanded

# Start Task Manager in the compact mode (default value)
# Запускать Диспетчера задач в свернутом виде (значение по умолчанию)
# TaskManagerWindow -Compact

# Notify me when a restart is required to finish updating
# Уведомлять меня о необходимости перезагрузки для завершения обновления
RestartNotification -Show

# Do not notify me when a restart is required to finish updating (default value)
# Не yведомлять меня о необходимости перезагрузки для завершения обновления (значение по умолчанию)
# RestartNotification -Hide

# Do not add the "- Shortcut" suffix to the file name of created shortcuts
# Нe дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков
ShortcutsSuffix -Disable

# Add the "- Shortcut" suffix to the file name of created shortcuts (default value)
# Дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков (значение по умолчанию)
# ShortcutsSuffix -Enable

# Use the Print screen button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
# PrtScnSnippingTool -Enable

# Do not use the Print screen button to open screen snipping (default value)
# Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (значение по умолчанию)
# PrtScnSnippingTool -Disable

# Let me use a different input method for each app window
# Позволить выбирать метод ввода для каждого окна
# AppsLanguageSwitch -Enable

# Do not use a different input method for each app window (default value)
# Не использовать метод ввода для каждого окна (значение по умолчанию)
# AppsLanguageSwitch -Disable

# When I grab a windows's title bar and shake it, minimize all other windows
# При захвате заголовка окна и встряхивании сворачиваются все остальные окна
AeroShaking -Enable

# When I grab a windows's title bar and shake it, don't minimize all other windows (default value)
# При захвате заголовка окна и встряхивании не сворачиваются все остальные окна (значение по умолчанию)
# AeroShaking -Disable
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive. The OneDrive user folder won't be removed
# Удалить OneDrive. Папка пользователя OneDrive не будет удалена
OneDrive -Uninstall

# Install OneDrive 64-bit (default value)
# Установить OneDrive 64-бит (значение по умолчанию)
# OneDrive -Install
#endregion OneDrive

#region System
#region StorageSense
# Turn on Storage Sense
# Включить Контроль памяти
StorageSense -Enable

# Turn off Storage Sense (default value)
# Выключить Контроль памяти (значение по умолчанию)
# StorageSense -Disable

# Run Storage Sense every month
# Запускать Контроль памяти каждый месяц
StorageSenseFrequency -Month

# Run Storage Sense during low free disk space (default value)
# Запускать Контроль памяти, когда остается мало место на диске (значение по умолчанию)
# StorageSenseFrequency -Default

# Turn on automatic cleaning up temporary system and app files
# Автоматически очищать временные файлы системы и приложений
StorageSenseTempFiles -Enable

# Turn off automatic cleaning up temporary system and app files
# Не очищать временные файлы системы и приложений
# StorageSenseTempFiles -Disable
#endregion StorageSense

# Disable hibernation. Do not recommend turning it off on laptops
# Отключить режим гибернации. Не рекомендуется выключать на ноутбуках
# Hibernation -Disable

# Enable hibernate (default value)
# Включить режим гибернации (значение по умолчанию)
# Hibernation -Enable

# Change the %TEMP% environment variable path to %SystemDrive%\Temp
# Изменить путь переменной среды для %TEMP% на %SystemDrive%\Temp
# TempFolder -SystemDrive

# Change %TEMP% environment variable path to %LOCALAPPDATA%\Temp (default value)
# Изменить путь переменной среды для %TEMP% на LOCALAPPDATA%\Temp (значение по умолчанию)
# TempFolder -Default

# Disable the Windows 260 characters path limit
# Отключить ограничение Windows на 260 символов в пути
Win32LongPathLimit -Disable

# Enable the Windows 260 character path limit (default value)
# Включить ограничение Windows на 260 символов в пути (значение по умолчанию)
# Win32LongPathLimit -Enable

# Display the Stop error information on the BSoD
# Отображать Stop-ошибку при появлении BSoD
BSoDStopError -Enable

# Do not display the Stop error information on the BSoD (default value)
# Не отображать Stop-ошибку при появлении BSoD (значение по умолчанию)
# BSoDStopError -Disable

# Choose when to be notified about changes to your computer: never notify
# Настройка уведомления об изменении параметров компьютера: никогда не уведомлять
AdminApprovalMode -Never

# Choose when to be notified about changes to your computer: notify me only when apps try to make changes to my computer (default value)
# Настройка уведомления об изменении параметров компьютера: уведомлять меня только при попытках приложений внести изменения в компьютер (значение по умолчанию)
# AdminApprovalMode -Default

# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
MappedDrivesAppElevatedAccess -Enable

# Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled (default value)
# Выключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами (значение по умолчанию)
# MappedDrivesAppElevatedAccess -Disable

# Turn off Delivery Optimization
# Выключить оптимизацию доставки
DeliveryOptimization -Disable

# Turn on Delivery Optimization (default value)
# Включить оптимизацию доставки (значение по умолчанию)
# DeliveryOptimization -Enable

# Always wait for the network at computer startup and logon for workgroup networks
# Всегда ждать сеть при запуске и входе в систему для рабочих групп
# WaitNetworkStartup -Enable

# Never wait for the network at computer startup and logon for workgroup networks (default value)
# Никогда не ждать сеть при запуске и входе в систему для рабочих групп (значение по умолчанию)
# WaitNetworkStartup -Disable

# Do not let Windows manage my default printer
# Не разрешать Windows управлять принтером, используемым по умолчанию
WindowsManageDefaultPrinter -Disable

# Let Windows manage my default printer (default value)
# Разрешать Windows управлять принтером, используемым по умолчанию (значение по умолчанию)
# WindowsManageDefaultPrinter -Enable

<#
	Disable the Windows features using the pop-up dialog box
	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not disable the "Media Features" feature

	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах схемы управления питанием, не отключайте "Компоненты для работы с медиа"
	Отключить компоненты Windows, используя всплывающее диалоговое окно
#>
WindowsFeatures -Disable

# Enable the Windows features using the pop-up dialog box
# Включить компоненты Windows, используя всплывающее диалоговое окно
# WindowsFeatures -Enable

<#
	Uninstall optional features using the pop-up dialog box
	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not uninstall the "Media Features" feature

	Удалить дополнительные компоненты, используя всплывающее диалоговое окно
	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах схемы управления питанием, не удаляйте компонент "Компоненты для работы с медиа"
#>
WindowsCapabilities -Uninstall

# Install optional features using the pop-up dialog box
# Установить дополнительные компоненты, используя всплывающее диалоговое окно
# WindowsCapabilities -Install

# Receive updates for other Microsoft products
# Получать обновления для других продуктов Майкрософт
UpdateMicrosoftProducts -Enable

# Do not receive updates for other Microsoft products (default value)
# Не получать обновления для других продуктов Майкрософт (значение по умолчанию)
# UpdateMicrosoftProducts -Disable

<#
	Set power plan on "High performance"
	It isn't recommended to turn on the "High performance" power plan on laptops

	Установить схему управления питанием на "Высокая производительность"
	Не рекомендуется включать схему управления питанием "Высокая производительность" для ноутбуков
#>
PowerPlan -High

# Set power plan on "Balanced" (default value)
# Установить схему управления питанием на "Сбалансированная" (значение по умолчанию)
# PowerPlan -Balanced

# Use the latest installed .NET runtime for all apps
# Использовать последнюю установленную среду выполнения .NET для всех приложений
LatestInstalled.NET -Enable

# Do not use the latest installed .NET runtime for all apps (default value)
# Не использовать последнюю установленную версию .NET для всех приложений (значение по умолчанию)
# LatestInstalled.NET -Disable

# Do not allow the computer to turn off the network adapters to save power
# Запретить отключение всех сетевых адаптеров для экономии энергии
NetworkAdaptersSavePower -Disable

# Allow the computer to turn off the network adapters to save power (default value)
# Разрешить отключение всех сетевых адаптеров для экономии энергии (значение по умолчанию)
# NetworkAdaptersSavePower -Enable

<#
	Disable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipv6-test.com

	Выключить IP версии 6 (TCP/IPv6)
	Перед выполнением функции будет провердена проверка: поддерживает ли ваш провайдер IPv6, используя ресурс https://ipv6-test.com
#>
IPv6Component -Disable

<#
	Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections (default value)
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipv6-test.com

	Включить IP версии 6 (TCP/IPv6) (значение по умолчанию)
	Перед выполнением функции будет провердена проверка: поддерживает ли ваш провайдер IPv6, используя ресурс https://ipv6-test.com
#>
# IPv6Component -Enable

# Override for default input method: English
# Переопределить метод ввода по умолчанию: английский
InputMethod -English

# Override for default input method: use language list (default value)
# Переопределить метод ввода по умолчанию: использовать список языков (значение по умолчанию)
# InputMethod -Default

<#
	Move user folders location to the root of any drive using the interactive menu
	User files or folders won't me moved to a new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Переместить пользовательские папки в корень любого диска на выбор с помощью интерактивного меню
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %USERPROFILE%
#>
SetUserShellFolderLocation -Root

<#
	Select folders for user folders location manually using a folder browser dialog
	User files or folders won't me moved to a new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Выбрать папки для расположения пользовательских папок вручную, используя диалог "Обзор папок"
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %USERPROFILE%
#>
# SetUserShellFolderLocation -Custom

<#
	Change user folders location to the default values
	User files or folders won't me moved to the new location. Move them manually
	They're located in the %USERPROFILE% folder by default

	Изменить расположение пользовательских папок на значения по умолчанию
	Пользовательские файлы и папки не будут перемещены в новое расположение. Переместите их вручную
	По умолчанию они располагаются в папке %%USERPROFILE%
#>
# SetUserShellFolderLocation -Default

<#
	Save screenshots by pressing Win+PrtScr on the Desktop
	The function will be applied only if the preset is configured to remove the OneDrive application
	Otherwise the backup functionality for the "Desktop" and "Pictures" folders in OneDrive breaks

	Сохранять скриншоты по нажатию Win+PrtScr на рабочий столе
	Функция будет применена только в случае, если в пресете настроено удаление приложения OneDrive,
	иначе ломается функционал резервного копирования для папок "Рабочий стол" и "Изображения" в OneDrive
#>
# WinPrtScrFolder -Desktop

# Save screenshots by pressing Win+PrtScr in the Pictures folder (default value)
# Cохранять скриншоты по нажатию Win+PrtScr в папку "Изображения" (значение по умолчанию)
# WinPrtScrFolder -Default

<#
	Run troubleshooter automatically, then notify me
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data", and the error reporting feature will be turned on

	Автоматически запускать средства устранения неполадок, а затем уведомлять
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
RecommendedTroubleshooting -Automatically

<#
	Ask me before running troubleshooter (default value)
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data"

	Спрашивать перед запуском средств устранения неполадок (значение по умолчанию)
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
# RecommendedTroubleshooting -Default

# Launch folder windows in a separate process
# Запускать окна с папками в отдельном процессе
FoldersLaunchSeparateProcess -Enable

# Do not launch folder windows in a separate process (default value)
# Не запускать окна с папками в отдельном процессе (значение по умолчанию)
# FoldersLaunchSeparateProcess -Disable

# Disable and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
ReservedStorage -Disable

# Enable reserved storage (default value)
# Включить зарезервированное хранилище (значение по умолчанию)
# ReservedStorage -Enable

# Disable help lookup via F1
# Отключить открытие справки по нажатию F1
F1HelpPage -Disable

# Enable help lookup via F1 (default value)
# Включить открытие справки по нажатию F1 (значение по умолчанию)
# F1HelpPage -Enable

# Enable Num Lock at startup
# Включить Num Lock при загрузке
NumLock -Enable

# Disable Num Lock at startup (default value)
# Выключить Num Lock при загрузке (значение по умолчанию)
# NumLock -Disable

# Disable Caps Lock
# Выключить Caps Lock
# CapsLock -Disable

# Enable Caps Lock (default value)
# Включить Caps Lock (значение по умолчанию)
# CapsLock -Enable

# Turn off pressing the Shift key 5 times to turn Sticky keys
# Выключить залипание клавиши Shift после 5 нажатий
StickyShift -Disable

# Turn on pressing the Shift key 5 times to turn Sticky keys (default value)
# Включить залипание клавиши Shift после 5 нажатий (значение по умолчанию)
# StickyShift -Enable

# Don't use AutoPlay for all media and devices
# Не использовать автозапуск для всех носителей и устройств
Autoplay -Disable

# Use AutoPlay for all media and devices (default value)
# Использовать автозапуск для всех носителей и устройств (значение по умолчанию)
# Autoplay -Enable

# Disable thumbnail cache removal
# Отключить удаление кэша миниатюр
ThumbnailCacheRemoval -Disable

# Enable thumbnail cache removal (default value)
# Включить удаление кэша миниатюр (значение по умолчанию)
# ThumbnailCacheRemoval -Enable

# Automatically saving my restartable apps and restart them when I sign back in
# Автоматически сохранять мои перезапускаемые приложения из системы и перезапускать их при повторном входе
SaveRestartableApps -Enable

# Turn off automatically saving my restartable apps and restart them when I sign back in (default value)
# Выключить автоматическое сохранение моих перезапускаемых приложений из системы и перезапускать их при повторном входе (значение по умолчанию)
# SaveRestartableApps -Disable

# Enable "Network Discovery" and "File and Printers Sharing" for workgroup networks
# Включить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп
NetworkDiscovery -Enable

# Disable "Network Discovery" and "File and Printers Sharing" for workgroup networks (default value)
# Выключить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп (значение по умолчанию)
# NetworkDiscovery -Disable

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
ActiveHours -Automatically

# Manually adjust active hours for me based on daily usage (default value)
# Вручную изменять период активности для этого устройства на основе действий (значение по умолчанию)
# ActiveHours -Manually

# Restart as soon as possible to finish updating
# Перезапустить устройство как можно быстрее, чтобы завершить обновление
RestartDeviceAfterUpdate -Enable

# Don't restart as soon as possible to finish updating (default value)
# Не перезапускать устройство как можно быстрее, чтобы завершить обновление (значение по умолчанию)
# RestartDeviceAfterUpdate -Disable

<#
	Register app, calculate hash, and associate with an extension with the "How do you want to open this" pop-up hidden
	Зарегистрировать приложение, вычислить хэш и ассоциировать его с расширением без всплывающего окна "Каким образом вы хотите открыть этот файл?"

	Set-Association -ProgramPath "C:\SumatraPDF.exe" -Extension .pdf -Icon "shell32.dll,100"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
#>
# Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"

# Set Windows Terminal as default terminal app to host the user interface for command-line applications
# Установить Windows Terminal как приложение терминала по умолчанию для размещения пользовательского интерфейса для приложений командной строки
DefaultTerminalApp -WindowsTerminal

# Set Windows Console Host as default terminal app to host the user interface for command-line applications (default value)
# Установить Windows Console Host как приложение терминала по умолчанию для размещения пользовательского интерфейса для приложений командной строки (значение по умолчанию)
# DefaultTerminalApp -ConsoleHost

<#
	Install the latest supported Microsoft Visual C++ Redistributable 2015—2022 x64
	Установить последнюю поддерживаемую версию Microsoft Visual C++ Redistributable 2015-2022 x64

	https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
#>
InstallVCRedistx64
#endregion System

#region WSL
<#
	Enable Windows Subsystem for Linux (WSL), install the latest WSL Linux kernel version, and a Linux distribution using a pop-up form
	To receive kernel updates, enable the Windows Update setting: "Receive updates for other Microsoft products"

	Установить подсистему Windows для Linux (WSL), последний пакет обновления ядра Linux и дистрибутив Linux, используя всплывающую форму
	Чтобы получать обновления ядра, включите параметр "При обновлении Windows поулчать обновления для других продуктов Майкрософт" в Центре обновлении Windows
#>
# WSL
#endregion WSL

#region Start menu
# Unpin all Start apps
# Открепить все приложения от начального экрана
# UnpinAllStartApps

# Run the Windows PowerShell shortcut from the Start menu as Administrator
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени Администратора
RunPowerShellShortcut -Elevated

# Run the Windows PowerShell shortcut from the Start menu as user (default value)
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени пользователя (значение по умолчанию)
# RunPowerShellShortcut -NonElevated
#endregion Start menu

#region UWP apps
<#
	Uninstall UWP apps using the pop-up dialog box
	If the "For All Users" is checked apps packages will not be installed for new users
	The "ForAllUsers" argument sets a checkbox to unistall packages for all users

	Удалить UWP-приложения, используя всплывающее диалоговое окно
	Пакеты приложений не будут установлены для новых пользователей, если отмечена галочка "Для всех пользователей"
	Аргумент "ForAllUsers" устанавливает галочку для удаления пакетов для всех пользователей
#>
UninstallUWPApps

<#
	Restore the default UWP apps using the pop-up dialog box
	UWP apps can be restored only if they were uninstalled only for the current user

	Восстановить стандартные UWP-приложения, используя всплывающее диалоговое окно
	UWP-приложения могут быть восстановлены, только если они были удалены для текущего пользователя
#>
# RestoreUWPApps

# Download and install "HEVC Video Extensions from Device Manufacturer" to be able to open .heic and .heif formats
# Скачать и установить "Расширения для видео HEVC от производителя устройства", чтобы иметь возможность открывать форматы .heic и .heif
HEIF -Install

<#
	Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page to install this extension manually to be able to open .heic and .heif formats
	The extension can be installed without a Microsoft account

	Открыть страницу "Расширения для видео HEVC от производителя устройства" в Microsoft Store, чтобы вручную установить расширение для открытия форматов .heic и .heif
	Расширение может быть установлено бесплатно без учетной записи Microsoft
#>
# HEIF -Manually

# Disable Cortana autostarting
# Выключить автозагрузку Кортана
CortanaAutostart -Disable

# Enable Cortana autostarting (default value)
# Включить автозагрузку Кортана (значение по умолчанию)
# CortanaAutostart -Enable

# Disable Microsoft Teams autostarting
# Выключить автозагрузку Microsoft Teams
# TeamsAutostart -Disable

# Enable Microsoft Teams autostarting (default value)
# Включить автозагрузкуMicrosoft Teams (значение по умолчанию)
# TeamsAutostart -Enable

# Check for UWP apps updates
# Проверить обновления UWP-приложений
CheckUWPAppsUpdates
#endregion UWP apps

#region Gaming
# Disable Xbox Game Bar
# Отключить Xbox Game Bar
XboxGameBar -Disable

# Enable Xbox Game Bar (default value)
# Включить Xbox Game Bar (значение по умолчанию)
# XboxGameBar -Enable

# Disable Xbox Game Bar tips
# Отключить советы Xbox Game Bar
XboxGameTips -Disable

# Enable Xbox Game Bar tips (default value)
# Включить советы Xbox Game Bar (значение по умолчанию)
# XboxGameTips -Enable

# Choose an app and set the "High performance" graphics performance for it. Only if you have a dedicated GPU
# Выбрать приложение и установить для него параметры производительности графики на "Высокая производительность". Только при наличии внешней видеокарты
SetAppGraphicsPerformance

<#
	Turn on hardware-accelerated GPU scheduling. Restart needed
	Only if you have a dedicated GPU and WDDM verion is 2.7 or higher

	Включить планирование графического процессора с аппаратным ускорением. Необходима перезагрузка
	Только при наличии внешней видеокарты и WDDM версии 2.7 и выше
#>
GPUScheduling -Enable

# Turn off hardware-accelerated GPU scheduling (default value). Restart needed
# Выключить планирование графического процессора с аппаратным ускорением (значение по умолчанию). Необходима перезагрузка
# GPUScheduling -Disable
#endregion Gaming

#region Scheduled tasks
<#
	Create the "Windows Cleanup" scheduled task for cleaning up Windows unused files and updates
	A native interactive toast notification pops up every 30 days. The task runs every 30 days

	Создать задачу "Windows Cleanup" по очистке неиспользуемых файлов и обновлений Windows в Планировщике заданий
	Нативный интерактивный тост всплывает каждые 30 дней. Задача выполняется каждые 30 дней
#>
CleanupTask -Register

# Delete the "Windows Cleanup" and "Windows Cleanup Notification" scheduled tasks for cleaning up Windows unused files and updates
# Удалить задачи "Windows Cleanup" и "Windows Cleanup Notification" по очистке неиспользуемых файлов и обновлений Windows из Планировщика заданий
# CleanupTask -Delete

<#
	Create the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
	The task will wait until the Windows Updates service finishes running. The task runs every 90 days

	Создать задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download в Планировщике заданий
	Задача будет ждать, пока служба обновлений Windows не закончит работу. Задача выполняется каждые 90 дней
#>
SoftwareDistributionTask -Register

# Delete the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
# Удалить задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download из Планировщика заданий
# SoftwareDistributionTask -Delete

<#
	Create the "Temp" scheduled task for cleaning up the %TEMP% folder
	Only files older than one day will be deleted. The task runs every 60 days

	Создать задачу "Temp" в Планировщике заданий по очистке папки %TEMP%
	Удаляться будут только файлы старше одного дня. Задача выполняется каждые 60 дней
#>
TempTask -Register

# Delete the "Temp" scheduled task for cleaning up the %TEMP% folder
# Удалить задачу "Temp" по очистке папки %TEMP% из Планировщика заданий
# TempTask -Delete
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Enable Microsoft Defender Exploit Guard network protection
# Включить защиту сети в Microsoft Defender Exploit Guard
NetworkProtection -Enable

# Disable Microsoft Defender Exploit Guard network protection (default value)
# Выключить защиту сети в Microsoft Defender Exploit Guard
# NetworkProtection -Disable

# Enable detection for potentially unwanted applications and block them
# Включить обнаружение потенциально нежелательных приложений и блокировать их
PUAppsDetection -Enable

# Disable detection for potentially unwanted applications and block them (default value)
# Выключить обнаружение потенциально нежелательных приложений и блокировать их (значение по умолчанию)
# PUAppsDetection -Disable

<#
	Enable sandboxing for Microsoft Defender
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows

	Включить песочницу для Microsoft Defender
	В KVM с QEMU присутствует баг: включение этой функции приводит ВМ к зависанию во время загрузки Windows
#>
DefenderSandbox -Enable

# Disable sandboxing for Microsoft Defender (default value)
# Выключить песочницу для Microsoft Defender (значение по умолчанию)
# DefenderSandbox -Disable

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
DismissMSAccount

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Microsoft Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
DismissSmartScreenFilter

# Enable events auditing generated when a process is created (starts)
# Включить аудит событий, возникающих при создании или запуске процесса
AuditProcess -Enable

# Disable events auditing generated when a process is created (starts) (default value)
# Выключить аудит событий, возникающих при создании или запуске процесса (значение по умолчанию)
# AuditProcess -Disable

<#
	Include command line in process creation events
	In order this feature to work events auditing (ProcessAudit -Enable) will be enabled

	Включать командную строку в событиях создания процесса
	Для того, чтобы работал данный функционал, будет включен аудит событий (AuditProcess -Enable)
#>
CommandLineProcessAudit -Enable

# Do not include command line in process creation events (default value)
# Не включать командную строку в событиях создания процесса (значение по умолчанию)
# CommandLineProcessAudit -Disable

<#
	Create the "Process Creation" Event Viewer сustom view to log the executed processes and their arguments
	In order this feature to work events auditing (AuditProcess -Enable) and command line (CommandLineProcessAudit -Enable) in process creation events will be enabled

	Создать настраиваемое представление "Создание процесса" в Просмотре событий для журналирования запускаемых процессов и их аргументов
	Для того, чтобы работал данный функционал, буден включен аудит событий (AuditProcess -Enable) и командной строки (CommandLineProcessAudit -Enable) в событиях создания процесса
#>
EventViewerCustomView -Enable

# Remove "Process Creation" Event Viewer сustom view to log the executed processes and their arguments (default value)
# Удалить настаиваемое представление "Создание процесса" в Просмотре событий для журналирования запускаемых процессов и их аргументов (значение по умолчанию)
# EventViewerCustomView -Disable

# Enable logging for all Windows PowerShell modules
# Включить ведение журнала для всех модулей Windows PowerShell
PowerShellModulesLogging -Enable

# Disable logging for all Windows PowerShell modules (default value)
# Выключить ведение журнала для всех модулей Windows PowerShell (значение по умолчанию)
# PowerShellModulesLogging -Disable

# Enable logging for all PowerShell scripts input to the Windows PowerShell event log
# Включить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell
PowerShellScriptsLogging -Enable

# Disable logging for all PowerShell scripts input to the Windows PowerShell event log (default value)
# Выключить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell (значение по умолчанию)
# PowerShellScriptsLogging -Disable

# Microsoft Defender SmartScreen doesn't marks downloaded files from the Internet as unsafe
# Microsoft Defender SmartScreen не помечает скачанные файлы из интернета как небезопасные
AppsSmartScreen -Disable

# Microsoft Defender SmartScreen marks downloaded files from the Internet as unsafe (default value)
# Microsoft Defender SmartScreen помечает скачанные файлы из интернета как небезопасные (значение по умолчанию)
# AppsSmartScreen -Enable

# Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
# Выключить проверку Диспетчером вложений файлов, скачанных из интернета, как небезопасные
SaveZoneInformation -Disable

# Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (default value)
# Включить проверку Диспетчера вложений файлов, скачанных из интернета как небезопасные (значение по умолчанию)
# SaveZoneInformation -Enable

<#
	Disable Windows Script Host
	Blocks WSH from executing .js and .vbs files

	Отключить Windows Script Host
	Блокирует запуск файлов .js и .vbs
#>
# WindowsScriptHost -Disable

# Enable Windows Script Host (default value)
# Включить Windows Script Host (значение по умолчанию)
# WindowsScriptHost -Enable

# Enable Windows Sandbox
# Включить Windows Sandbox
# WindowsSandbox -Enable

# Disable Windows Sandbox (default value)
# Выключить Windows Sandbox (значение по умолчанию)
# WindowsSandbox -Disable

<#
	Enable DNS-over-HTTPS for IPv4
	The valid IPv4 addresses: 1.0.0.1, 1.1.1.1, 149.112.112.112, 8.8.4.4, 8.8.8.8, 9.9.9.9

	Включить DNS-over-HTTPS для IPv4
	Действительные IPv4-адреса: 1.0.0.1, 1.1.1.1, 149.112.112.112, 8.8.4.4, 8.8.8.8, 9.9.9.9
#>
DNSoverHTTPS -Enable -PrimaryDNS 1.0.0.1 -SecondaryDNS 1.1.1.1

# Disable DNS-over-HTTPS for IPv4 (default value)
# Выключить DNS-over-HTTPS для IPv4 (значение по умолчанию)
# DNSoverHTTPS -Disable
#endregion Microsoft Defender & Security

#region Context menu
# Show the "Extract all" item in the Windows Installer (.msi) context menu
# Отобразить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)
MSIExtractContext -Show

# Hide the "Extract all" item from the Windows Installer (.msi) context menu (default value)
# Скрыть пункт "Извлечь все" из контекстного меню Windows Installer (.msi) (значение по умолчанию)
# MSIExtractContext -Remove

# Show the "Install" item in the Cabinet (.cab) filenames extensions context menu
# Отобразить пункт "Установить" в контекстное меню .cab архивов
CABInstallContext -Show

# Hide the "Install" item from the Cabinet (.cab) filenames extensions context menu (default value)
# Скрыть пункт "Установить" из контекстного меню .cab архивов (значение по умолчанию)
# CABInstallContext -Hide

# Show the "Run as different user" item to the .exe filename extensions context menu
# Отобразить пункт "Запуск от имени другого пользователя" в контекстное меню .exe файлов
RunAsDifferentUserContext -Show

# Hide the "Run as different user" item from the .exe filename extensions context menu (default value)
# Скрыть пункт "Запуск от имени другого пользователя" из контекстное меню .exe файлов (значение по умолчанию)
# RunAsDifferentUserContext -Hide

# Hide the "Cast to Device" item from the media files and folders context menu
# Скрыть пункт "Передать на устройство" из контекстного меню медиа-файлов и папок
CastToDeviceContext -Hide

# Show the "Cast to Device" item in the media files and folders context menu (default value)
# Отобразить пункт "Передать на устройство" в контекстном меню медиа-файлов и папок (значение по умолчанию)
# CastToDeviceContext -Show

# Hide the "Share" item from the context menu
# Скрыть пункт "Отправить" (поделиться) из контекстного меню
ShareContext -Hide

# Show the "Share" item in the context menu (default value)
# Отобразить пункт "Отправить" (поделиться) в контекстном меню (значение по умолчанию)
# ShareContext -Show

# Hide the "Edit with Photos" item from the media files context menu
# Скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню медиа-файлов
EditWithPhotosContext -Hide

# Show the "Edit with Photos" item in the media files context menu (default value)
# Отобразить пункт "Изменить с помощью приложения "Фотографии"" в контекстном меню медиа-файлов (значение по умолчанию)
# EditWithPhotosContext -Show

# Hide the "Create a new video" item in the media files context menu
# Скрыть пункт "Создать новое видео" из контекстного меню медиа-файлов
CreateANewVideoContext -Hide

# Show the "Create a new video" item in the media files context menu (default value)
# Отобразить пункт "Создать новое видео" в контекстном меню медиа-файлов (значение по умолчанию)
# CreateANewVideoContext -Show

# Hide the "Print" item from the .bat and .cmd context menu
# Скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов
PrintCMDContext -Hide

# Show the "Print" item in the .bat and .cmd context menu (default value)
# Отобразить пункт "Печать" в контекстном меню .bat и .cmd файлов (значение по умолчанию)
# PrintCMDContext -Show

# Hide the "Include in Library" item from the folders and drives context menu
# Скрыть пункт "Добавить в библиотеку" из контекстного меню папок и дисков
IncludeInLibraryContext -Hide

# Show the "Include in Library" item in the folders and drives context menu (default value)
# Отобразить пункт "Добавить в библиотеку" в контекстном меню папок и дисков (значение по умолчанию)
# IncludeInLibraryContext -Show

# Hide the "Send to" item from the folders context menu
# Скрыть пункт "Отправить" из контекстного меню папок
# SendToContext -Hide

# Show the "Send to" item in the folders context menu (default value)
# Отобразить пункт "Отправить" в контекстном меню папок (значение по умолчанию)
# SendToContext -Show

# Hide the "Turn on BitLocker" item from the drives context menu
# Скрыть пункт "Включить BitLocker" из контекстного меню дисков
BitLockerContext -Hide

# Show the "Turn on BitLocker" item in the drives context menu (default value)
# Отобразить пункт "Включить BitLocker" в контекстном меню дисков (значение по умолчанию)
# BitLockerContext -Show

# Hide the "Compressed (zipped) Folder" item from the "New" context menu
# Скрыть пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
CompressedFolderNewContext -Hide

# Show the "Compressed (zipped) Folder" item to the "New" context menu (default value)
# Отобразить пункт "Сжатая ZIP-папка" в контекстном меню "Создать" (значение по умолчанию)
# CompressedFolderNewContext -Show

# Enable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
# Включить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
MultipleInvokeContext -Enable

# Disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected (default value)
# Отключить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов (значение по умолчанию)
# MultipleInvokeContext -Disable

# Hide the "Look for an app in the Microsoft Store" item in the "Open with" dialog
# Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"
UseStoreOpenWith -Hide

# Show the "Look for an app in the Microsoft Store" item in the "Open with" dialog (default value)
# Отобразить пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью" (значение по умолчанию)
# UseStoreOpenWith -Show

# Hide the "Open in Windows Terminal" item in the folders context menu
# Скрыть пункт "Открыть в Терминале Windows" в контекстном меню папок
OpenWindowsTerminalContext -Hide

# Show the "Open in Windows Terminal" item in the folders context menu (default value)
# Отобразить пункт "Открыть в Терминале Windows" в контекстном меню папок (значение по умолчанию)
# OpenWindowsTerminalContext -Show

# Show the "Open in Windows Terminal (Admin)" item in the Desktop and folders context menu
# Отобразить пункт "Открыть в Терминале Windows (Администратор)" в контекстном меню Рабочего стола и папок
OpenWindowsTerminalAdminContext -Show

# Hide the "Open in Windows Terminal (Admin)" item from the Desktop and folders context menu (default value)
# Скрыть пункт "Открыть в Терминале Windows (Администратор)" в контекстном меню Рабочего стола и папок (значение по умолчанию)
# OpenWindowsTerminalAdminContext -Hide

# Disable the Windows 10 context menu style (default value)
# Отключить стиль контекстного меню из Windows 10 (значение по умолчанию)
Windows10ContextMenu -Disable

# Enable the Windows 10 context menu style
# Включить стиль контекстного меню из Windows 10
# Windows10ContextMenu -Enable
#endregion Context menu

<#
	Simulate pressing F5 to refresh the desktop
	Refresh desktop icons, environment variables, taskbar
	Restart the Start menu
	Please, do not comment out this function

	Симулировать нажатие F5 для обновления рабочего стола
	Обновить иконки рабочего стола, переменные среды, панель задач
	Перезапустить меню "Пуск"
	Пожалуйста, не комментируйте данную функцию
#>
RefreshEnvironment

<#
	Errors output
	Please, do not comment out this function

	Вывод ошибок
	Пожалуйста, не комментируйте данную функцию
#>
Errors