# 系统级配置

防止内存耗尽导致系统完全卡死的配置文件。

## 包含的配置

### 1. 内核参数 (`etc/sysctl.d/99-memory.conf`)

- `vm.swappiness = 180`: 因为使用 zram，可以积极使用 swap
- `vm.vfs_cache_pressure = 50`: 保留更多文件系统缓存
- `vm.panic_on_oom = 0`: 让 OOM killer 处理，不要 panic

### 2. Zram 配置 (`etc/systemd/zram-generator.conf`)

创建压缩的内存 swap（8GB），比磁盘 swap 快得多。

### 3. Earlyoom

使用默认配置，在内存压力过大时自动杀掉占用内存最多的进程。

## 部署步骤

### 1. 安装必要的软件包

```bash
sudo pacman -S zram-generator earlyoom
```

### 2. 部署配置文件

```bash
# 内核参数
sudo cp etc/sysctl.d/99-memory.conf /etc/sysctl.d/
sudo sysctl -p /etc/sysctl.d/99-memory.conf

# Zram 配置
sudo cp etc/systemd/zram-generator.conf /etc/systemd/
```

### 3. 启用服务

```bash
# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启用 earlyoom（使用默认配置）
sudo systemctl enable --now earlyoom.service
```

### 4. 重启系统以启用 zram

```bash
sudo reboot
```

## 验证配置

重启后，检查配置是否生效：

```bash
# 检查 zram 是否启用
zramctl
swapon --show

# 应该看到类似输出：
# NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
# /dev/zram0 zstd          8G   4K    B    12K       8 [SWAP]

# 检查内核参数
sysctl vm.swappiness vm.vfs_cache_pressure vm.panic_on_oom

# 检查 earlyoom 状态
systemctl status earlyoom

# 查看内存和 swap 状态
free -h
```

## 预期效果

配置后，即使 rust-analyzer 或其他程序占用大量内存：

1. **Zram** 提供 8GB 压缩 swap 缓冲
2. **Earlyoom** 在内存压力过大时自动杀掉占用内存最多的进程
3. **系统保持响应**，至少可以切换到 TTY (Ctrl+Alt+F2)

## 监控内存使用

```bash
# 实时监控内存
watch -n 1 free -h

# 查看占用内存最多的进程
ps aux --sort=-%mem | head -10

# 查看 earlyoom 日志
journalctl -u earlyoom -f
```

## 故障排除

### Zram 未启动

```bash
# 检查 zram-generator 是否安装
pacman -Q zram-generator

# 手动加载 zram 模块
sudo modprobe zram

# 检查配置文件
cat /etc/systemd/zram-generator.conf
```

### Earlyoom 未工作

```bash
# 查看日志
journalctl -u earlyoom -n 50

# 重启服务
sudo systemctl restart earlyoom
```

## 调整建议

### 调整 swappiness

如果使用磁盘 swap 而不是 zram，将 swappiness 改为 10：

```bash
# 编辑 /etc/sysctl.d/99-memory.conf
vm.swappiness = 10

# 应用
sudo sysctl -p /etc/sysctl.d/99-memory.conf
```
