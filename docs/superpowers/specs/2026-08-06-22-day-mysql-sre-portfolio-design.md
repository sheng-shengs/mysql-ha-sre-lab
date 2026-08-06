# 22天 MySQL 高可用与 SRE 作品集设计

## 目标

用22天将基础的 Linux 和 MySQL 命令经验，转化为可被招聘方验证的数据库运维能力。最终交付一个 GitHub 仓库，证明候选人可以完成 MySQL 部署、复制、高可用、监控、性能分析、故障处理和云原生数据库初步实践。

## 环境与约束

- 时间：22天，每天3至5小时。
- 主机：Windows 11 家庭版，Ryzen 7 8845H，约28GB可用内存，虚拟化已启用。
- 学习基础：接触过 Linux 和 MySQL，但主要是基础命令。
- 主要环境：WSL2 Ubuntu、Docker Compose、kind。
- 成本原则：前20天使用本地环境；腾讯云仅作为可选的短时验证环境。

## 作品集定义

作品集是一个可复现、可检查、可讲解的工程项目，不是软件安装截图或转载的学习笔记。

作品集的主体放在 GitHub 公开仓库 `mysql-ha-sre-lab`。仓库中不存放真实密码、云 API 密钥、私有 IP、客户数据或大体积备份文件。演示视频可上传到视频平台，在 README 中放链接；关键截图放入仓库 `docs/images/`。

## 仓库结构

```text
mysql-ha-sre-lab/
|-- README.md
|-- LICENSE
|-- .gitignore
|-- compose/
|   |-- docker-compose.yml
|   `-- env.example
|-- mysql/
|   |-- primary/
|   |-- replicas/
|   `-- sql/
|-- orchestrator/
|-- proxysql/
|-- monitoring/
|   |-- prometheus/
|   `-- grafana/
|-- scripts/
|   |-- deploy/
|   |-- verify/
|   |-- backup/
|   `-- failure-injection/
|-- kubernetes/
|   `-- mysql-operator/
|-- benchmarks/
|   |-- raw/
|   `-- reports/
|-- runbooks/
|-- postmortems/
`-- docs/
    |-- architecture.md
    |-- learning-log.md
    `-- images/
```

## 展示内容

README 是招聘方的入口，应在前两屏展示：

1. 项目一句话目标和所解决的问题。
2. 架构图和组件职责。
3. 一键部署与验证方法。
4. 主库故障切换、复制延迟、慢 SQL 与容量告警的演示结果。
5. 性能优化前后的 TPS、P95/P99 延迟和资源使用对比。
6. 故障复盘、运维手册和演示视频入口。

## 22天范围

- 第1至4天：Linux、TCP/IP、Git、MySQL单机、权限、配置与日志。
- 第5至8天：索引、执行计划、慢查询、sysbench 和 Percona Toolkit。
- 第9至12天：一主两从、GTID、binlog、复制故障与数据一致性。
- 第13至16天：Orchestrator、ProxySQL、自动切换、读写分离和故障演练。
- 第17至18天：Prometheus、mysqld_exporter、Grafana、告警和容量分析。
- 第19至20天：kind、MySQL Operator、MGR/InnoDB Cluster 与传统方案对比。
- 第21天：从空白环境重建，或短时使用腾讯云验证自动化。
- 第22天：整理 GitHub、演示视频、简历描述和面试讲解。

## 学习闭环

每天都按以下顺序完成：

1. 用自己的话写出当天组件解决的问题。
2. 参考官方文档手工完成一次。
3. 将重复步骤转成配置或脚本。
4. 主动制造一个故障，通过日志、指标和系统状态排查。
5. 记录现象、假设、证据、根因、恢复和改进。
6. 不看文档完成当天验收，然后提交 Git。

## 公网部署决策

作品集不要求长期公网运行。招聘方可通过代码、配置、测试数据、截图和视频验证项目。

若第21天使用腾讯云：

- 数据库仅使用私网地址，不开放 `3306` 到公网。
- SSH 限制为当前公网 IP，不使用 `0.0.0.0/0`。
- 使用测试数据和临时凭据。
- 完成演示后当天销毁计算、磁盘、公网 IP 和负载均衡资源。

## 验收标准

- 新环境能按 README 在60分钟内启动完整实验。
- 能演示主库故障、拓扑发现、切换和客户端恢复。
- 能演示慢 SQL 定位和至少一次有数据支持的优化。
- 监控页面能展示主机、MySQL、复制和代理核心指标。
- 至少四份故障复盘和三份运维手册。
- README 不依赖口头解释即可让读者理解项目。
- 候选人能在5分钟内讲清架构、权衡、一次故障和一次优化。

## 不在本期范围

- PostgreSQL、OpenStack、Exchange、Fortinet、F5 和完整 Windows Server 实验。
- 生产级跨地域灾备或真实业务数据。
- 长期运行的公网演示站点。
- 为大型开源项目贡献核心代码。
