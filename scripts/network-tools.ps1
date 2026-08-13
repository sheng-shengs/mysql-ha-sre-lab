# 网络与代理诊断工具
# 除 Flush-Dns 以外，所有函数都只读取状态。

function Test-HttpConnect {
    param(
        [string]$Url = "https://github.com"
    )

    curl.exe -I --connect-timeout 10 $Url
}

function Get-WinHttpProxy {
    netsh winhttp show proxy
}

function Get-SystemProxy {
    Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' |
        Select-Object ProxyEnable, ProxyServer, AutoConfigURL
}

# 清除 Windows DNS 缓存，会修改当前系统状态。
function Flush-DnsCache {
    ipconfig /flushdns
}
