---
id: TASK-1.11
title: Migrate all packages to pnpm
status: To Do
assignee: []
created_date: '2026-02-17 21:36'
labels:
  - metapackage
  - pnpm
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Each ojson package currently uses npm (has `package-lock.json`). Migrate all packages to pnpm so tooling is consistent across the ecosystem and the metapackage works correctly.

**Context**: The metapackage `ojson-platform/ojson` uses pnpm workspaces (TASK-1.2). Individual packages should use pnpm too for standalone development (so lockfile and CI stay in sync).

**For each package**:
1. Remove `package-lock.json`, add to `.gitignore`
2. Run `pnpm install` — generates `pnpm-lock.yaml`
3. Add `"packageManager": "pnpm@10.30.0"` to `package.json`
4. Update CI scripts: `npm ci` → `pnpm install --frozen-lockfile`
5. Verify `pnpm test` and `pnpm build` work
<!-- SECTION:DESCRIPTION:END -->
