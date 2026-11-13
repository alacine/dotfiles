# DevBox

在仓库根目录运行 `cd devbox`。需要 Packer、QEMU/KVM、Terraform、本机 libvirt，以及可用的 `default` 存储池和 NAT 网络。当前用户须能访问 `/dev/kvm` 和 `qemu:///system`；默认 SSH 公钥 `~/.ssh/id_ed25519.pub` 须存在。

## 1. 构建镜像

```bash
packer init arch-template.pkr.hcl
packer build -only=qemu.arch arch-template.pkr.hcl
packer init debian-template.pkr.hcl
packer build -only=qemu.debian debian-template.pkr.hcl
```

生成 `output/arch-qemu/arch.qcow2` 和 `output/debian-qemu/debian.qcow2`。修改模板后，重新运行对应的 `packer build`。Debian 构建时会写入公钥，因此构建和部署须使用同一把密钥。

如需 VirtualBox 镜像，运行：

```bash
packer build -only=virtualbox-iso.arch arch-template.pkr.hcl
packer build -only=virtualbox-iso.debian debian-template.pkr.hcl
```

结果位于 `output/` 下各自的 VirtualBox 子目录。

## 2. 创建并登录虚拟机

```bash
terraform init
terraform plan
terraform apply
ssh arch-devbox
ssh debian-devbox
```

`terraform apply` 创建两台本地虚拟机，并写入 SSH 配置，可直接使用上述别名登录。Arch 的公钥在首次启动时注入；两台虚拟机的 `devbox` 账户都禁用密码登录，保留免密 sudo。

要查看 Arch 串口或图形界面，运行：

```bash
virsh -c qemu:///system console arch-devbox
virt-viewer -c qemu:///system arch-devbox
```

串口按 `Ctrl+]` 退出。需要在串口或图形界面登录时，先通过 SSH 运行 `sudo passwd devbox` 设置密码。其他镜像、密钥、存储池或网络可用 Terraform 的 `-var` 参数覆盖，变量见 [variables.tf](variables.tf)。

销毁虚拟机及 Terraform 创建的磁盘：

```bash
terraform destroy
```

## 3. 配置 Arch 虚拟机（可选）

登录 Arch 虚拟机后运行：

```bash
git clone YOUR_REPO_URL ~/dotfiles
cd ~/dotfiles
make setup-mirror
make install-cli
make deploy
```
