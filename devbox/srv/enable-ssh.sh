#!/usr/bin/env bash
set -euo pipefail

PASSWORD="$(/usr/bin/openssl passwd -6 'devbox')"

# Development user for Packer provisioning
/usr/bin/useradd --password "${PASSWORD}" --comment 'DevBox User' --create-home --user-group devbox
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_devbox
echo 'devbox ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_devbox
/usr/bin/chmod 0440 /etc/sudoers.d/10_devbox
/usr/bin/systemctl start sshd.service
