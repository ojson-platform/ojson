---
id: TASK-1.8
title: 'Configure GitHub Actions: submodule sync and CI'
status: Done
assignee: []
created_date: '2026-02-17 20:28'
updated_date: '2026-02-18 08:23'
labels:
  - metapackage
  - ci-cd
dependencies:
  - TASK-1.4
references:
  - /Users/3y3k0/doctools/diplodoc/.github/workflows/
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add GitHub Actions workflows to automate metapackage operations.

**Context**: Diplodoc uses GitHub Actions for:
1. Automatic submodule updates (e.g. hourly): each submodule updates the master branch in the metapackage
2. CI: submodule integrity checks and root config lint

**To create** (`.github/workflows/`):
- `sync-submodules.yml` — runs on schedule (e.g. hourly), updates all submodules to latest master commit
- `ci.yml` — runs on pull request, runs `npm run check-submodules`

Reference: `/Users/3y3k0/doctools/diplodoc/.github/workflows/` — use as template.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 `sync-submodules.yml` automatically updates submodule commits on schedule
- [x] #2 `ci.yml` runs on pull request and checks metapackage integrity
- [x] #3 GitHub Actions has write access to the repo (PAT or deploy key configured)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**ojson metapackage root**
- No `.github/` at root; workflows exist only inside submodules (e.g. `packages/http/.github/workflows/`).
- `package.json` references `scripts/bootstrap.sh` and `scripts/check-submodules.sh`, but **`scripts/` directory does not exist** (TASK-1.5 was rejected). CI cannot run `pnpm run check-submodules` until a minimal script exists.
- Root uses **pnpm** (`packageManager: pnpm@10.30.0`); workflows should use pnpm/corepack, not npm.
- `.gitmodules` lists 5 submodules: `packages/http`, `packages/models`, `packages/services`, `packages/openapi`, `packages/server`.

**Diplodoc reference** (`/Users/3y3k0/doctools/diplodoc/.github/workflows/`)
- **update-submodules.yml**: runs on `push` (master), `schedule` (cron daily), `workflow_dispatch`. Checkout with `submodules: recursive` and `token: ${{ secrets.GITHUB_TOKEN }}`. Runs `git submodule sync --recursive` and `git submodule update --init --recursive --remote`. If there are changes, commits with a fixed bot user and pushes. Uses npm (ojson will use pnpm).
- **boostrap.yaml**: runs on push when `packages/**` or `extensions/**` change; runs `npm run bootstrap`. Not required for TASK-1.8 scope.
- **e2e-tests.yaml**: full E2E with submodules, branch override, Playwright; out of scope.

**AC#3 (write access)**: `secrets.GITHUB_TOKEN` has write access to the repo when the workflow runs from the default branch; no extra PAT or deploy key needed unless the repo restricts it.

---

### Step 1. Add minimal `scripts/check-submodules.sh`

So that `pnpm run check-submodules` works and CI can call it.

- Create `scripts/check-submodules.sh` (executable).
- Script: run `git submodule status`; exit 1 if any line starts with `-` (submodule not initialized), else exit 0. Optionally print a short summary.
- No dependency on `submodules.conf` or other rejected TASK-1.5 artifacts.

---

### Step 2. Create `.github/workflows/sync-submodules.yml`

- **Name**: e.g. `Sync submodules`.
- **On**: `schedule` (e.g. `cron: '0 * * * *'` hourly, or `'0 0 * * *'` daily like Diplodoc), `workflow_dispatch`, and optionally `push` to `master`.
- **Job**:
  - Checkout with `submodules: recursive` and `token: ${{ secrets.GITHUB_TOKEN }}`.
  - Enable pnpm: `corepack enable` and `pnpm install -g pnpm` or use `actions/setup-node` with a version that includes corepack, then `corepack enable` and `pnpm` from packageManager.
  - Run:
    - `git submodule sync --recursive`
    - `git submodule update --init --recursive --remote`
  - If working tree has changes: set `user.name` / `user.email` (e.g. `github-actions[bot]`), `git add .`, `git commit -m "chore: update submodules to latest"`.
  - Push only when the last commit is the submodule update (same pattern as Diplodoc): e.g. `if` on job step that checks commit message, then `git push origin HEAD:${{ github.ref_name }}`.

---

### Step 3. Create `.github/workflows/ci.yml`

- **Name**: e.g. `CI`.
- **On**: `pull_request` (branches: `master` or default).
- **Job**:
  - Checkout with `submodules: recursive` and sufficient fetch depth (e.g. `fetch-depth: 0` if we need history; otherwise default is fine).
  - Enable pnpm (same as in sync workflow).
  - Run `pnpm run check-submodules` to verify all submodules are initialized and present.
  - Optional (can be same or a separate job): `pnpm install`, `pnpm run build` to verify the metapackage builds; add only if desired for “integrity” scope.

---

### Step 4. Document write access (AC#3)

- In the task or in a short README under `.github/`, note that sync uses `GITHUB_TOKEN`; if the repo uses “Restrict GITHUB_TOKEN” or branch protection that blocks pushes from GITHUB_TOKEN, a PAT or deploy key must be added to secrets and used in checkout instead.
- No code change required if default permissions are sufficient.

---

### File list after implementation

| Path | Purpose |
|------|--------|
| `scripts/check-submodules.sh` | Exit 0 if all submodules inited, else 1; used by root script and CI. |
| `.github/workflows/sync-submodules.yml` | Schedule + optional push + manual: update submodules, commit and push. |
| `.github/workflows/ci.yml` | On PR: checkout, run `pnpm run check-submodules` (and optionally install/build). |

---

### Out of scope / follow-up

- `scripts/bootstrap.sh`: still missing; not required for this task. Can be added later or replaced by `git submodule update --init --recursive && pnpm install` in docs.
- E2E or build in CI: only if we extend “integrity” to include `pnpm run build`.
<!-- SECTION:PLAN:END -->
