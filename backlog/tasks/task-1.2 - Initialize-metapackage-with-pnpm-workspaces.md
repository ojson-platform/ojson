---
id: TASK-1.2
title: Initialize metapackage with pnpm workspaces
status: Done
assignee: []
created_date: '2026-02-17 20:24'
updated_date: '2026-02-17 21:47'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Initialize the metapackage with `pnpm workspaces` — instead of npm workspaces.

**Why pnpm**: more efficient `node_modules` storage (hard links), faster installs, strict dependency isolation (no phantom deps), built-in support for `catalogs` for shared dependency versions.

**To create**:
- `package.json` — with `name: "@ojson/ojson"`, `version: "1.0.0"`, minimal `scripts` (`bootstrap`, `build`, `test`), `"packageManager": "pnpm@10.x.x"` (pin current version); no `workspaces` field — it goes in `pnpm-workspace.yaml`
- `pnpm-workspace.yaml` — lists workspace packages:
```yaml
packages:
  - 'devops/*'
  - 'packages/*'
```
- `.npmrc` — base config (`shamefully-hoist=false`, `strict-peer-dependencies=false`)

**To decide**: how to organize packages by directory. Options:
- `packages/` — all libraries (`http`, `models`, `services`); `tools/` — internal tools (`openapi`, `server`); `devops/` — infrastructure (`@ojson/infra`)
- flat structure (`packages: ['*']`)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 File `pnpm-workspace.yaml` exists and lists all required directories
- [ ] #2 `pnpm install` in root directory successfully links `@ojson/*` packages
- [x] #3 `package.json` pins pnpm version via `packageManager` field
- [x] #4 Directory structure defined (e.g. `packages/`, `devops/`)
- [x] #5 `.npmrc` added with base pnpm settings
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

- pnpm not installed on system; current version: `10.30.0`
- `@ojson/server` depends on `@ojson/models` via `"file:../models"` — must be replaced with semver range (TASK-1.11.5)
- `@ojson/openapi` goes in `packages/` (will be public)
- All modules currently sit in metapackage root; physical move is in TASK-1.4

## Directory structure

```
ojson/
├── packages/   # all packages: http, models, services, openapi
├── apps/       # applications: server
└── devops/     # infrastructure: infra (future TASK-1.10)
```

## Steps

### Step 1. Install pnpm via corepack

```bash
corepack enable
corepack prepare pnpm@10.30.0 --activate
```

### Step 2. Create `package.json`

```json
{
  "name": "@ojson/ojson",
  "version": "1.0.0",
  "description": "Meta-package for ojson platform development",
  "private": true,
  "type": "module",
  "packageManager": "pnpm@10.30.0",
  "scripts": {
    "bootstrap": "scripts/bootstrap.sh",
    "build": "pnpm -r build",
    "test": "pnpm -r test",
    "check-submodules": "scripts/check-submodules.sh",
    "add-submodules": "scripts/add-submodules.sh"
  },
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=10.0.0"
  }
}
```

### Step 3. Create `pnpm-workspace.yaml`

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
  - 'devops/*'
```

### Step 4. Create `.npmrc`

```ini
shared-workspace-lockfile=false
strict-peer-dependencies=false
```

**Why `false`**: modules will be git submodules. With `shared-workspace-lockfile=true` the lockfile lives only in the metapackage root — the standalone package repo does not see it, so `pnpm add` would require manually updating the lockfile in the separate repo.

With `false` the lockfile lives **inside the submodule** (`packages/models/pnpm-lock.yaml`). Lockfile change = commit in `ojson-platform/models`. Standalone and workspace contexts use the same file — no desync.

Tradeoff: pnpm does not deduplicate sub-dependencies across packages via a shared lockfile. For ojson (small set of packages) this is acceptable.

### Step 5. Create placeholder directories

```bash
mkdir -p packages apps devops
```

### Step 6. Dependency `server` → `models`

`@ojson/server/package.json` currently has `"@ojson/models": "file:../models"`. Replace with `"^1.1.2"` (semver) in the `server` repo (captured in TASK-1.11.5).

### Step 7. Commit and push

```bash
cd /Users/3y3k0/doctools/ojson
git add package.json pnpm-workspace.yaml .npmrc packages/ apps/ devops/
git commit -m "chore: add pnpm workspace configuration"
git push
```
<!-- SECTION:PLAN:END -->
