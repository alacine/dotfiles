#!/bin/bash
set -e -o pipefail

if grep -E '^\[archlinuxcn\]' -A 5 /etc/pacman.conf; then
    exit 0
fi

# add archlinuxcn
cat >> /etc/pacman.conf << EOF
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
Server = https://repo.archlinuxcn.org/\$arch
EOF
