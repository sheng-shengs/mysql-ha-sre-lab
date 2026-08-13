# Docker 常用命令

function Get-DockerVersion {
    docker version
}

function Get-ComposeVersion {
    docker compose version
}

# 会拉取并临时运行 hello-world 镜像。
function Test-DockerHelloWorld {
    docker run --rm hello-world
}

function Get-DockerProxyInfo {
    docker info --format 'Server={{.ServerVersion}} HTTPProxy={{.HTTPProxy}} HTTPSProxy={{.HTTPSProxy}} NoProxy={{.NoProxy}}'
}

function Get-AllContainers {
    docker ps -a
}

function Enter-Container {
    param(
        [Parameter(Mandatory)]
        [string]$ContainerName,

        [string]$Shell = "sh"
    )

    docker exec -it $ContainerName $Shell
}

function Get-ContainerLogs {
    param(
        [Parameter(Mandatory)]
        [string]$ContainerName,

        [ValidateRange(1, 1000)]
        [int]$Tail = 50
    )

    docker logs --tail $Tail $ContainerName
}

function Get-Volumes {
    docker volume ls
}
