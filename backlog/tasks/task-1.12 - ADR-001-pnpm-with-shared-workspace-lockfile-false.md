---
id: TASK-1.12
title: 'ADR-001: pnpm as package manager with shared-workspace-lockfile=false'
status: To Do
assignee: []
created_date: '2026-02-17 21:44'
labels:
  - adr
  - docs
dependencies:
  - TASK-1.2
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document in an ADR the decision to use pnpm and the `shared-workspace-lockfile=false` setting.

**Create file** `docs/adr/001-pnpm-shared-workspace-lockfile.md`.

**Decision context** (from TASK-1.2):

- **Why pnpm** over npm: hard links, strict isolation (no phantom deps), fast installs, catalogs

- **Why `shared-workspace-lockfile=false`**: packages are git submodules. With `true` the lockfile lives only in the metapackage root — the standalone package repo does not see it, so it gets out of sync. With `false` the lockfile lives inside the submodule — one file for both contexts.

- **Why not `workspace:*`**: breaks standalone install of a package. Use semver ranges — pnpm resolves to the local package in the workspace, and to the registry in standalone.

- **Tradeoff**: with `false` pnpm does not deduplicate sub-dependencies across packages via a shared lockfile. Acceptable — the set of packages is small.
<!-- SECTION:DESCRIPTION:END -->
