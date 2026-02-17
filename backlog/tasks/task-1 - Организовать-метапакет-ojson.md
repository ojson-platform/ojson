---
id: TASK-1
title: Организовать метапакет ojson
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
Преобразовать текущий ojson-репозиторий в метапакет — по аналогии с Diplodoc.

Метапакет ≠ монорепа: каждый пакет (`@ojson/http`, `@ojson/models`, `@ojson/services`, `@ojson/openapi`, `@ojson/server`) остаётся самостоятельным git-репозиторием и может клонироваться и разрабатываться независимо. Метапакет лишь добавляет удобную инфраструктуру для совместной разработки нескольких пакетов.

**Текущее состояние** (`/Users/3y3k0/doctools/ojson`):
- Свежий git-репо, нет коммитов, нет remote, нет `package.json`
- 5 модулей как обычные директории:
  - `http` → `@ojson/http` — есть remote `git@github.com:ojson-platform/http.git`
  - `models` → `@ojson/models` — есть remote `git@github.com:ojson-platform/models.git`
  - `services` → `@ojson/services` — есть remote `git@github.com:ojson-platform/services.git`
  - `openapi` → `@ojson/openapi` — нет remote (private tool)
  - `server` → `@ojson/server` — нет remote (local only)

**Целевое состояние**: root-репо с npm workspaces, все модули как git submodules, общая devops-инфраструктура, bootstrap-скрипты, CI/CD.
<!-- SECTION:DESCRIPTION:END -->
