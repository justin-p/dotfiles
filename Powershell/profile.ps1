# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
If (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
$ParentProcess = (gwmi win32_process -Filter "processid='$((gwmi win32_process -Filter "processid='$pid'").Parentprocessid)'").Name
If ( $ParentProcess -eq 'WindowsTerminal.exe' -or $ParentProcess -eq 'code.exe') {
    $LoadTheme = $True
}
# Modules
$Modules = @( 
    "posh-git",
    "oh-my-posh",
    "Get-ChildItemColor"
)
ForEach ($Module in $Modules) { 
    If (Get-Module -Name $Module -ListAvailable) {
        Import-Module $Module
        If ($LoadTheme -eq $True) {
            If ($Module -eq 'oh-my-posh') {
                Set-Theme Paradox
            }
        }
        If ($Module -eq 'Get-ChildItemColor') {
            Set-Alias ls Get-ChildItemColor -option AllScope
        }
    }
    If (!(Get-Module $Module) ) {
        Write-Warning "Missing $($Module) support, install $($Module) with 'Install-Module $($Module)'."
    }
}
