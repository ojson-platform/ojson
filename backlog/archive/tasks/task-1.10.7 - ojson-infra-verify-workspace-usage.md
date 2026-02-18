---
id: TASK-1.10.7
title: '@ojson/infra: verify workspace usage'
status: To Do
assignee: []
created_date: '2026-02-17'
updated_date: '2026-02-18 15:18'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.8
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Verify that @ojson/infra works when consumed via workspace: from metapackage root run `pnpm install`, then in at least one package (e.g. http) use config re-exports from @ojson/infra (manually or via `ojson-infra init`) and run eslint, prettier, and vitest. Confirm resolution and no runtime errors. Optionally leave one package migrated as a follow-up or restore original configs after verify.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 From root, `pnpm install` completes and devops/infra is linked
- [ ] #2 At least one package successfully uses `@ojson/infra/eslint` (eslint runs)
- [ ] #3 At least one package successfully uses `@ojson/infra/prettier` and/or `@ojson/infra/vitest` (optional but recommended)
- [ ] #4 No requirement to publish to npm for this task; workspace linking is sufficient
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Context

- **Dependency**: 1.10.7 depends on 1.10.8 (scaffolding). When implementing 1.10.7, the `ojson-infra` CLI is available; verification can use it or manual re-exports.
- **Already verified elsewhere**: Tasks 1.10.2, 1.10.3, 1.10.5 each verified one tool (eslint, prettier, vitest) in isolation by temporarily wiring http to @ojson/infra and then reverting. Task 1.10.7 is a **single, consolidated** verification: one package uses all configs (eslint, prettier, vitest; optionally tsconfig extends), and we run all tools in sequence to confirm workspace consumption end-to-end.
- **Deliverable choice**: Either (a) restore the package after verify (no permanent migration), or (b) leave one package (e.g. http) migrated to @ojson/infra as the verification artifact. Document the choice in the task or in a short note.

---

### Steps

1. **From metapackage root**: Run `pnpm install`. Confirm no errors and that `devops/infra` is part of the workspace (e.g. `pnpm list -r --depth 0` includes it, or `ls node_modules/@ojson/infra` when a consumer has the dep). → **AC#1**

2. **Pick one package** (e.g. `packages/http`) and add `@ojson/infra` as devDependency (`workspace:*`). Either:
   - **Option A**: Run `pnpm exec ojson-infra init` from that package (if CLI supports it) to create eslint.config.js, prettier.config.js, vitest.config.mjs, and optionally tsconfig.json; or
   - **Option B**: Manually add config files that re-export from @ojson/infra (eslint.config.js, prettier.config.js, vitest.config.mjs) and, if desired, a tsconfig that extends `@ojson/infra/tsconfig/base`. Back up or remove the package’s existing configs that would conflict (e.g. .prettierrc.json, existing vitest.config.ts).

3. **Run tools** in that package:
   - `pnpm exec eslint src` (or the package’s lint script) → **AC#2**
   - `pnpm exec prettier --check "src/**/*.ts"` (or format:check) → **AC#3**
   - `pnpm exec vitest --run` and optionally `pnpm exec vitest --run --coverage` → **AC#3**
   - Optionally `pnpm exec tsc --noEmit` if using tsconfig extends (may require overrides for that package’s moduleResolution, etc.).
   - Confirm no resolution errors and no unexpected failures.

4. **Finalize**: Either revert the package (remove @ojson/infra dep and restore original configs) or leave it migrated and document that one package now consumes @ojson/infra. AC#4 is already satisfied (workspace linking, no publish).

5. **Document**: In the task or in a short verification note, record which package was used, which option (scaffold vs manual), and whether configs were reverted or left in place.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Research (current repo state): workspace includes `devops/*` in `pnpm-workspace.yaml`, and root package is `@ojson/ojson`, so `devops/infra` is a proper workspace package when running `pnpm install` from root (AC#1 is about that link).

Research (packages currently): `packages/http` currently does NOT depend on `@ojson/infra` and has its own configs (`eslint.config.js`, `.prettierrc.json`, `vitest.config.ts`). No packages under `packages/` currently reference `@ojson/infra` (grep). So TASK-1.10.7 implementation must add `@ojson/infra` as a devDependency (recommended: `workspace:*`) in the chosen package before re-export configs can resolve.

Pitfall: running `pnpm exec ojson-infra init` in an existing package that already has config files will *skip* by default (safe-by-default) and still mark migrations as applied in `.infra.json` if you run without `--force`. That can prevent a later `--force` re-run without manual state reset. For verification, either (a) run with `--force` (and restore via git afterward), or (b) temporarily move existing configs out of the way before running init, or (c) use a fresh scratch package (e.g. under `apps/infra-verify`) to avoid partial applies.

Note: since TASK-1.10.10 is now implemented, `@ojson/infra` ships tool runner binaries. In an infra-only package, `pnpm exec eslint|prettier|vitest|tsc` work without installing those tools directly, but if a package has direct tool deps they may take precedence (bin precedence caveat).

Research (current repo state): workspace includes `devops/*` in `pnpm-workspace.yaml`, and root package is `@ojson/ojson`, so `devops/infra` is a proper workspace package when running `pnpm install` from root (AC#1 is about that link).

Research (packages currently): `packages/http` currently does NOT depend on `@ojson/infra` and has its own configs (`eslint.config.js`, `.prettierrc.json`, `vitest.config.ts`). No packages under `packages/` currently reference `@ojson/infra` (grep). So TASK-1.10.7 implementation must add `@ojson/infra` as a devDependency (recommended: `workspace:*`) in the chosen package before re-export configs can resolve.

Pitfall: running `pnpm exec ojson-infra init` in an existing package that already has config files will *skip* by default (safe-by-default) and still mark migrations as applied in `.infra.json` if you run without `--force`. That can prevent a later `--force` re-run without manual state reset. For verification, either (a) run with `--force` (and restore via git afterward), or (b) temporarily move existing configs out of the way before running init, or (c) use a fresh scratch package (e.g. under `apps/infra-verify`) to avoid partial applies.

Note: since TASK-1.10.10 is now implemented, `@ojson/infra` ships tool runner binaries. In an infra-only package, `pnpm exec eslint|prettier|vitest|tsc` work without installing those tools directly, but if a package has direct tool deps they may take precedence (bin precedence caveat).
<!-- SECTION:NOTES:END -->
