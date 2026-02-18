---
id: TASK-2
title: '@ojson/openapi: generator development'
status: To Do
assignee: []
created_date: '2026-02-17 22:02'
labels:
  - openapi
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Parent task for developing `@ojson/openapi` — a build-time generator of typed HTTP clients from OpenAPI specs.

**Repo**: `ojson-platform/openapi` (locally: `/Users/3y3k0/doctools/ojson/openapi`)

**Context**: The generator reads OpenAPI YAML/JSON and outputs typed TypeScript clients that use `@ojson/http` as the transport.

**Current state**:
- ✅ Core generation: spec loading, mapping, typing, code generation, basic CLI
- ⚠️ CLI: works but has no proper argument parsing
- ❌ Tests: none
- ⚠️ Documentation: minimal

**Requirements source**: was in `services/docs/PROJECTS/openapi-client.md` (removed in TASK-1.3)
<!-- SECTION:DESCRIPTION:END -->
