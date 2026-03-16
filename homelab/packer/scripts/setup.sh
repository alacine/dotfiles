#!/bin/bash
set -eux

# 换源（可选，境外慢时启用）
# cat > /etc/apt/sources.list << 'EOF'
# deb https://mirrors.ustc.edu.cn/debian trixie main non-free-firmware
# deb https://mirrors.ustc.edu.cn/debian trixie-updates main non-free-firmware
# deb https://mirrors.ustc.edu.cn/debian-security trixie-security main non-free-firmware
# EOF

# 基础包
apt-get update
apt-get install -y --no-install-recommends \
    cloud-init \
    qemu-guest-agent \
    systemd-resolved \
    sudo \
    wget \
    ca-certificates

# DNS：配置 systemd-resolved，确保首次启动时 cloud-init 跑 apt 前 DNS 已就绪
cat > /etc/systemd/resolved.conf <<'EOF'
[Resolve]
DNS=1.1.1.1 223.5.5.5
FallbackDNS=8.8.8.8
EOF
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
systemctl enable systemd-resolved

# cloud-init：清空默认数据源，只保留 NoCloud 和 ConfigDrive（PVE 用的） ─
cat >/etc/cloud/cloud.cfg.d/99-pve.cfg <<'EOF'
datasource_list: [NoCloud, ConfigDrive]
EOF

# 启用服务
# cloud-init：apt install 的 postinst 已自动 enable 各拆分 unit，无需手动处理
# qemu-guest-agent：同上，包安装时自动 enable
systemctl enable qemu-guest-agent

# 清理：让 clone 出来的每台 VM 都有独立身份

# machine-id 必须清空，否则所有 clone 的 VM 共享同一个 ID
# 第一次启动时 systemd 会自动生成新的
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id

# SSH host key 清掉，每台 VM 启动时重新生成，否则 known_hosts 会冲突
rm -f /etc/ssh/ssh_host_*

# cloud-init 状态清空，让它在下次启动时重新跑
cloud-init clean --logs

# 删掉 packer 临时用户，真实用户由 cloud-init 创建
userdel -r packer 2>/dev/null || true

# apt 缓存
apt-get clean
rm -rf /var/lib/apt/lists/*

# 历史记录
truncate -s 0 /root/.bash_history || true

# 填零压缩磁盘（减小模板体积）
dd if=/dev/zero of=/zero bs=1M 2>/dev/null || true
rm -f /zero
sync
