#!/usr/bin/env bash
set -euo pipefail

pacman -S --noconfirm --needed cloud-init

install -d -m 0755 /etc/cloud/cloud.cfg.d
printf '%s\n' \
  'datasource_list: [ NoCloud ]' \
  'network:' \
  '  config: disabled' \
  > /etc/cloud/cloud.cfg.d/90-devbox.cfg

systemctl enable cloud-init-local.service cloud-init-main.service cloud-config.service cloud-final.service
systemctl enable serial-getty@ttyS0.service
