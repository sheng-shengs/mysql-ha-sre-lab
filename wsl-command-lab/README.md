# WSL Command Lab

一个可回滚的 WSL2 命令实验室，用来熟悉 Microsoft Learn 的 [WSL 基本命令](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)。

## 目标

- 查看 WSL 状态、版本和已安装的发行版
- 从 PowerShell 以指定发行版、用户、目录和命令启动 Linux
- 在 Ubuntu 内查看用户、内核、磁盘、内存和网络状态
- 将主发行版导出并导入为临时副本
- 只删除实验产生的目录和临时发行版

## 安全边界

- 主发行版名称假定为 `Ubuntu-24.04`，不要注销它。
- 临时发行版固定使用 `WSL-Command-Lab-Temp`。
- 本实验不使用 `wsl --mount`，因为它操作真实磁盘设备。
- `wsl --unregister` 会永久删除指定发行版的数据，只能对临时发行版执行。
- 导出的 tar 文件可能较大，开始前确认磁盘空间。

## 1. Windows 侧只读检查

在 PowerShell 中，从仓库根目录执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\wsl-command-lab\scripts\inspect-wsl.ps1 -Distro Ubuntu-24.04
```

报告会写入 `wsl-command-lab/reports/`，保存可稳定读取的版本和发行版列表；`status` 与 `help` 会记录为命令提示，建议直接在 PowerShell 中执行以保留原生控制台编码。

## 2. 在 Ubuntu 内执行检查

```powershell
wsl --distribution Ubuntu-24.04 --user jiang --cd ~
```

在 Ubuntu 中执行：

```bash
bash /mnt/c/Users/jiang/Documents/practice/wsl-command-lab/scripts/run-inside-wsl.sh
```

脚本只会创建 `~/wsl-command-lab/report.txt`，不会修改系统配置。

## 3. 熟悉生命周期命令

在 PowerShell 中逐条执行并观察状态：

```powershell
wsl --list --verbose
wsl --terminate Ubuntu-24.04
wsl --list --verbose
wsl --distribution Ubuntu-24.04 --exec bash -lc "echo running again; whoami; pwd"
wsl --shutdown
wsl --list --verbose
```

`--terminate` 停止一个发行版，`--shutdown` 停止所有 WSL2 虚拟机；两者都不会删除发行版数据。

## 4. 可选：导出、导入和注销临时副本

确认磁盘空间后执行：

```powershell
$labRoot = Join-Path (Get-Location) 'wsl-command-lab'
New-Item -ItemType Directory -Force -Path "$labRoot\exports", "$labRoot\instances" | Out-Null
wsl --shutdown
wsl --export Ubuntu-24.04 "$labRoot\exports\ubuntu-24.04-lab.tar"
wsl --import WSL-Command-Lab-Temp "$labRoot\instances\temp" "$labRoot\exports\ubuntu-24.04-lab.tar" --version 2
wsl --list --verbose
wsl --distribution WSL-Command-Lab-Temp --exec bash -lc "echo temporary distro; cat /etc/os-release"
```

这一步只在临时副本上练习 `--distribution`、`--exec` 和 `--unregister`，不要改变主 Ubuntu。

## 5. 记录和提交

将命令、关键输出、理解和问题写入 `wsl-command-lab/docs/`，不要把所有终端输出无差别复制进去。完成清理后提交：

```powershell
git add wsl-command-lab
git commit -m "feat: add reversible wsl command lab"
```
