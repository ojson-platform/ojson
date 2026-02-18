---
id: TASK-2.1
title: 'openapi: full CLI with argument parsing'
status: To Do
assignee: []
created_date: '2026-02-17 22:02'
labels:
  - openapi
dependencies: []
parent_task_id: TASK-2
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently the CLI (`src/index.ts`) uses hardcoded paths for the spec file and output directory. Implement a proper CLI with named arguments.

**Invocation**: `ojson-openapi-gen <spec> <outDir> [options]`

**To do** (stage 5 from `openapi-client.md`):
- Input validation: file not found / invalid spec
- Options: `--base`, `--client-name`, `--strict`
- Write policy: overwrite vs merge
- Exit codes and error messages
- `bin` in `package.json` for publishing as a CLI tool
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `ojson-openapi-gen <spec> <outDir>` works with any paths (no hardcoded `fixtures/`)
- [ ] #2 Invalid or missing spec yields a clear error and non-zero exit code
- [ ] #3 `package.json` contains `bin: { "ojson-openapi-gen": "build/index.js" }`
- [ ] #4 Option `--base` for stripping a common path prefix
<!-- AC:END -->
