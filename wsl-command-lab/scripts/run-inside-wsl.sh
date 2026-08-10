#!/usr/bin/env bash
set -euo pipefail

cd "$HOME"
lab_dir="$HOME/wsl-command-lab"
report="$lab_dir/report.txt"
mkdir -p "$lab_dir"

{
  printf 'WSL command lab report\n'
  printf 'Generated: %s\n\n' "$(date --iso-8601=seconds)"
  printf '%s\n' '=== identity ==='
  whoami
  id
  printf '%s\n' '=== location ==='
  pwd
  printf '%s\n' '=== kernel ==='
  uname -a
  printf '%s\n' '=== disk ==='
  df -h /
  printf '%s\n' '=== memory ==='
  free -h
  printf '%s\n' '=== network ==='
  ip -brief addr
  printf '%s\n' '=== listeners ==='
  ss -lnt
} | tee "$report"

printf '\nRead-only inspection complete: %s\n' "$report"
