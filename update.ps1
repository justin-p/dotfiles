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
    # dotfiles
    git pull --ff-only
    # Chocolatey
    # Exclude mobaxterm so it does not overwrite license ¯\_(ツ)_/¯
    cup all -y --except mobaxterm
}
finally {
    popd
}