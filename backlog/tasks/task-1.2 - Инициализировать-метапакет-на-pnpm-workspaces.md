---
id: TASK-1.2
title: Инициализировать метапакет на pnpm workspaces
status: To Do
assignee: []
created_date: '2026-02-17 20:24'
updated_date: '2026-02-17 21:14'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Инициализировать метапакет через `pnpm workspaces` — вместо npm workspaces.

**Почему pnpm**: более эффективное хранение `node_modules` (hard links), быстрее установка, строгая изоляция зависимостей (phantom deps невозможны), встроенная поддержка `catalogs` для общих версий зависимостей.

**Что создать**:
- `package.json` — с `name: "@ojson/ojson"`, `version: "1.0.0"`, минимальные `scripts` (`bootstrap`, `build`, `test`), `"packageManager": "pnpm@10.x.x"` (зафиксировать актуальную версию); без поля `workspaces` — оно переносится в `pnpm-workspace.yaml`
- `pnpm-workspace.yaml` — перечисляет workspace-пакеты:
```yaml
packages:
  - 'devops/*'
  - 'packages/*'
```
- `.npmrc` — базовый конфиг (`shamefully-hoist=false`, `strict-peer-dependencies=false`)

**Нужно решить**: как организовать пакеты по директориям. Варианты:
- `packages/` — все библиотеки (`http`, `models`, `services`); `tools/` — внутренние инструменты (`openapi`, `server`); `devops/` — инфраструктура (`@ojson/infra`)
- плоская структура (`packages: ['*']`)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Файл `pnpm-workspace.yaml` существует и перечисляет все нужные директории
- [ ] #2 `pnpm install` в root-директории успешно линкует `@ojson/*` пакеты
- [ ] #3 `package.json` зафиксирует версию pnpm через поле `packageManager`
- [ ] #4 Структура директорий определена (например, `packages/`, `devops/`)
- [ ] #5 `.npmrc` добавлен с базовыми настройками pnpm
<!-- AC:END -->
