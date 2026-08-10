# 清理说明

本实验分为四种状态，清理时不要混淆。

## A. 删除 Ubuntu 内的实验目录

进入主 Ubuntu 后先确认目标：

```bash
readlink -f ~/wsl-command-lab
ls -la ~/wsl-command-lab
```

确认输出路径确实是 `/home/jiang/wsl-command-lab` 后执行：

```bash
bash /mnt/c/Users/jiang/Documents/practice/wsl-command-lab/scripts/cleanup-inside-wsl.sh
```

脚本要求输入 `DELETE WSL LAB`，输入错误不会删除。

## B. 删除 Windows 仓库中的实验报告

先预览 Git 未跟踪文件：

```powershell
git clean -nd -- wsl-command-lab
```

只删除确认过的报告或导出文件，不要对整个仓库运行 `git clean -fd`。导出的 tar 文件可以单独删除：

```powershell
Remove-Item -LiteralPath '.\wsl-command-lab\exports\ubuntu-24.04-lab.tar' -Force
```

## C. 删除临时发行版

只有确认名称完全是 `WSL-Command-Lab-Temp` 后才能执行：

```powershell
.\wsl-command-lab\scripts\cleanup-temp-distro.ps1
```

等价的核心命令是：

```powershell
wsl --unregister WSL-Command-Lab-Temp
```

这个命令永久删除临时发行版。绝对不要把 `Ubuntu-24.04` 作为参数。

## D. 停止但不删除 WSL

```powershell
wsl --terminate Ubuntu-24.04
wsl --shutdown
```

它们只停止运行中的 WSL，不会删除文件和发行版。

## 最终检查

```powershell
wsl --list --verbose
Test-Path '.\wsl-command-lab\exports\ubuntu-24.04-lab.tar'
```

主发行版 `Ubuntu-24.04` 应仍在列表中；导出文件是否存在取决于你是否选择保留备份。
