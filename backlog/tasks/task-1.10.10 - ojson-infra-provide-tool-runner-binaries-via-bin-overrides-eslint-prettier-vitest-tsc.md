---
id: TASK-1.10.10
title: >-
  @ojson/infra: provide tool runner binaries via bin overrides
  (eslint/prettier/vitest/tsc)
status: Done
assignee: []
created_date: '2026-02-18 14:58'
updated_date: '2026-02-18 15:14'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.1
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Goal: make @ojson/infra truly "one devDependency" for consumers by shipping executable tool runners via package.json `bin` that can be invoked with `pnpm exec` even when the consumer does NOT install eslint/prettier/vitest/typescript directly.

Approach (requested): "override/substitute" the standard binary names. That is, @ojson/infra exposes `eslint`, `prettier`, `vitest`, and `tsc` (optionally also `tsserver`) as bins, implemented as thin Node wrappers that locate and execute the corresponding CLI from @ojson/infra's own dependencies.

Important considerations:
- Name collisions: if the consumer also installs a direct dependency that provides the same bin name (e.g. `prettier`), that bin may take precedence. Document expected behavior and that the override is primarily for the "infra-only" install.
- Cross-platform: wrapper should work on macOS/Linux and Windows (no bash-specific scripts; use Node).
- Pass-through: forward all argv, preserve exit code, inherit stdio.

Also update docs: add a README section describing that consumers can rely on `pnpm exec eslint|prettier|vitest|tsc` after installing only `@ojson/infra`, and the caveats about bin precedence when installing tools directly.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 In a minimal package with only `@ojson/infra` as devDependency, `pnpm exec eslint --version` works and runs the version shipped with @ojson/infra.
- [x] #2 In a minimal package with only `@ojson/infra` as devDependency, `pnpm exec prettier --version` works (solves the current missing-bin issue).
- [x] #3 In a minimal package with only `@ojson/infra` as devDependency, `pnpm exec vitest --version` (or `pnpm exec vitest --help`) works.
- [x] #4 In a minimal package with only `@ojson/infra` as devDependency, `pnpm exec tsc --version` works (if typescript is added to infra deps, otherwise explicitly document and/or include it).
- [x] #5 Wrappers forward args, inherit stdio, and exit with the same exit code as the underlying tool.
- [x] #6 `devops/infra/README.md` documents the behavior and bin precedence caveat (consumer direct tool deps may override bins).
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Research (pnpm bin precedence): In a consumer with both a direct `prettier` dependency and another direct dependency that also exported a `prettier` bin, `./node_modules/.bin/prettier --version` ran the real Prettier (3.8.1). So name collisions are real, and the override should be treated as primarily for the "infra-only" install. This matches the desired goal: if a consumer explicitly installs its own tool, it likely should take precedence.

Implementation note: resolving CLI entrypoints via `require.resolve('eslint/bin/eslint.js')` may fail due to package `exports` (ERR_PACKAGE_PATH_NOT_EXPORTED). Wrapper should instead resolve a public entry (e.g. `require.resolve('eslint')`) and then locate package root via filesystem traversal to `package.json`, then construct CLI path (e.g. `<pkgRoot>/bin/eslint.js`, `<pkgRoot>/bin/prettier.cjs`, `<pkgRoot>/vitest.mjs`, `<pkgRoot>/bin/tsc`).

Research (current tool versions in infra): eslint@9.39.2 has `bin: { eslint: './bin/eslint.js' }` and exports `./package.json`, so wrappers can resolve `eslint/package.json` safely and read the bin mapping; do NOT resolve `eslint/bin/eslint.js` via `require.resolve` due to exports restrictions.

Research: prettier@3.8.1 has `bin: './bin/prettier.cjs'` (string), so wrapper can resolve `prettier/package.json` (exported via `./*`) and execute `<prettierRoot>/bin/prettier.cjs` via `node`.

Research: vitest@3.2.4 has `bin: { vitest: './vitest.mjs' }`, so wrapper can resolve `vitest/package.json` and execute `<vitestRoot>/vitest.mjs` via `node`.

Research: `typescript` is NOT currently a dependency of `@ojson/infra` (module not found when resolving from infra). If we want guaranteed `tsc` override, add `typescript` to infra dependencies explicitly (do not rely on pnpm peer auto-install behavior).

Wrapper recommendation (cross-platform): implement bins as `.cjs` files even though infra is `type: module` (CJS avoids ESM/require friction). In wrapper: resolve `<pkg>/package.json` (fallback to `require.resolve('<pkg>')` + climb to package.json), read `bin` field, compute absolute CLI path, spawn `process.execPath` with `[cliPath, ...process.argv.slice(2)]`, stdio inherit, and exit with same code/signal.

Research (bin collision resolution in pnpm, empirical): when two *direct* dependencies export the same bin name (`prettier`), pnpm links exactly one into `node_modules/.bin/prettier`. In local experiments, the winner was consistently the package whose name sorts later (e.g. `zzz` beats `aaa`; `bin-b` beats `bin-a`). Order in `package.json` and dependency-vs-devDependency did not change the outcome in these tests.

Research (scoped vs unscoped): when a scoped package (e.g. `@s/infra`) and an unscoped package named `prettier` both export a `prettier` bin, the unscoped `prettier` package won. This is desirable for our override strategy: if a consumer explicitly installs `prettier`, it will likely take precedence over `@ojson/infra`'s bin override.

Research (why overrides matter): reproduced again that in a minimal consumer with only `@ojson/infra` as devDependency, `pnpm exec prettier` fails because `node_modules/.bin/prettier` is missing, even though prettier is installed transitively. This strongly motivates shipping an explicit `prettier` bin via `@ojson/infra` itself to guarantee execution.

Implementation summary: added bin overrides in `devops/infra/package.json` for `eslint`, `prettier`, `vitest`, `tsc`, `tsserver`; added `typescript` dependency; implemented wrappers in `devops/infra/bin/*.cjs` using shared helper `devops/infra/bin/_tool-runner.cjs`; added `devops/infra/README.md` documenting one-dependency runners and bin precedence caveat. Verified in a temp consumer with only `@ojson/infra` as devDependency: `pnpm exec prettier|eslint|vitest|tsc --version` all work and `node_modules/.bin/prettier` is present.
<!-- SECTION:NOTES:END -->
