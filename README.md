# Tick

> **"Give your modules a heart beat." —— 为你的模块注入心跳。**

---

- 本模块为前置模块，作为kam模块构建系统的一个重要基础组件
本模块将用于测试kam模块构建系统的模块依赖解析功能


---

# Q&A

- Q:为什么使用pueue而不使用cron?

> A: 本模块前身是Unicron,基于crond+crontab
> pueue是更加现代的选择，功能丰富得多，用起来更加简单，可视化做的更好。

- Q: 模块耗电嘛？
> A: 如果没有注册任何任务，本模块完全不耗电，本模块设计为按需加载。

---
<details>
  <summary>点击查看开发者协议</summary>

# Tick Framework 开发者接入协议 v1

> Tick 是一个基于 Pueue 的封装，正如简介，Magisk/apatch/kernelsu 赋予模块以生命，那么tick模块，则赋予模块以心跳。

 ---

## 1. 命名契约 (The Identifier)

> 为了实现多模块任务隔离与自动维护，所有任务标识符必须遵循以下约定：

 - **格式**：`模块ID:任务名称`

 - **示例**：`MagicNet:task_a`
 
 - **约束**：
     - `模块ID` 必须与该任务所属的 Magisk 模块文件夹名 (`MODID`) 完全一致。
     - `任务名称` 建议仅使用字母、数字、下划线。

 ---
 
 ### 2. 核心 API 指令 (CLI API)

> 所有操作均通过 `/system/bin/tick` 调用。框架会自动处理守护进程的单例启动。

 #### A. 注册/更新定时任务 (reg)
 **用法**: `tick reg "模块ID:任务名称" "时间频率" "完整执行命令"`
 - **时间频率示例**: 
     - 缩写: `"30s"`, `"15m"`, `"1h"`, `"2d"`
     - Cron: `"0 3 * * *"` (标准 Cron 表达式)
 - **特性**: 幂等性设计。若 ID 已存在，则自动更新配置并重置计时。
 
#### B. 注销定时任务 (unreg)
 **用法**: `tick unreg "模块ID:任务名称"`
  
#### C. 查看状态与日志 (Query)

 **用法**: 
 - `tick st` : 概览所有已注册任务及其状态、下次触发时间。
 - `tick log "模块ID:任务名称"` : 查看该任务最后一次执行的详细终端输出。

---

### 3. 接入最佳实践 (Best Practices)

> 建议在模块的 `service.sh` 中通过以下方式注册：

```bash
if [ -f "/system/bin/tick" ]; then
    tick reg "\${MODID}:optimize" "15m" "sh \${MODDIR}/scripts/opt.sh"
fi
```

---

### 4. 框架保障 (Framework Guarantees)

 - **按需启动 (Lazy-Start)**: 无任务时不产生后台进程，首次调用自动静默唤醒。
 - **进程唯一 (Singleton)**: 内置 `flock` 文件锁，防止高并发调用产生多个实例。
 - **模块隔离 (Isolation)**: 每个模块 ID 拥有独立任务组，互不阻塞，默认组内并发数为 1。
 - **隐藏型&安全 (Security)**: 通讯 Socket 位于 `/data/adb/tick`，严格 `700/600` 权限。
 - **自动清理 (Auto-Clean)**: 模块被卸载后，下次重启会自动识别并注销对应的残留任务。
 
 ---
 **Tick Framework 2025 - Powered by Pueue & Rust**

</details>