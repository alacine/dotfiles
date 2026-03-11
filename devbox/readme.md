## DevBox Arch 虚拟机开发环境

```bash
gem install vagrant-libvirt
vagrant plugin install vagrant-libvirt
```

```bash
packer build -only=qemu.arch arch-template.pkr.hcl
packer build -parallel-builds=1 -only=qemu.arch,virtualbox-iso.arch arch-template.pkr.hcl
```

```bash
vagrant box add arch ./output/packer_arch_libvirt-2026.03.01.box
vagrant up
```

`scripts/` 中的脚本参考 [packer-arch](https://github.com/elasticdog/packer-arch)


考虑到墙，手动下载公钥
```bash
/usr/bin/curl --output /home/vagrant/.ssh/authorized_keys --location https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
# 手动执行获取公钥
curl -s --location https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
```

然后手动替换为
```bash
echo 'ssh-rsa XXXXX vagrant insecure public key' > /home/vagrant/.ssh/authorized_keys
```
