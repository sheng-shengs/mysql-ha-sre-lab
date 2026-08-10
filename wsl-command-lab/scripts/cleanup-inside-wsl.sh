#!/usr/bin/env bash
set -euo pipefail

target="$HOME/wsl-command-lab"
resolved_target="$(readlink -f "$target" 2>/dev/null || true)"
expected="$HOME/wsl-command-lab"

if [[ "$resolved_target" != "$expected" || ! -d "$target" ]]; then
  printf 'Refusing to delete: expected %s, found %s\n' "$expected" "${resolved_target:-<missing>}" >&2
  exit 1
fi

printf 'This will permanently delete only %s\n' "$target"
read -r -p 'Type DELETE WSL LAB to continue: ' confirmation
if [[ "$confirmation" != 'DELETE WSL LAB' ]]; then
  echo 'Confirmation did not match; nothing was deleted.'
  exit 0
fi

rm -rf -- "$target"
echo "Deleted $target"
