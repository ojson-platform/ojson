---
id: TASK-1.2
title: Инициализировать метапакет на pnpm workspaces
status: In Progress
assignee: []
created_date: '2026-02-17 20:24'
updated_date: '2026-02-17 21:41'
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

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

- pnpm не установлен в системе; актуальная версия: `10.30.0`
- `@ojson/server` зависит от `@ojson/models` через `"file:../models"` — нужно заменить на semver-диапазон (TASK-1.11.5)
- `@ojson/openapi` переходит в `packages/` (будет публичным)
- Все модули сейчас лежат в корне метапакета, физическое перемещение — в TASK-1.4

## Структура директорий

```
ojson/
├── packages/   # все пакеты: http, models, services, openapi
├── apps/       # приложения: server
└── devops/     # инфраструктура: infra (будущее TASK-1.10)
```

## Шаги

### Шаг 1. Установить pnpm через corepack

```bash
corepack enable
corepack prepare pnpm@10.30.0 --activate
```

### Шаг 2. Создать `package.json`

```json
{
  "name": "@ojson/ojson",
  "version": "1.0.0",
  "description": "Meta-package for ojson platform development",
  "private": true,
  "type": "module",
  "packageManager": "pnpm@10.30.0",
  "scripts": {
    "bootstrap": "scripts/bootstrap.sh",
    "build": "pnpm -r build",
    "test": "pnpm -r test",
    "check-submodules": "scripts/check-submodules.sh",
    "add-submodules": "scripts/add-submodules.sh"
  },
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=10.0.0"
  }
}
```

### Шаг 3. Создать `pnpm-workspace.yaml`

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
  - 'devops/*'
```

### Шаг 4. Создать `.npmrc`

```ini
shared-workspace-lockfile=false
strict-peer-dependencies=false
```

**Почему `false`**: модули будут git submodules. При `shared-workspace-lockfile=true` lockfile живёт только в корне метапакета, а standalone-репо пакета его не видит — при `pnpm add` нужно вручную ходить обновлять lockfile в отдельном репо.

При `false` lockfile живёт **внутри самого submodule** (`packages/models/pnpm-lock.yaml`). Изменение lockfile = коммит в `ojson-platform/models`. Стандалонный и workspace контексты используют один и тот же файл — нет рассинхронизации.

Трейдофф: pnpm не дедуплицирует sub-зависимости между пакетами через общий lockfile. Для ojson (небольшой набор пакетов) это несущественно.

### Шаг 5. Создать плацехолдер-директории

```bash
mkdir -p packages apps devops
```

### Шаг 6. Зависимость `server` → `models`

`@ojson/server/package.json` сейчас содержит `"@ojson/models": "file:../models"`. Заменить на `"^1.1.2"` (semver) в репозитории `server` (зафиксировано в TASK-1.11.5).

### Шаг 7. Закоммитить и запустить

```bash
cd /Users/3y3k0/doctools/ojson
git add package.json pnpm-workspace.yaml .npmrc packages/ apps/ devops/
git commit -m "chore: add pnpm workspace configuration"
git push
```
<!-- SECTION:PLAN:END -->
