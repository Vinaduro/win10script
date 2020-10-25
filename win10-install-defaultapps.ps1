##########
# Tweaked Win10 Initial Setup Script
# Primary Author: Disassembler <disassembler@dasm.cz>
# Primary Author Source: https://github.com/Disassembler0/Win10-Initial-Setup-Script
# Tweaked Source: https://gist.github.com/alirobe/7f3b34ad89a159e6daa1/
#
#    Note from author: Never run scripts without reading them & understanding what they do.
#
#	Addition: One command to rule them all, One command to find it, and One command to Run it! 
#
#     > powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JJ8R4')"
#
#	Chris Titus Tech Additions:
#
#	- Dark Mode
#	- One Command to launch and run
#	- Chocolatey Install
#	- O&O Shutup10 CFG and Run
#	- Added Install Programs
#	- Added Debloat Microsoft Store Apps
#	- Added Confirm Menu for Adobe and Brave Browser
#	- Changed Default Apps to Notepad++, Brave, Irfanview, and more using XML Import feature
#
##########
# Default preset
$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin",
	"CreateRestorePoint",
	
	### Chris Titus Tech Additions
	"TitusRegistryTweaks",
	"InstallTitusProgs", #REQUIRED FOR OTHER PROGRAM INSTALLS!
	"Install7Zip",
	"InstallNotepadplusplus",
	"InstallIrfanview",
	"InstallKliteStandard",
	"InstallVLC",
	"InstallAdobe",
	"InstallBrave",
	"InstallChrome",
	"InstallFirefox",
	"InstallPlex",
	"InstallMSTeams",
	"InstallTeamViewer",
	"ChangeDefaultApps",
)

#########
# Recommended Titus Customizations
#########

function Show-Choco-Menu {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,
    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ChocoInstall
    )
   
 do
 {
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "Y: Press 'Y' to do this."
    Write-Host "2: Press 'N' to skip this."
	Write-Host "Q: Press 'Q' to stop the entire script."
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    'y' { choco install $ChocoInstall -y }
    'n' { Break }
    'q' { Exit  }
    }
 }
 until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
}

Function InstallPlex {
Get-AppxPackage -AllUsers "CAF9E577.Plex" | ForEach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

Function TitusRegistryTweaks {
	Write-Output "Improving Windows Update to delay Feature updates and only install Security Updates"
	### Fix Windows Update to delay feature updates and only update at certain times
	$UpdatesPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
	If (!(Get-ItemProperty $UpdatesPath  BranchReadinessLevel)) { New-ItemProperty -Path $UpdatesPath -Name "BranchReadinessLevel" -Type DWord -Value 20 }
	Set-ItemProperty -Path $UpdatesPath -Name "BranchReadinessLevel" -Type DWord -Value 20
	If (!(Get-ItemProperty $UpdatesPath  DeferFeatureUpdatesPeriodInDays)) { New-ItemProperty -Path $UpdatesPath -Name "DeferFeatureUpdatesPeriodInDays" -Type DWord -Value 365	}
	Set-ItemProperty -Path $UpdatesPath -Name "DeferFeatureUpdatesPeriodInDays" -Type DWord -Value 365
	If (!(Get-ItemProperty $UpdatesPath  DeferQualityUpdatesPeriodInDays)) { New-ItemProperty -Path $UpdatesPath -Name "DeferQualityUpdatesPeriodInDays" -Type DWord -Value 4 }
	Set-ItemProperty -Path $UpdatesPath -Name "DeferQualityUpdatesPeriodInDays" -Type DWord -Value 4
	If (!(Get-ItemProperty $UpdatesPath  ActiveHoursEnd)) { New-ItemProperty -Path $UpdatesPath -Name "ActiveHoursEnd" -Type DWord -Value 2	}
	Set-ItemProperty -Path $UpdatesPath -Name "ActiveHoursEnd" -Type DWord -Value 2
	If (!(Get-ItemProperty $UpdatesPath  DeferQualityUpdatesPeriodInDays)) { New-ItemProperty -Path $UpdatesPath -Name "ActiveHoursStart" -Type DWord -Value 8 }
	Set-ItemProperty -Path $UpdatesPath -Name "ActiveHoursStart" -Type DWord -Value 8
}
Function InstallTitusProgs {
	Write-Output "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
	Write-Output "Running O&O Shutup with Recommended Settings"
	Import-Module BitsTransfer
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/vinaduro/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
	Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
	./OOSU10.exe ooshutup10.cfg /quiet
}

Function InstallAdobe {
	Show-Choco-Menu -Title "Do you want to install Adobe Creative Cloud Client 1.0?" -ChocoInstall "adobe-creative-cloud"
}

Function InstallChrome {
	Show-Choco-Menu -Title "Do you want to install Google Chrome??" -ChocoInstall "googlechrome"
}

Function InstallFirefox {
	Show-Choco-Menu -Title "Do you want to install Firefox??" -ChocoInstall "firefox"
}

Function InstallMSTeams {
	Show-Choco-Menu -Title "Do you want to install Microsoft Teams??" -ChocoInstall "microsoft-teams.install"
}

Function InstallTeamViewer {
	Show-Choco-Menu -Title "Do you want to install Team Viewer??" -ChocoInstall "teamviewer"
}

Function InstallJava {
	Show-Choco-Menu -Title "Do you want to install Java??" -ChocoInstall "jre8"
}

Function Install7Zip {
	Show-Choco-Menu -Title "Do you want to install 7zip??" -ChocoInstall "7zip"
}

Function InstallNotepadplusplus {
	Show-Choco-Menu -Title "Do you want to install Notepad++??" -ChocoInstall "notepadplusplus"
}

Function InstallVLC {
	Show-Choco-Menu -Title "Do you want to install VLC" -ChocoInstall "vlc"
}

Function InstallKliteStandard {
	Show-Choco-Menu -Title "Do you want to install K-Lite Media Pack??" -ChocoInstall "k-litecodecpack-standard"
}

Function InstallIrfanview {
	Show-Choco-Menu -Title "Do you want to install irfanview??" -ChocoInstall "irfanview"
}

Function InstallBrave {
	do
 {
    Clear-Host
    Write-Host "================ Do You Want to Install Brave Browser? ================"
    Write-Host "Y: Press 'Y' to do this."
    Write-Host "2: Press 'N' to skip this."
	Write-Host "Q: Press 'Q' to stop the entire script."
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    'y' { 
		Invoke-WebRequest -Uri "https://laptop-updates.brave.com/download/CHR253" -OutFile brave.exe
		./brave.exe /silent /install	
	}
    'n' { Break }
    'q' { Exit  }
    }
 }
 until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
	
}

Function ChangeDefaultApps {
	Write-Output "Setting Default Programs - Notepad++ Brave VLC IrFanView"
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/vinaduro/win10script/master/MyDefaultAppAssociations.xml" -Destination $HOME\Desktop\MyDefaultAppAssociations.xml
	dism /online /Import-DefaultAppAssociations:"%UserProfile%\Desktop\MyDefaultAppAssociations.xml"
}

