---
id: TASK-1.10
title: Создать пакет @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-17 21:09'
labels:
  - metapackage
  - devops
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Создать единый devops-пакет `@ojson/infra`, который объединяет всю инфраструктуру разработки: линтер, конфигурацию TypeScript и тестовое окружение. Вместо трёх отдельных пакетов (`eslint-config`, `tsconfig`, `prettier-config`) — один, как осознанное архитектурное решение с первого дня.

**Мотивация**: Diplodoc исторически завёл три отдельных пакета (`eslint-config`, `prettier-config`, `tsconfig`), потом был вынужден объединять их в `@diplodoc/lint`. `@ojson/infra` сразу проектируется как единая точка входа.

**Состав пакета** (`devops/infra/`):
- **ESLint**: flat config для TypeScript (`eslint.config.js` / экспорт `@ojson/infra/eslint`)
- **Prettier**: базовый конфиг (`@ojson/infra/prettier`)
- **TypeScript**: набор `tsconfig`-пресетов:
  - `@ojson/infra/tsconfig/base` — базовый (`strict`, `ESNext`, `NodeNext`)
  - `@ojson/infra/tsconfig/build` — для компиляции в `build/`
  - `@ojson/infra/tsconfig/test` — для vitest (включает типы vitest)
- **Vitest**: базовый конфиг (`@ojson/infra/vitest`)

**Принцип автономности**: пакет публикуется на npm, поэтому пакеты могут зависеть от `@ojson/infra` как от обычного devDependency — без привязки к метапакетной инфраструктуре.

**Пример использования** в пакете:
```js
// eslint.config.js
export { default } from '@ojson/infra/eslint';

// prettier.config.js
export { default } from '@ojson/infra/prettier';

// vitest.config.ts
export { default } from '@ojson/infra/vitest';
```
```json
// tsconfig.json
{ "extends": "@ojson/infra/tsconfig/base" }
```
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/infra` опубликован на npm (или доступен через workspace-линкинг)
- [ ] #2 ESLint-конфиг для TypeScript подключается через `@ojson/infra/eslint`
- [ ] #3 Prettier-конфиг доступен через `@ojson/infra/prettier`
- [ ] #4 TypeScript-пресеты: `@ojson/infra/tsconfig/base`, `@ojson/infra/tsconfig/build`, `@ojson/infra/tsconfig/test`
- [ ] #5 Vitest-конфиг доступен через `@ojson/infra/vitest` и включает базовое покрытие (coverage)
- [ ] #6 Все экспорты описаны в `package.json` через поле `exports`
- [ ] #7 Пакет имеет README с примерами подключения для каждого инструмента
<!-- AC:END -->
