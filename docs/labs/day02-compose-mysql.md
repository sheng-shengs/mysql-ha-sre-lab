# Day02:使用 Docker Compose 部署MySQL

### 目标
将MySQL容器参数写入Compose文件，配置可重复部署、健康检查和数据持久化验证。

### 环境准备
Windows + WSL2 Ubuntu24-04
Docker desktop
MySQL8.4
实验端口：3308
```
C:\Users\jiang\Documents\practice
    |-docs
        |-labs
            |-day01-docker.md
            |-day02-compose-mysql.md
    |-compose
        |-day02-mysql
            |-init
                |-01-init.sql
            |-compose.yaml
            |-.env
```
### 实验原则
Day02使用单独的容器、数据卷和端口，不影响Day01的实验。
密码不提交至github。
每一步记录命令、预期效果和实际效果。

### 实验准备
```
创建新目录：
PS C:\Users\jiang\Documents\practice> Get-ChildItem .\docs\labs
    目录: C:\Users\jiang\Documents\practice\docs\labs
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2026/8/13     21:44          22723 day01-docker.md
-a----         2026/8/13      0:14         179414 image-1.png
-a----         2026/8/13     17:00         213351 image-2.png
-a----         2026/8/13     17:00         199963 image-3.png
-a----         2026/8/13      0:08         148327 image.png

PS C:\Users\jiang\Documents\practice\docs\labs> New-Item -ItemType File day02-compose-mysql.md
    目录: C:\Users\jiang\Documents\practice\docs\labs
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2026/8/16      1:19              0 day02-compose-mysql.md

PS C:\Users\jiang\Documents\practice> New-Item -Itemtype Directory -Force .\compose\day02-mysql\init
    目录: C:\Users\jiang\Documents\practice\compose\day02-mysql
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2026/8/16      1:25                init

检查新目录的创建：
PS C:\Users\jiang\Documents\practice> Get-ChildItem .\compose\day02-mysql\
    目录: C:\Users\jiang\Documents\practice\compose\day02-mysql
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2026/8/16      1:25                init


编写compose.yaml和.env文件：
编写 compose.yaml ：
PS C:\Users\jiang\Documents\practice> code .\compose\day02-mysql\compose.yaml

编写 .env 文件，且不提交至github：
PS C:\Users\jiang\Documents\practice> code .\compose\day02-mysql\.env


PS C:\Users\jiang\Documents\practice> git check-ignore -v .\compose\day02-mysql\.env
.gitignore:1:.env       ".\\compose\\day02-mysql\\.env"


\init\01-init.sql作为初始化脚本挂载在容器内的docker-entrypoint-initdb.d 目录下，只在数据卷首次使用时执行：
PS C:\Users\jiang\Documents\practice> code .\compose\day02-mysql\init\01-init.sql
```

### 实验原理补充
```
初始化：
空数据卷
    首次启动MySQL
    自动执行初始化脚本.sql文件
    得到确定的库、表和测试数据
```

检查容器状态：
容器状态分为三种，分别是Up...(healthy)(MySQL已可用)、Up...(healthy:starting)(仍在初始化，MySQL暂不可用)、Exited或unhealthy(需看日志排障)

docker compose down 和docker compose down -v 区别：
-v 会额外删除数据卷，实验数据会丢失。

### 实验步骤
```
在初始化脚本所在文件夹下检查 .yaml 和 .env 文件和变量引用是否有误，无误则输出 0 表示配置校验通过，这一步只检查暂不启动SQL：
jiang@jiang:~$ cd /mnt/c/Users/jiang/Documents/practice/compose/day02-mysql
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose config --quiet
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ echo $?
0

在Ubuntu24.04中启动容器并后台运行，会自动获取该目录下的.yaml文件并执行文件中的内容，可以看到容器、数据卷、网络已构建成功；但Started 并不代表成功，还需查看状态是否健康（healthy），重点看 STATUS ：
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose up -d
[+] up 3/3
 ✔ Network day02-mysql_default Created                                                                              0.2s
 ✔ Volume day02-mysql-data     Created                                                                              0.0s
 ✔ Container day02-mysql       Started

 jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql/init$ docker compose ps
NAME          IMAGE       COMMAND                  SERVICE   CREATED          STATUS                    PORTS
day02-mysql   mysql:8.4   "docker-entrypoint.s…"   mysql     57 minutes ago   Up 57 minutes (healthy)   0.0.0.0:3308->3306/tcp, [::]:3308->3306/tcp

```

