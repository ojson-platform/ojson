---
id: TASK-1.7
title: Создать пакет @ojson/lint
status: To Do
assignee: []
created_date: '2026-02-17 20:27'
labels:
  - metapackage
  - devops
dependencies: []
references:
  - /Users/3y3k0/doctools/diplodoc/devops/lint
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Создать общий lint-пакет (ESLint + Prettier) для всех пакетов ojson.

**Контекст**: Сейчас каждый пакет дублирует ESLint- и Prettier-конфиги. Аналог `@diplodoc/lint` (`/Users/3y3k0/doctools/diplodoc/devops/lint`), который заменил устаревшие `@diplodoc/eslint-config` и `@diplodoc/prettier-config`.

**Принцип**: пакет должен оставаться автономным и опубликован на npm.

**Что создать** (в `devops/lint/` или аналогичной директории):
- `package.json` с `name: "@ojson/lint"`
- `eslint.config.js` (или `index.js`) — базовый flat config ESLint для TypeScript
- `prettier.config.js` — общий Prettier-конфиг
- `README.md` с примерами использования

**Ссылка**: Смотрите на `/Users/3y3k0/doctools/diplodoc/devops/lint` как образец.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/lint` доступен как npm-пакет
- [ ] #2 Любой пакет может подключить `@ojson/lint` в свой `eslint.config.js`
- [ ] #3 Prettier-конфиг доступен через `require('@ojson/lint/prettier')`
- [ ] #4 Пакет имеет README с примерами
<!-- AC:END -->
