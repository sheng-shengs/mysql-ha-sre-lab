# WSL 管理工具

function Get-WSLStatus {
    wsl -l -v
}

# 停止所有 WSL 发行版；下次使用会自动启动。
function Stop-WSLAll {
    wsl --shutdown
}

function Stop-WSLDistro {
    param(
        [string]$DistroName = "Ubuntu-24.04"
    )

    wsl --terminate $DistroName
}

function Enter-WSL {
    wsl -d Ubuntu-24.04 -u jiang --cd ~
}

# 导出指定发行版为 tar 备份文件。
function Backup-WSL {
    param(
        [Parameter(Mandatory)]
        [string]$DistroName,

        [Parameter(Mandatory)]
        [string]$ExportPath
    )

    wsl --export $DistroName $ExportPath
}

# 永久删除指定发行版。保护主 Ubuntu 和 Docker 内部发行版。
function Remove-WSLDistro {
    param(
        [Parameter(Mandatory)]
        [string]$DistroName
    )

    if ($DistroName -in @("Ubuntu-24.04", "docker-desktop", "docker-desktop-data")) {
        throw "为防止误删，脚本禁止删除 $DistroName。"
    }

    $answer = Read-Host "确认永久删除 $DistroName 吗？输入 YES 继续"
    if ($answer -eq "YES") {
        wsl --unregister $DistroName
    }
    else {
        Write-Host "已取消"
    }
}
