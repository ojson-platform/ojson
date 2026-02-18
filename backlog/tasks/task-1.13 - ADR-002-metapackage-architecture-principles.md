---
id: TASK-1.13
title: 'ADR-002: Metapackage architecture principles'
status: To Do
assignee: []
created_date: '2026-02-17 21:44'
labels:
  - adr
  - docs
dependencies:
  - TASK-1.2
  - TASK-1.4
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document the main architectural principles of the ojson metapackage.

**Create file** `docs/adr/002-metapackage-architecture.md`.

**Topics to cover**:

1. **Metapackage vs monorepo**: each package is a separate git repository and can be developed without the metapackage. The metapackage only adds infrastructure for joint development.

2. **Directory structure**: `packages/` (libraries + openapi), `apps/` (applications), `devops/` (infrastructure). Rationale for this layout.

3. **Package autonomy**: dependencies on `@ojson/infra` are normal devDependencies published on npm. The metapackage is not required to work on a package.

4. **Semver instead of `workspace:*`**: cross-package dependencies (e.g. `server` → `models`) use semver ranges. pnpm resolves to the local package in the workspace, and to the registry in standalone. `workspace:*` is not used — it breaks standalone install.

5. **Lockfile strategy**: `shared-workspace-lockfile=false` — lockfile lives inside the submodule, shared by standalone and workspace contexts (see ADR-001 for details).

6. **git submodules**: each package is a separate git repository under `ojson-platform`. The metapackage references a specific commit of each submodule, always pointing at `master`.
<!-- SECTION:DESCRIPTION:END -->
