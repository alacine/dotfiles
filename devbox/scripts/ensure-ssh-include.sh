#!/usr/bin/env bash
set -euo pipefail

config="${1:-$HOME/.ssh/config}"
include='Include ~/.ssh/config.d/*.conf'

mkdir -p -- "$(dirname -- "$config")"
if [[ -f "$config" ]] && grep -Fxq -- "$include" "$config"; then
  exit 0
fi

tmp=$(mktemp "${config}.XXXXXX")
trap 'rm -f -- "$tmp"' EXIT
{
  printf '%s\n' "$include"
  if [[ -f "$config" ]]; then
    cat -- "$config"
  fi
} > "$tmp"
ssh -T -F "$tmp" -G localhost > /dev/null
mv -- "$tmp" "$config"
