---
id: TASK-1.5
title: Create submodules.conf and submodule management scripts
status: To Do
assignee: []
created_date: '2026-02-17 20:26'
labels:
  - metapackage
  - scripts
dependencies:
  - TASK-1.4
references:
  - /Users/3y3k0/doctools/diplodoc/submodules.conf
  - /Users/3y3k0/doctools/diplodoc/scripts/
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Diplodoc uses `submodules.conf` — a list of all submodules for the `add-submodules.sh` script, which adds/removes submodules according to the config. Add the same mechanism to ojson.

**Context**: In Diplodoc, `submodules.conf` lists `url|path` pairs. The `add-submodules.sh` script reads the config, adds new and removes obsolete submodules. The `check-submodules.sh` script checks status.

**Rejection reason**: This is unnecessary overhead. In Diplodoc it was added to connect many submodules at a late stage. In ojson submodules are connected on-demand via the `/submodule` Cursor command — no bulk management script needed.

**To create** (in `/Users/3y3k0/doctools/ojson/`):
- `submodules.conf` — list of all submodules
- `scripts/add-submodules.sh` — adds/removes submodules
- `scripts/check-submodules.sh` — checks submodule status
- `scripts/bootstrap.sh` — init (`git submodule update --init --recursive && npm install`)
- npm scripts in root `package.json`: `bootstrap`, `check-submodules`, `add-submodules`

Reference for structure: `/Users/3y3k0/doctools/diplodoc/submodules.conf`, `/Users/3y3k0/doctools/diplodoc/scripts/`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `submodules.conf` lists all 5 modules with their URLs and paths
- [ ] #2 `npm run bootstrap` initializes all submodules and installs dependencies
- [ ] #3 `npm run add-submodules` syncs submodules according to `submodules.conf`
- [ ] #4 `npm run check-submodules` prints status of all submodules
<!-- AC:END -->
