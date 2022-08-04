# Personalization:

Import-Module CTRprofile
Import-Module posh-git

# Constants:
$isAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Dynamic Collections:
$pypath =    "C:\git\python\scripts\scripts\"
$itapath =   "D:\stuff_to_keep\Italian\Italian_Reading\Material\"
$cheatpath = "C:\Powershell\DynamicParamCollections\CheatSheets\"
$emupath = "D:\Games\Emulation\"


# Path Aliases:

$engwords = "D:\stuff_to_keep\English\Words\words.txt"
$CtrVids =  "D:\Videos\CTR_Script\Input Files\Video"
$CtrTechs = "D:\Videos\CTR_Techs"
$CtrBetter = "D:\Videos\CTR_Better"

# Functions:

#> Environment

function Get-Profile{
    [Alias("re")]
    Param()
    If(!$isAdmin){
        Start-Process wt " -M PowerShell -NoExit -Command Set-Location '$(Get-Location)'" -Verb RunAs
        Exit
    }
    Import-Module $Profile -Force -Global
    Update-Environment
}

function Update-Environment {
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)

            if ($userLocation -and $name -ieq 'PATH') {
                $Env:Path += ";$value"
            } else {
                Set-Item -Path Env:$name -Value $value
            }
        }

        $userLocation = $true
    }
}

#> Study

function Start-Python {
    [CmdletBinding()]

    Param()
 
    DynamicParam {
        $attributes = new-object System.Management.Automation.ParameterAttribute

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem $pypath | Select-Object -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Script", [string], $attributeCollection)
            
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Script", $dynParam1)
        
        return $paramDictionary
    }

    End{
    python $pypath$($PSBoundParameters['Script'])
    }
}

Function Start-Study {
    [CmdletBinding()]
    Param()
    DynamicParam {
        
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem $itapath | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("PDF", [string], $attributeCollection)
        
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("PDF", $dynParam1)
        
        return $paramDictionary
    }

    End{
        Start-Process firefox "https://en.wiktionary.org/wiki/te#Italian"
        Start-Process firefox "https://translate.google.com/?sl=it&tl=en&op=translate&hl=en"
        foreach($path in (Get-ChildItem "D:\stuff_to_keep\Italian\Italian_Reading\*.txt").fullname) {
            Start-Process $path
        }
        Start-Process "D:\stuff_to_keep\Italian\Italian_Reading\Reference\Tenses"
        Start-Process $itapath$($PSBoundParameters['PDF'])
    }
}

Function Start-UC {
    Param()
    $URLList = @(
        "https://uk.indeed.com/",
        "https://www.reed.co.uk/",
        "https://www.cv-library.co.uk/",
        "https://www.monster.co.uk/"
    )
    ForEach ($URL in $URLList) {    
    Start-Process firefox $URL
    }
    code "C:\Powershell\DocumentCollections\UC\UC_Jobs.txt"
}

Function BosonBypass {
    #[Alias("")]
    Param()
    $Name = "{047FF4C1-BE9A-4F67-BB07-7145AE48FFAA}"
    Write-Host "Disabling Firewall Rule"
    Disable-NetFirewallRule -Name $Name
    Start-Sleep 20
    Write-Host "Enabling Firewall Rule"
    Enable-NetFirewallRule -Name $Name
}

#> Games

##> Melee

Function Start-Melee {
    [Alias("Melee")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\Super Smash Bros. Melee (v1.02).iso"
}

Function Start-UnclePunch {
    [Alias("Training")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\Training Mode v2.0 Beta 3.iso"
}

Function Start-20XX {
    [Alias("20xx")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\SSBM, 20XXHP 4.07++.iso"
}

Function Start-ACServer {
    $asscoserver = Get-ChildItem "D:\Games\Steam Games\steamapps\common\assettocorsa\server\acServerManager.exe"
    Start-Process -FilePath $asscoserver -WorkingDirectory $asscoserver.DirectoryName
}

# General:

Function Move-Up {
    $dirs = (Get-ChildItem).FullName
    Get-ChildItem | Get-ChildItem | ForEach-Object {Move-Item $_.FullName -Force -Confirm:$true} 
    Remove-Item $dirs

}

Function Set-SideJob {
    [Alias("splitjob")]
    Param (
        $Command
    )
wt --window 0 split-pane -p "Windows Powershell" -d "$pwd" powershell -noExit "$Command"
}

Function Get-PathClip {
    [Alias("pathclip")]
    Param (

    )
    (Get-Location).Path | Set-Clipboard
}

Function Move-File {
    [Alias("mvf")]
    Param(
        $From,
        $To
    )
    continue
}

Function Get-FullHelp {
    [Alias("hlp")]
    param(
        [Parameter(Mandatory=$true,position=0)]
        $Cmd
    )
    Get-Help $Cmd -Full
}

Function Open-CheatSheet {
[CmdletBinding()]
    Param ()
    DynamicParam {
        $attributes = new-object System.Management.Automation.ParameterAttribute

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem $cheatpath | Select-Object -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Sheet", [string], $attributeCollection)

        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Sheet", $dynParam1)

        return $paramDictionary
    }
    End {
    Start-Process $cheatpath$($PSBoundParameters['Sheet'])
    }
}

# Function to open a cheatsheet for an application, saved cheatsheets somewhere on PC, dynamic parameters.

# Shell Customization

Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
} -PredictionSource History -BellStyle Visual

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$GitPromptSettings.WindowTitle = $false
# Dracula Prompt Configuration
$GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
# Dracula Git Status Configuration
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue
