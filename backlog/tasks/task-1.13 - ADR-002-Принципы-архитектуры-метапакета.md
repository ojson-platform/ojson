---
id: TASK-1.13
title: 'ADR-002: Принципы архитектуры метапакета'
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
Зафиксировать основные архитектурные принципы метапакета ojson.

**Создать файл** `docs/adr/002-metapackage-architecture.md`.

**Темы для раскрытия**:

1. **Метапакет vs монорепа**: каждый пакет является самостоятельным git-репозиторием и может разрабатываться без метапакета. Метапакет лишь добавляет инфраструктуру для совместной разработки.

2. **Структура директорий**: `packages/` (библиотеки + openapi), `apps/` (приложения), `devops/` (инфраструктура). Почему так, а не иначе.

3. **Автономность пакетов**: зависимости на `@ojson/infra` — обычные devDependency, опубликованные на npm. Метапакет не требуется для работы с пакетом.

4. **Semver вместо `workspace:*`**: междупакетные зависимости (например, `server` → `models`) оформляются как semver-диапазон. pnpm резолвит в локальный пакет в workspace, из реестра в standalone. `workspace:*` не используется — разрушает автономную установку.

5. **Стратегия lockfile**: `shared-workspace-lockfile=false` — lockfile живёт внутри submodule, единый для standalone и workspace контекстов (подробнее см. ADR-001).

6. **git submodules**: каждый пакет — отдельный git-репозиторий в `ojson-platform`. Метапакет ссылается на конкретный коммит каждого submodule, всегда указывая на `master`.
<!-- SECTION:DESCRIPTION:END -->
