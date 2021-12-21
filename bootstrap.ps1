# Based of https://raw.githubusercontent.com/christianrondeau/dotfiles/master/bootstrap.ps1
#Requires -RunAsAdministrator
[CmdletBinding()]
Param ()
Set-StrictMode -version Latest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Functions
function Write-Error([string]$message) {
    [Console]::ForegroundColor = 'red'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}
function Write-Warn([string]$message) {
    [Console]::ForegroundColor = 'yellow'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}
function StowFile([String]$link, [String]$target) {
    $file = Get-Item $link -ErrorAction SilentlyContinue
    if ($file) {
        if ($file.LinkType -ne "SymbolicLink") {
            Write-Error "$($file.FullName) already exists and is not a symbolic link"
            return
        }
        elseif ($file.Target -ne $target) {
            Write-Error "$($file.FullName) already exists and points to '$($file.Target)', it should point to '$target'"
            return
        }
        else {
            Write-Verbose "$($file.FullName) already linked"
            return
        }
    }
    else {
        $folder = Split-Path $link
        if (-not (Test-Path $folder)) {
            Write-Verbose "Creating folder $folder"
            New-Item -Type Directory -Path $folder
        }
    }
    Write-Verbose "Creating link $link to $target"
    (New-Item -Path $link -ItemType SymbolicLink -Value $target -ErrorAction Continue).Target
}
function Stow([String]$package, [String]$target) {
    if (-not $target) {
        Write-Error "Could not define the target link folder of $package"
    }

    ls $DotFilesPath\$package | % {
        if (-not $_.PSIsContainer) {
            StowFile (Join-Path -Path $target -ChildPath $_.Name) $_.FullName
        }
    }
}
# Sanity Check
if (-not [environment]::Is64BitOperatingSystem) {
    Write-Error "Only 64 bit Windows is supported"
    exit
}
if (-not $env:HOME) {
    $env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
}
# Prepare
$DotFilesPath = Split-Path $MyInvocation.MyCommand.Path
Push-Location $DotFilesPath
try {
    Try {
        StowFile $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.VSCode_profile.ps1") (Get-Item "Powershell\profile.ps1").FullName
    } Catch {
        Write-Verbose "Might be profile redirection to networkshare. Should make a check for that, for now just copy the file over."
        Copy-Item (Get-Item "Powershell\profile.ps1").FullName $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.VSCode_profile.ps1")
    }
    Try {
        StowFile $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.PowerShell_profile.ps1") (Get-Item "Powershell\profile.ps1").FullName    
    } Catch {
        Write-Verbose "Might be profile redirection to networkshare. Should make a check for that, for now just copy the file over."        
        Copy-Item (Get-Item "Powershell\profile.ps1").FullName $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.PowerShell_profile.ps1")
    }
    Try {
        StowFile $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.PowerShellISE_profile.ps1") (Get-Item "Powershell\Microsoft.PowerShellISE_profile.ps1").FullName    
    } Catch {
        Write-Verbose "Might be profile redirection to networkshare. Should make a check for that, for now just copy the file over."        
        Copy-Item (Get-Item "Powershell\Microsoft.PowerShellISE_profile.ps1").FullName $(Join-Path $($($profile.Split('\')[0..$($profile.Split('\').count-2)]) -join('\')) "Microsoft.PowerShellISE_profile.ps1")
    }    
    StowFile $("~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json") (Get-Item "windows-terminal\profiles.json").FullName
    StowFile $env:HOME/.gitconfig (Get-Item "git\.gitconfig").FullName 
    StowFile $env:HOME/.gitignore (Get-Item "git\.gitignore").FullName	   
    git config --global core.excludesfile ~/.gitignore_global	
    StowFile "$env:HOME\_vimrc" (Get-Item "vim\.vimrc").FullName
}
finally {
    Pop-Location
    Write-Output 'Installed dotfiles'
}
