# Repository Guidelines

## Project Structure & Module Organization

This repository manages personal Arch Linux dotfiles with GNU Stow. `userhome/` mirrors `$HOME`; `userhome-macos/` adds macOS-specific files during deployment. Neovim configuration lives in `userhome/.config/nvim/`, with plugin settings under `lua/plugins/` and LSP definitions under `lsp/`. `pkg/` contains `PKGBUILD-cli`, `PKGBUILD-gui`, and `aur-*.txt` package lists. `system/` holds system-level configuration that requires manual installation. `homelab/` contains Proxmox Terraform, Packer, and Ansible files; `devbox/` contains local libvirt Terraform and VM image builds. `scripts/` holds setup helpers.

## Build, Test, and Development Commands

Run `make help` to see available targets. `make deploy` links dotfiles into `$HOME` with Stow; `make withdraw` removes those links. `make install-cli` installs the CLI package set, while `make install` installs the full GUI set. `make setup-mirror` configures the Arch Linux CN mirror and requires sudo. `make setup-ai` generates shared AI coding rules and deploys them. For VM work, run `terraform init`, `terraform plan`, and `terraform apply` from `homelab/` or `devbox/`; see each directory's readme for prerequisites. Build devbox images with Packer before applying its Terraform configuration.

## Coding Style & Naming Conventions

Follow the style of the file being edited. Quote shell variables and use `[[ ... ]]` in Bash or Zsh scripts; use `set -e -o pipefail` where appropriate. Format Terraform with `terraform fmt`; keep variables in `vars.tf` or `variables.tf` according to the directory. Use two-space indentation for YAML and Lua plugin files, and format Lua with StyLua. Keep Neovim plugins in separate `lua/plugins/*.lua` files. Edit source rules in `userhome/.config/ai-coding/`, not generated output.

## Testing Guidelines

There is no repository-wide test suite or coverage target. Validate only the affected area: run `terraform fmt -check` and `terraform validate` inside the changed Terraform directory, `shellcheck` on edited shell scripts when available, and `ansible-lint homelab/ansible/playbook/` for Ansible changes. Review `git diff --check` before committing. Infrastructure `apply` commands change real resources; use `plan` to inspect changes first.

## Commit & Pull Request Guidelines

Recent commits use short English subjects such as `update devbox` and `add voxtype`. Keep each commit focused and describe the changed component. Pull requests should explain the purpose, list validation performed, and call out deployment or infrastructure effects. Include screenshots for visible desktop changes.

## Security & Deployment

Never commit credentials, private keys, Terraform state, or `*.tfvars`; check `.gitignore` before staging. Add user configuration under `userhome/` and deploy it with `make deploy` rather than copying files into `$HOME`. Follow `system/README.md` for system-level files.
