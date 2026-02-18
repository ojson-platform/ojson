---
id: TASK-1
title: Organize ojson metapackage
status: To Do
assignee: []
created_date: '2026-02-17 20:24'
labels:
  - metapackage
  - architecture
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Turn the current ojson repository into a metapackage — similar to Diplodoc.

Metapackage ≠ monorepo: each package (`@ojson/http`, `@ojson/models`, `@ojson/services`, `@ojson/openapi`, `@ojson/server`) remains a separate git repository and can be cloned and developed independently. The metapackage only adds infrastructure for joint development of multiple packages.

**Current state** (`/Users/3y3k0/doctools/ojson`):
- Fresh git repo, no commits, no remote, no `package.json`
- 5 modules as plain directories:
  - `http` → `@ojson/http` — has remote `git@github.com:ojson-platform/http.git`
  - `models` → `@ojson/models` — has remote `git@github.com:ojson-platform/models.git`
  - `services` → `@ojson/services` — has remote `git@github.com:ojson-platform/services.git`
  - `openapi` → `@ojson/openapi` — no remote (private tool)
  - `server` → `@ojson/server` — no remote (local only)

**Target state**: root repo with npm workspaces, all modules as git submodules, shared devops infrastructure, bootstrap scripts, CI/CD.
<!-- SECTION:DESCRIPTION:END -->
