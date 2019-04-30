# Based of https://raw.githubusercontent.com/christianrondeau/dotfiles/master/update.ps1
#Requires -RunAsAdministrator
Set-StrictMode -version Latest
if (Test-Path ~/.gitlist) {
    cat ~/.gitlist | ? {
        pushd $_
        pwd
        git pull --ff-only
        popd
    }
}
$DotFilesPath = Split-Path $MyInvocation.MyCommand.Path
pushd $DotFilesPath
try {
    # Dotfiles
    git pull --ff-only
    # Chocolatey
    cup all -y
}
finally {
    popd
}