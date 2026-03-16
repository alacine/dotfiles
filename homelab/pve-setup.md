# PVE 初始化操作记录

## 1. 创建 Terraform/Packer 专用用户和角色

```bash
# 创建角色（PVE 9 的有效权限列表）
pveum role add TerraformProv --privs \
    "Datastore.AllocateSpace,\
    Datastore.AllocateTemplate,\
    Datastore.Allocate,\
    Datastore.Audit,\
    VM.Allocate,\
    VM.Audit,\
    VM.Clone,\
    VM.Config.CDROM,\
    VM.Config.CPU,\
    VM.Config.Cloudinit,\
    VM.Config.Disk,\
    VM.Config.HWType,\
    VM.Config.Memory,\
    VM.Config.Network,\
    VM.Config.Options,\
    VM.Console,\
    VM.GuestAgent.Audit,\
    VM.PowerMgmt,\
    Sys.Modify,\
    SDN.Use"

# 创建用户
pveum user add terraform-prov@pve

# 创建 API token（privsep 0 = token 直接继承用户权限）
pveum user token add terraform-prov@pve terraform-token --privsep 0

# 绑定角色到用户（全局）
pveum acl modify / --users terraform-prov@pve --roles TerraformProv
```

token secret 只在创建时显示一次，立即保存到 homelab/terraform.tfvars 和 packer/debian.pkrvars.hcl。

## 2. 启用 local storage snippets

`proxmox_virtual_environment_file`（content_type = "snippets"）上传 cloud-init 文件时需要 local storage 开启 snippets 支持：

```bash
pvesm set local --content vztmpl,backup,iso,snippets
```

## 3. 构建 Debian 模板（Packer）

```bash
cd homelab/packer
packer init debian-template.pkr.hcl
packer build -var-file=debian.pkrvars.hcl debian-template.pkr.hcl
```

`debian.pkrvars.hcl` 内容（不入 git）：

```hcl
proxmox_token_id     = "terraform-prov@pve!terraform-token"
proxmox_token_secret = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

构建完成后在 PVE 上用 `qm list` 查看模板 VMID，填入 `homelab/terraform.tfvars` 的 `vm_template_id`。

## 4. 网络变更历史

### 初始（有线 → 无线）

- PVE 主机 IP：`192.168.31.169` → `192.168.88.238`（WiFi，wlo1）
- vmbr0 改为无物理口内部桥：`10.10.10.1/24`
- VM 流量通过 iptables NAT MASQUERADE 经 wlo1 出网

### DNS 修复

- `/etc/resolv.conf` 从失效的 `192.168.31.1` 改为 `114.114.114.114` + `223.5.5.5`

### IPv6（vmbr0）

```bash
apt install ndisc6
# forwarding=1 时 accept_ra 默认值 1 不生效，需要显式设为 2
echo "net.ipv6.conf.vmbr0.accept_ra=2" > /etc/sysctl.d/99-ipv6-pve.conf
sysctl -p /etc/sysctl.d/99-ipv6-pve.conf
# /etc/network/interfaces 中 vmbr0 添加 iface vmbr0 inet6 auto
```

### 无线 → 有线（当前）

- PVE 主机 IP：`192.168.88.238`（WiFi wlo1）→ `192.168.88.100`（有线 eno1，vmbr0 桥接）
- WiFi 保留为备用：`192.168.88.200`（wlo1，metric 200）
- vmbr0 从无物理口内部 NAT 桥改为桥接 eno1，VM 直接获得局域网 IP（路由器 DHCP）
- 去掉 iptables NAT MASQUERADE 规则（不再需要）

## 5. 本地 SSH 配置

`~/.ssh/config` 中 pve/pve-remote 添加：

```
KexAlgorithms curve25519-sha256,ecdh-sha2-nistp256
```

消除后量子密钥交换警告。

## 注意事项

- PVE 9 移除了 `VM.Monitor` 和 `VM.Config.MoveDisks`，`VM.Config.Net` 改名为 `VM.Config.Network`
- 使用 `telmate/proxmox` Terraform provider 会因 `VM.Monitor` 检查失败，需换用 `bpg/proxmox`
- PVE 9 新增 `VM.GuestAgent.Audit` 权限，Packer 通过 guest agent 发现 VM IP 时必须有此权限，否则 API 返回 403 导致 SSH 超时
- `bpg/proxmox` provider 上传 snippets 走 SFTP（非 HTTP API），需在 provider 配置 `ssh` block；不配置时 provider 自动从 `/nodes/pve/network` 猜测节点 IP（会选到 WiFi 备用口），需用 `node { name = "pve"; address = "..." }` 显式指定
- `Datastore.Allocate` 权限用于 snippets 文件上传，缺少时报 403