```
以上说明MySQL已启动，且docker 的健康检查连接成功，接下来需要验证是否自动执行了初始化脚本，并得到确定的库、表和测试数据。
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose exec mysql mysql -uroot -p -e "SHOW DATABASES;SHOW TABLES FROM lab;SELECT * FROM lab.users;"
Enter password:
+--------------------+
| Database           |
+--------------------+
| information_schema |
| lab                |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
+---------------+
| Tables_in_lab |
+---------------+
| users         |
+---------------+
+----+------------+---------------------+
| id | name       | created_at          |
+----+------------+---------------------+
|  1 | day02-seed | 2026-08-16 10:35:44 |
+----+------------+---------------------+
lab，users，day02-seed 都已创建，说明初始化成功，Compose、MySQL初始化和SQL挂载都已成功
```

```
接下来验证数据持久化，向数据表插入数据，可以看到数据已持久化，重启容器后数据依然存在：
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose exec mysql mysql -uroot -p -e "INSERT INTO lab.users(name) values ('persistence-check-20260816');SELECT * FROM lab.users;"
Enter password:
+----+----------------------------+---------------------+
| id | name                       | created_at          |
+----+----------------------------+---------------------+
|  1 | day02-seed                 | 2026-08-16 10:35:44 |
|  2 | persistence-check-20260816 | 2026-08-16 14:07:48 |
+----+----------------------------+---------------------+
```

### 故障实验
```
删除day02容器本身（删除容器和网络、释放端口成功），但不会删除day02容器挂载的数据卷；数据仍然存在，重新运行.yaml文件：
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose down
[+] down 2/2
 ✔ Container day02-mysql       Removed                                                                              3.5s
 ✔ Network day02-mysql_default Removed


数据卷仍存在，并且是Compose管理的2卷：
 jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker volume inspect day02-mysql-data
[
    {
        "CreatedAt": "2026-08-16T10:35:32Z",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.config-hash": "b420f3a343c1fb7726d08421af1182e189aefd73df5764e7bde703c82293f2da",
            "com.docker.compose.project": "day02-mysql",
            "com.docker.compose.version": "5.3.1",
            "com.docker.compose.volume": "day02-mysql-data"
        },
        "Mountpoint": "/var/lib/docker/volumes/day02-mysql-data/_data",
        "Name": "day02-mysql-data",
        "Options": null,
        "Scope": "local"
    }
]


重新运行 .yaml 文件，创建容器本身和网络，但不再创建新数据卷，并在 Started 的情况下查看状态是否健康，健康则进一步查看数据是否无需新建仍存在：
jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose up -d
[+] up 2/2
 ✔ Network day02-mysql_default Created                                                                              0.1s
 ✔ Container day02-mysql       Started                                                                              0.7s

jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose ps
NAME          IMAGE       COMMAND                  SERVICE   CREATED              STATUS                        PORTS
day02-mysql   mysql:8.4   "docker-entrypoint.s…"   mysql     About a minute ago   Up About a minute (healthy)   0.0.0.0:3308->3306/tcp, [::]:3308->3306/tcp

jiang@jiang:/mnt/c/Users/jiang/Documents/practice/compose/day02-mysql$ docker compose exec mysql mysql -uroot -p -e "SHOW DATABASES;SELECT * FROM lab.users;"
Enter password:
+--------------------+
| Database           |
+--------------------+
| information_schema |
| lab                |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
+----+----------------------------+---------------------+
| id | name                       | created_at          |
+----+----------------------------+---------------------+
|  1 | day02-seed                 | 2026-08-16 10:35:44 |
|  2 | persistence-check-20260816 | 2026-08-16 14:07:48 |
+----+----------------------------+---------------------+
```

### 部署与验证
使用 `docker compose config --quiet` 校验配置，退出码为 0。
使用 `docker compose up -d` 创建 Day 2 专用网络、数据卷和容器。
使用 `docker compose ps` 确认容器状态为 healthy。
查询确认 lab.users 中存在初始化数据 day02-seed。
插入持久化验证数据 persistence-check-20260816。
执行 `docker compose down` 删除容器和网络，但不删除数据卷。
使用 `docker volume inspect day02-mysql-data` 确认数据卷仍存在。
再次执行 `docker compose up -d` 重建容器。
查询 lab.users，两条数据均仍存在。

### 实验结论
使用Compose管理容器，通过初始化脚本实现容器快捷可重复部署的启动运行，同时在.yaml文件中调用魔法目录，实现SQL文件的自动挂载，拉取存在于wsl的.sql文件自动创建测试数据，并通过.env文件保存密码；
通过故障实验删除容器并不会影响数据卷的数据存储，利用.yaml文件重新运行容器，不再初始化新容器，同时可以查询到已删除容器仍存在的数据，说明Compose管理容器，与直接运行类似，数据依然存在于指定数据卷。