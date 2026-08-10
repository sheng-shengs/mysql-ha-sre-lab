[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Distro = 'WSL-Command-Lab-Temp'
)

$ErrorActionPreference = 'Stop'
$installed = @(wsl.exe --list --quiet) | ForEach-Object { $_.Trim() } | Where-Object { $_ }
if ($Distro -ne 'WSL-Command-Lab-Temp') {
    throw 'Refusing to operate on a distro other than WSL-Command-Lab-Temp.'
}
if ($installed -notcontains $Distro) {
    Write-Output "No temporary distro named $Distro is installed. Nothing to delete."
    exit 0
}

Write-Output "This permanently deletes only: $Distro"
$confirmation = Read-Host 'Type DELETE TEMP DISTRO to continue'
if ($confirmation -ne 'DELETE TEMP DISTRO') {
    Write-Output 'Confirmation did not match; nothing was deleted.'
    exit 0
}

if ($PSCmdlet.ShouldProcess($Distro, 'wsl --unregister')) {
    wsl.exe --unregister $Distro
}
