# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
# Modules
$Modules = @( 
    "posh-git",    
    "oh-my-posh",
    "windows-screenfetch",
    "Get-ChildItemColor"
)
ForEach ($Module in $Modules) { 
    if (Get-Module -Name $Module -ListAvailable) {
        Import-Module $Module
        If ($Module -eq 'oh-my-posh') {
            Set-Theme my-theme
        }
        If ($Module -eq 'windows-screenfetch') {
            Screenfetch
        }     
        If ($Module -eq 'Get-ChildItemColor') {
            Set-Alias ls Get-ChildItemColor -option AllScope
        }   
    }
    if (!(Get-Module $Module) ) {
        Write-Warning "Missing $($Module) support, install $($Module) with 'Install-Module $($Module)'."
    }
}