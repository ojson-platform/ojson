---
id: TASK-2.3
title: 'openapi: extended schema support'
status: To Do
assignee: []
created_date: '2026-02-17 22:03'
labels:
  - openapi
dependencies: []
parent_task_id: TASK-2
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The current `generateTypes` implementation does not support some important JSON Schema / OpenAPI features.

**To add**:
- `allOf` — often used for schema inheritance (generate as intersection `A & B`)
- `oneOf` / `anyOf` — union types (`A | B`)
- `additionalProperties` — `Record<string, T>` or `{ [key: string]: T }`
- `format` hints: `date-time` → `string` (ISO), `uuid` → `string`
- Recursive `$ref` (currently only `#/components/parameters/` and `#/components/schemas/`)

**Depends on**: TASK-2.2 (fixtures should cover these cases)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `allOf: [$ref, {properties}]` generates intersection type
- [ ] #2 `oneOf` / `anyOf` generates union type
- [ ] #3 `additionalProperties: { type: string }` generates `Record<string, string>`
<!-- AC:END -->
