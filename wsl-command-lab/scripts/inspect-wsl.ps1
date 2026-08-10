[CmdletBinding()]
param(
    [string]$Distro = 'Ubuntu-24.04'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$reportDir = Join-Path $root 'reports'
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$report = Join-Path $reportDir "wsl-$stamp.txt"

function Invoke-WslText {
    param([string[]]$Arguments)

    $stdoutPath = [IO.Path]::GetTempFileName()
    $stderrPath = [IO.Path]::GetTempFileName()
    try {
        $argumentString = $Arguments -join ' '
        $process = Start-Process -FilePath 'wsl.exe' -ArgumentList $argumentString -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath -NoNewWindow -Wait -PassThru
        $bytes = [IO.File]::ReadAllBytes($stdoutPath)
        $encoding = if ($bytes.Length -gt 1 -and $bytes[1] -eq 0) { [Text.Encoding]::Unicode } else { [Text.Encoding]::UTF8 }
        $text = $encoding.GetString($bytes).TrimEnd([char]0, [char]13, [char]10)
        $errorBytes = [IO.File]::ReadAllBytes($stderrPath)
        if ($errorBytes.Length -gt 0) {
            $errorEncoding = if ($errorBytes.Length -gt 1 -and $errorBytes[1] -eq 0) { [Text.Encoding]::Unicode } else { [Text.Encoding]::UTF8 }
            $errorText = $errorEncoding.GetString($errorBytes).TrimEnd([char]0, [char]13, [char]10)
            if ($errorText) { $text = @($text, $errorText) -join [Environment]::NewLine }
        }
        if ($process.ExitCode -ne 0 -and [string]::IsNullOrWhiteSpace($text)) {
            throw "wsl.exe $argumentString failed with exit code $($process.ExitCode)"
        }
        return $text
    }
    finally {
        Remove-Item -LiteralPath $stdoutPath, $stderrPath -Force -ErrorAction SilentlyContinue
    }
}

@(
    "WSL inspection: $(Get-Date -Format o)"
    "Requested distro: $Distro"
    ''
    '=== wsl --status (run directly in the terminal for native console encoding) ==='
    'Command: wsl --status'
    ''
    '=== wsl --version ==='
    (Invoke-WslText @('--version'))
    ''
    '=== wsl --list --verbose ==='
    (Invoke-WslText @('--list', '--verbose'))
    ''
    '=== wsl --help (run directly in the terminal for native console encoding) ==='
    'Command: wsl --help'
) | Set-Content -LiteralPath $report -Encoding UTF8

Write-Output "Wrote read-only report: $report"
Get-Content -LiteralPath $report
