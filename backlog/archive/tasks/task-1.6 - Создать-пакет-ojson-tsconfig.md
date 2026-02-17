---
id: TASK-1.6
title: Создать пакет @ojson/tsconfig
status: To Do
assignee: []
created_date: '2026-02-17 20:27'
labels:
  - metapackage
  - devops
dependencies: []
references:
  - /Users/3y3k0/doctools/diplodoc/devops/tsconfig
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Создать общий TypeScript-конфиг для всех пакетов ojson.

**Контекст**: Сейчас каждый пакет имеет собственный `tsconfig.json` с дублированными настройками. Общий `@ojson/tsconfig` позволяет унифицировать настройки. Аналог `@diplodoc/tsconfig` (`/Users/3y3k0/doctools/diplodoc/devops/tsconfig`).

**Принцип**: пакет должен оставаться автономным: если пакет разрабатывается отдельно, зависимость от `@ojson/tsconfig` должна быть devDependency, но не частью метапакетной инфраструктуры.

**Что создать** (в `devops/tsconfig/` или аналогичной директории):
- `package.json` с `name: "@ojson/tsconfig"`
- `tsconfig.base.json` — базовые настройки: `strict`, `target: ESNext`, `module: NodeNext`
- дополнительно возможны: `tsconfig.types.json`, `tsconfig.test.json`
- `README.md` с примерами использования
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/tsconfig` доступен как npm-пакет (возможно через workspace-линкинг в метапакете)
- [ ] #2 Любой пакет может использовать `extends: "@ojson/tsconfig/tsconfig.base.json"` в своём `tsconfig.json`
- [ ] #3 Настройки: `strict: true`, `target: ESNext`, `moduleResolution: NodeNext`
- [ ] #4 Пакет имеет README
<!-- AC:END -->
