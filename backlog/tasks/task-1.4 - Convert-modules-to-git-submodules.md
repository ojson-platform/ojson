---
id: TASK-1.4
title: Convert modules to git submodules of the metapackage
status: Done
assignee: []
created_date: '2026-02-17 20:26'
updated_date: '2026-02-17 22:17'
labels:
  - metapackage
  - git
dependencies:
  - TASK-1.1
  - TASK-1.2
  - TASK-1.3
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently all modules (`http`, `models`, `services`, `openapi`, `server`) are plain subdirectories in the metapackage root. Convert them to git submodules so each remains an independent git repository.

**Context**: In the metapackage (like Diplodoc) each package is a separate git submodule (its own repo). This allows cloning a package on its own and working on it independently.

**Prerequisites**:
- TASK-1.1: Metapackage GitHub repo created
- TASK-1.2: Directory structure defined (where to place packages: `packages/`, `tools/`, etc.)
- TASK-1.3: GitHub repos for `openapi` and `server` created

**Steps**:
1. Remove module directories from metapackage git tracking (`git rm -r --cached http models services openapi server`)
2. If needed — move directories into target subdirectories (e.g. `packages/http`)
3. Add each as a submodule:
   - `git submodule add git@github.com:ojson-platform/http.git packages/http`
   - same for models, services, openapi, server
4. Commit `.gitmodules` and submodule entries
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All 5 modules added as git submodules (`git submodule status` shows all)
- [ ] #2 `.gitmodules` contains all submodule entries
- [ ] #3 `git submodule update --init` successfully initializes all modules
- [ ] #4 Existing module code is preserved (history stays in separate repos)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

All 5 modules are currently untracked directories in the metapackage root; each has its own `.git` and remote:

| Module | Remote | Target path |
|---|---|---|
| `http` | `ojson-platform/http` | `packages/http` |
| `models` | `ojson-platform/models` | `packages/models` |
| `services` | `ojson-platform/services` | `packages/services` |
| `openapi` | `ojson-platform/openapi` | `packages/openapi` |
| `server` | `ojson-platform/server` | `packages/server` |

`pnpm-workspace.yaml` already includes `packages/*` — all 5 modules go under `packages/`.

**Key point**: Because the directories are untracked (not tracked by the metapackage), `git rm` is not needed. Use: `mv` + `git submodule add --force`.

## Implementation Plan

### Step 1. Move directories to target paths

```bash
cd /Users/3y3k0/doctools/ojson

mv http  packages/http
mv models packages/models
mv services packages/services
mv openapi packages/openapi
mv server packages/server
```

### Step 2. Add each module as a git submodule

`--force` allows adding an existing directory that already contains a git repo.

```bash
git submodule add --force git@github.com:ojson-platform/http.git     packages/http
git submodule add --force git@github.com:ojson-platform/models.git   packages/models
git submodule add --force git@github.com:ojson-platform/services.git packages/services
git submodule add --force git@github.com:ojson-platform/openapi.git  packages/openapi
git submodule add --force git@github.com:ojson-platform/server.git   packages/server
```

### Step 3. Verify result

```bash
git submodule status
# Expect: 5 lines with hashes and paths

cat .gitmodules
# Expect: 5 entries [submodule "packages/..."]
```

### Step 4. Commit and push

```bash
git add .gitmodules packages/
git commit -m "chore: add all platform modules as git submodules

Modules registered as submodules:
- packages/http     -> ojson-platform/http
- packages/models   -> ojson-platform/models
- packages/services -> ojson-platform/services
- packages/openapi  -> ojson-platform/openapi
- packages/server   -> ojson-platform/server"
git push
```

### Step 5. Verify with a fresh clone

```bash
cd /tmp && git clone --recurse-submodules git@github.com:ojson-platform/ojson.git ojson-test
git -C ojson-test submodule status
# All 5 modules should be visible
rm -rf /tmp/ojson-test
```
<!-- SECTION:PLAN:END -->
