---
id: TASK-1.10.6
title: '@ojson/infra: README and setup examples'
status: Done
assignee: []
created_date: '2026-02-17'
updated_date: '2026-02-18 15:14'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.2
  - TASK-1.10.3
  - TASK-1.10.4
  - TASK-1.10.5
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add `devops/infra/README.md` with overview of @ojson/infra and usage for each tool: ESLint, Prettier, TypeScript, Vitest. For each, document adding @ojson/infra as devDependency and the one-liner re-export (or extends for tsconfig). Use the same example snippets as in parent task TASK-1.10.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 README exists with Overview and Usage sections
- [x] #2 Each tool (ESLint, Prettier, TypeScript, Vitest) has a setup example (config snippet)
- [x] #3 Examples match the export style: `export { default } from '@ojson/infra/eslint'` and `"extends": "@ojson/infra/tsconfig/base"`
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Research note (from TASK-1.10.8): TASK-1.10.8 expects README to document scaffolding. When implementing this task, please include `devops/infra/README.md` with Overview/Usage for ESLint/Prettier/TS/Vitest, and add a `## Scaffolding` subsection describing `pnpm exec ojson-infra init` (alias of `migrate`), the files it creates (configs, `.github/workflows/ci.yml`, `AGENTS.md` marker block + `.agents/` fragments, `.infra.json`), and overwrite behavior (default skip, `--force`, optional `--dry-run`).

Research: canonical example snippets to include in README are already defined in parent TASK-1.10 and match current exports in `devops/infra/package.json`: `export { default } from '@ojson/infra/eslint'`, `.../prettier`, `.../vitest`, and `{"extends":"@ojson/infra/tsconfig/base"}`.

Research: current configs in infra are ESM: `eslint.config.mjs`, `prettier.config.mjs`, `vitest.config.mjs`, plus JSON presets in `tsconfig/` (base/build/test). README should show consumer config files as `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs` (or `.ts` per taste).

Important nuance (pnpm exec tooling): installing only `@ojson/infra` does NOT guarantee `pnpm exec prettier` is available in the consumer. In a minimal consumer with only `@ojson/infra` as devDependency, `pnpm exec eslint` and `pnpm exec vitest` worked, but `pnpm exec prettier` was not found, even though `prettier` is a dependency of `@ojson/infra` (confirmed by `pnpm why prettier`). Recommendation for README: either (a) instruct consumers to keep/install tool runners as direct devDependencies (`eslint`, `prettier`, `vitest`, `typescript` as needed), or (b) document that binaries availability may depend on pnpm’s bin linking / direct deps, and the safe approach is to add the runner explicitly.

Recommendation: add a short `## Scaffolding` section in `devops/infra/README.md` (even though it originates from TASK-1.10.8 expectations): `pnpm exec ojson-infra init` (alias of `migrate`), files created, and overwrite behavior (default skip; `--force`; `--dry-run`).

Implemented `devops/infra/README.md` while doing TASK-1.10.10: includes Overview/Usage for ESLint/Prettier/TypeScript/Vitest with canonical one-liner re-export/extends snippets (matching TASK-1.10), plus sections for tool runners and scaffolding. This satisfies TASK-1.10.6 ACs as well.
<!-- SECTION:NOTES:END -->
