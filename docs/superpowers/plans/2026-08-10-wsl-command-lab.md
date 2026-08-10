# WSL Command Lab Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a small, reversible WSL2 command laboratory that teaches read-only inspection, running commands inside a distribution, export/import, and cleanup without risking the user's primary Ubuntu distribution.

**Architecture:** A documentation-first lab lives under `wsl-command-lab/`. A read-only PowerShell inspector covers Windows-side WSL commands. Bash scripts run inside Ubuntu and create a clearly named disposable directory. Optional lifecycle exercises export the primary distro, import it under a temporary name, and unregister only that temporary distro. `wsl --mount` and primary-distro unregister are explicitly excluded.

**Tech Stack:** PowerShell, Bash, WSL2, Ubuntu-24.04, Git, Microsoft Learn WSL basic commands.

---

### Task 1: Add the lab guide and cleanup guide

**Files:**
- Create: `wsl-command-lab/README.md`
- Create: `wsl-command-lab/docs/cleanup.md`

- [ ] Document prerequisites, learning goals, safe command groups, exact execution order, expected observations, and cleanup.
- [ ] Mark destructive operations and require the exact disposable distro name `WSL-Command-Lab-Temp`.

### Task 2: Add safe inspection scripts

**Files:**
- Create: `wsl-command-lab/scripts/inspect-wsl.ps1`
- Create: `wsl-command-lab/scripts/run-inside-wsl.sh`

- [ ] Make the PowerShell script run only read-only WSL queries and write a timestamped report.
- [ ] Make the Bash script create only `~/wsl-command-lab/report.txt` and record system state.

### Task 3: Add cleanup helpers

**Files:**
- Create: `wsl-command-lab/scripts/cleanup-inside-wsl.sh`
- Create: `wsl-command-lab/scripts/cleanup-temp-distro.ps1`

- [ ] Require an explicit confirmation phrase before deleting the lab directory.
- [ ] Require the exact temporary distro name before calling `wsl --unregister`.

### Task 4: Verify

- [ ] Run PowerShell parser validation on `.ps1` files.
- [ ] Run `bash -n` validation inside Ubuntu when available.
- [ ] Inspect `git diff --check` and repository status.
