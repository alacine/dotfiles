# DevBox 镜像构建

Packer 构建基础镜像；当前目录的 Terraform 配置使用本地 libvirt 管理 Arch QEMU 虚拟机。

## 前提

- 安装 Packer、QEMU/KVM；当前用户能够访问 /dev/kvm。
- 默认使用 `~/.ssh/id_ed25519.pub`，该公钥文件必须存在。
- 使用其他公钥时，添加 `-var 'ssh_public_key_path=~/.ssh/id_rsa.pub'` 覆盖默认值。
- 在 devbox 目录运行以下命令，每次明确指定模板文件。
- Arch 模板也保留 VirtualBox、VMware、Parallels 构建器，需要对应平台环境。

## Arch Linux

```bash
packer init arch-template.pkr.hcl
packer build -only=qemu.arch arch-template.pkr.hcl
```

输出：`output/arch-qemu/arch.qcow2`。

QEMU 镜像包含 cloud-init，仅接受 NoCloud seed；首次启动时通过 Terraform 注入
`devbox` 的 SSH 公钥，并为每台虚拟机生成独立的 SSH 主机密钥。
修改 Packer 模板后必须重新构建镜像，旧 QCOW2 不具备这些配置。

构建 VirtualBox 镜像：

```bash
packer build -only=virtualbox-iso.arch arch-template.pkr.hcl
```

依次构建 QEMU 和 VirtualBox 镜像：

```bash
packer build -parallel-builds=1 -only=qemu.arch,virtualbox-iso.arch arch-template.pkr.hcl
```

`scripts/` 中的 Arch 安装脚本参考 [packer-arch](https://github.com/elasticdog/packer-arch)。

## Debian

```bash
packer init debian-template.pkr.hcl
packer build -only=qemu.debian debian-template.pkr.hcl
```

输出：`output/debian-qemu/debian.qcow2`。

构建 VirtualBox 镜像：

```bash
packer build -only=virtualbox-iso.debian debian-template.pkr.hcl
```

输出目录：`output/debian-virtualbox/`。

所有构建结果都放在 `output/` 下；各构建器使用独立子目录，避免 Packer 因输出目录已存在而拒绝构建。

依次构建 QEMU 和 VirtualBox 镜像：

```bash
packer build -parallel-builds=1 -only=qemu.debian,virtualbox-iso.debian debian-template.pkr.hcl
```

模板中的 ISO 地址和校验和必须配套更新。

## 登录与后续部署

镜像账户为 `devbox`。构建阶段临时使用 `devbox/devbox` 连接；最终关机前锁定
devbox 和 root 的密码，devbox 保留免密 sudo 权限。
Debian 以及 Arch 的非 QEMU 镜像在构建时将公钥写入 `authorized_keys`，尚未配置 cloud-init。
Arch QEMU 镜像的公钥由 Terraform 在首次启动时通过 cloud-init 注入。
旧的目录共享也不会自动恢复，需要在后续虚拟机配置中显式添加 virtiofs。

## 本地 Arch Terraform

需要本机 libvirt/KVM、可用的 `default` 存储池和 NAT 网络，以及能访问
`qemu:///system` 的当前用户。先构建上面的 Arch QEMU 镜像，再在 `devbox/` 目录运行：

```bash
terraform init
terraform plan
terraform apply
ssh arch-devbox
virsh -c qemu:///system domifaddr arch-devbox --source lease
virsh -c qemu:///system console arch-devbox
virt-viewer -c qemu:///system arch-devbox
```

串口按 `Ctrl+]` 退出；VNC 仅监听本机。默认镜像为 `output/arch-qemu/arch.qcow2`，
默认公钥为 `~/.ssh/id_ed25519.pub`。Terraform 将镜像复制到存储池，生成独立的
NoCloud ISO，不修改 Packer 产物。
`terraform apply` 会在宿主机 SSH 配置开头确保存在 `Include ~/.ssh/config.d/*.conf`，
并维护 `~/.ssh/config.d/arch-devbox.conf`，可以直接使用 `ssh arch-devbox` 登录。
私钥路径由 `ssh_public_key_path` 去掉 `.pub` 得到；如果 DHCP 地址变化，再次运行
`terraform apply` 会更新 SSH 条目。设置本地登录密码可运行 `sudo passwd devbox`；
否则串口和图形登录界面虽可显示，但锁定的账户密码无法用于登录。
其他存储池、网络、镜像或密钥路径可通过 `-var` 覆盖；销毁虚拟机和 Terraform
创建的磁盘使用 `terraform destroy`。

在已部署的 Arch 虚拟机中，可拉取此仓库并运行：

```bash
git clone <你的仓库地址> ~/dotfiles
cd ~/dotfiles
make setup-mirror
make install-cli
make deploy
```

镜像需要重新构建才能获得以上变更；现有虚拟机与本地历史状态不受影响。
