---
id: TASK-1.10
title: Create package @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-17 21:09'
updated_date: '2026-02-18 14:58'
labels:
  - metapackage
  - devops
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create a single devops package `@ojson/infra` that bundles all development infrastructure: linter, TypeScript config, and test environment. One package instead of three separate ones (`eslint-config`, `tsconfig`, `prettier-config`) — a deliberate architectural choice from day one.

**Motivation**: Diplodoc historically added three separate packages (`eslint-config`, `prettier-config`, `tsconfig`) and later had to merge them into `@diplodoc/lint`. `@ojson/infra` is designed from the start as a single entry point.

**Package location**: `devops/infra/` — same as `packages/*`, must be a **git submodule** (separate repo, added in the metapackage via `git submodule add`). Infra then lives in its own repo, is published on npm, and is linked in the workspace.

**Package contents** (`devops/infra/`):
- **ESLint**: flat config for TypeScript (`eslint.config.js` / export `@ojson/infra/eslint`)
- **Prettier**: base config (`@ojson/infra/prettier`)
- **TypeScript**: set of `tsconfig` presets:
  - `@ojson/infra/tsconfig/base` — base (`strict`, `ESNext`, `NodeNext`)
  - `@ojson/infra/tsconfig/build` — for compiling to `build/`
  - `@ojson/infra/tsconfig/test` — for vitest (includes vitest types)
- **Vitest**: base config (`@ojson/infra/vitest`)
- **Scaffolding**: CLI (e.g. `ojson-infra init` or `add`) to create or update in the current package:
  - config files (eslint, prettier, vitest, tsconfig);
  - **base workflows** (e.g. `.github/workflows/` — CI, lint, test);
  - **common agents parts** (e.g. `.cursor/rules`, `.agents/`, AGENTS.md fragments or includes)

**Autonomy principle**: the package is published on npm, so packages can depend on `@ojson/infra` as a normal devDependency — no tie to metapackage infrastructure.

**Usage example** in a package:
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

**Alternatively**, from the package directory: `pnpm exec ojson-infra init` (or similar) to scaffold config files, base GitHub Actions workflows, and common agent guidance (e.g. `.cursor/rules`, `.agents/`, AGENTS.md) that use or reference @ojson/infra.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/infra` published on npm (or available via workspace linking)
- [ ] #2 ESLint config for TypeScript is used via `@ojson/infra/eslint`
- [ ] #3 Prettier config available via `@ojson/infra/prettier`
- [ ] #4 TypeScript presets: `@ojson/infra/tsconfig/base`, `@ojson/infra/tsconfig/build`, `@ojson/infra/tsconfig/test`
- [ ] #5 Vitest config available via `@ojson/infra/vitest` and includes basic coverage
- [ ] #6 All exports described in `package.json` via `exports` field
- [ ] #7 Package has README with setup examples for each tool
- [ ] #8 Scaffolding: CLI (e.g. `init` or `add`) creates or updates config files, base workflows (e.g. CI), and common agents parts (e.g. .cursor, .agents, AGENTS.md) in the current package
- [ ] #9 `devops/infra` is a git submodule (own repo, entry in `.gitmodules`), same as packages/*
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Current state in ojson packages**
- **http, models, services, server**: Each has its own `eslint.config.js` (flat config), `vitest.config.ts`, `tsconfig.json`, and `.prettierrc.json`. Configs are very similar across packages (same ESLint stack: `@eslint/js`, `@typescript-eslint/eslint-plugin`, `@typescript-eslint/parser`, `eslint-plugin-import`, `eslint-config-prettier`; same Vitest coverage pattern; similar Prettier options: semi, trailingComma, singleQuote, printWidth 100).
- **openapi**: No ESLint in scripts; has Prettier and TypeScript; no Vitest (test is placeholder).
- **http** `.prettierrc.json`: `semi: true, trailingComma: "all", singleQuote: true, printWidth: 100, tabWidth: 2, useTabs: false, arrowParens: "avoid", bracketSpacing: false`.
- **tsconfig** variance: http uses `moduleResolution: "Bundler"`, models uses `moduleResolution: "Node"` and custom plugins. A shared base can set `strict: true`, `target: "ESNext"`, `module: "NodeNext"` (or `ESNext`), `moduleResolution: "NodeNext"` (or `"Bundler"`); packages can override in local tsconfig.
- **pnpm-workspace.yaml** already includes `devops/*`; root has empty `devops/` (or placeholder). Create `devops/infra/` as the new package. **devops/infra must be a git submodule** (separate repo, same as packages/*); added to the plan as subtask 1.10.9.

**Diplodoc** `@diplodoc/lint`: Exports CommonJS configs (`./eslint-config`, `./prettier-config`), uses legacy `.eslintrc.js` and scaffolding; has bin scripts and init/update. For ojson we keep **exportable configs** as the primary usage and add **optional scaffolding** (e.g. `ojson-infra init`) so packages can either re-export by hand or generate config files via CLI.

**Export shape**
- **ESLint**: Flat config. Consumer does `export { default } from '@ojson/infra/eslint'`. So infra exports a **default** that is the config array (or a function returning it). File can be `eslint.config.mjs` or `eslint.mjs`; `package.json` exports `"./eslint": "./eslint.config.mjs"` (or `./eslint.mjs`).
- **Prettier**: Consumer does `export { default } from '@ojson/infra/prettier'`. So infra exports a default object. File `prettier.config.mjs` or `prettier.mjs`.
- **TypeScript**: JSON files. `"extends": "@ojson/infra/tsconfig/base"` — TypeScript resolves to the package; need `./tsconfig/base.json` and export `"./tsconfig/base": "./tsconfig/base.json"` (and same for build, test).
- **Vitest**: Consumer does `export { default } from '@ojson/infra/vitest'`. So infra exports a default (defineConfig result). File `vitest.config.mjs` or `vitest.mjs`; infra’s Vitest types can be in test preset or in a separate tsconfig/test.

**Dependencies**
- Config is loaded from `node_modules/@ojson/infra`; when the config module runs, its imports (e.g. `@typescript-eslint/eslint-plugin`) resolve from infra’s `node_modules`. So **@ojson/infra** should list ESLint plugins/parser, Prettier, and Vitest as **dependencies** (not peer) so that adding only `@ojson/infra` is enough. Alternatively use **peerDependencies** so the consumer installs them (better for version control). Task says “normal devDependency” and “no tie to metapackage” — so consumers add `@ojson/infra`; if we use peer deps, we document “also install eslint, typescript, vitest” in README. **Recommendation**: put ESLint/Prettier/Vitest and their plugins as **dependencies** of @ojson/infra so one `pnpm add -D @ojson/infra` suffices (simpler for consumers; we can switch to peer later if needed).

---

### Step 1. Create `devops/infra/` and `package.json`

- **name**: `@ojson/infra`
- **version**: `1.0.0`
- **description**: Shared dev infrastructure for ojson packages (ESLint, Prettier, TypeScript, Vitest)
- **private**: false (publishable)
- **type**: `module`
- **main**: not required (no default import)
- **exports**:
  - `"./eslint"`: path to eslint config (e.g. `"./eslint.config.mjs"`)
  - `"./prettier"`: path to prettier config
  - `"./tsconfig/base"`: `"./tsconfig/base.json"`
  - `"./tsconfig/build"`: `"./tsconfig/build.json"`
  - `"./tsconfig/test"`: `"./tsconfig/test.json"`
  - `"./vitest"`: path to vitest config
- **files**: include config files and tsconfig dir (no need to ship node_modules for publish)
- **dependencies**: eslint, @eslint/js, @typescript-eslint/eslint-plugin, @typescript-eslint/parser, eslint-config-prettier, eslint-plugin-import, prettier, vitest. Pin versions close to current usage in http/models (e.g. eslint ^9, typescript-eslint ^8, prettier ^3.7, vitest ^3).
- **devDependencies**: typescript (for type-checking infra’s .ts files if any; or use .mjs only). Optional: run a minimal lint on infra itself.
- **engines**: node >=20

---

### Step 2. ESLint config (`eslint.config.mjs` or `.js`)

- Extract the common shape from `packages/http/eslint.config.js`: js.configs.recommended, one block for `src/**/*.ts` (with project: './tsconfig.json'), one for `**/*.spec.ts` (lighter rules), eslint-config-prettier, and a final ignore for build/node_modules/config files.
- Use ESM: `import js from '@eslint/js'`, etc. Export `export default [ ... ]`.
- Do **not** hardcode paths that only work in one package; e.g. `project: './tsconfig.json'` is resolved from the **consuming** package’s cwd when ESLint runs, so it’s correct. Ignores can be generic (`build/`, `node_modules/`, `dist/`, `*.config.*`).
- If infra has no TypeScript source, use `.mjs` to avoid dealing with tsconfig for the config file itself.

---

### Step 3. Prettier config (`prettier.config.mjs` or `.mjs`)

- Export default object matching current usage: `{ semi: true, trailingComma: 'all', singleQuote: true, printWidth: 100, tabWidth: 2, useTabs: false, arrowParens: 'avoid', bracketSpacing: false }`.

---

### Step 4. TypeScript presets

- **tsconfig/base.json**: `compilerOptions`: `strict: true`, `target: "ESNext"`, `module: "ESNext"`, `moduleResolution: "NodeNext"` (or "Bundler" per existing http), `skipLibCheck: true`, `lib: ["ES2020", "ES2021", "ES2022"]`. No `include`/`exclude` (consumer extends and sets those).
- **tsconfig/build.json**: Extends `./base.json`; add `declaration: true`, `declarationMap: true`, `sourceMap: true`, `outDir: "build"`, `rootDir: "src"`. Intended for `tsc -p tsconfig.build.json` or consumer’s tsconfig that extends this.
- **tsconfig/test.json**: Extends `./base.json`; add `types: ["node", "vitest/globals"]` (or vitest/importMeta) and any include needed for tests. Consumer can extend this for test runs.

---

### Step 5. Vitest config (`vitest.config.mjs`)

- Export default from `defineConfig({ test: { include: ['src/**/*.spec.ts'], coverage: { provider: 'v8', reporter: ['text', 'json', 'html', 'lcov'], include: ['src/**/*.ts'], exclude: [ ... standard excludes ] } } })`. Use the same exclude list as in http/models (node_modules, build, **/*.spec.ts, config files, etc.).

---

### Step 6. README

- Sections: Overview, Usage (ESLint, Prettier, TypeScript, Vitest). For each tool: “In your package, add `@ojson/infra` as devDependency, then create (or replace) config file with the one-liner re-export.” Copy the example snippets from the task description. Note that packages can override or extend (e.g. local tsconfig extends base and adds include).

---

### Step 7. Scaffolding (CLI)

- Add a **bin** entry in `package.json` (e.g. `ojson-infra` → `dist/cli.mjs` or `bin/init.js`). Implement a command (e.g. `init` or `add`) that, when run from a package directory: (1) creates or overwrites `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs`, and optionally `tsconfig.json` with re-exports / extends from @ojson/infra; (2) adds **base workflows** (e.g. `.github/workflows/ci.yml`, lint/test); (3) adds **common agents parts** (e.g. `.cursor/rules/`, `.agents/` snippets, or AGENTS.md that references shared guidance). Idempotent where possible; prompt before overwriting or support `--force`. Document in README.

---

### Step 8. Verify workspace and exports

- From metapackage root: `pnpm install` (so devops/infra is linked). In one package (e.g. http) temporarily point eslint.config.js to `export { default } from '@ojson/infra/eslint'` and run `pnpm exec eslint src` to confirm resolution. Same for prettier and vitest if desired. Restore the package’s original config after verification, or leave migration to a follow-up task.
- AC#1 “published on npm or available via workspace linking”: for the task, workspace linking is enough; publishing can be a separate step.

---

### File list after implementation

| Path | Purpose |
|------|--------|
| `devops/infra/package.json` | name, version, exports, dependencies |
| `devops/infra/eslint.config.mjs` | Flat config default export |
| `devops/infra/prettier.config.mjs` | Prettier config default export |
| `devops/infra/tsconfig/base.json` | Base tsconfig |
| `devops/infra/tsconfig/build.json` | Build preset (extends base) |
| `devops/infra/tsconfig/test.json` | Test preset (extends base, vitest types) |
| `devops/infra/vitest.config.mjs` | Vitest default export (with coverage) |
| `devops/infra/README.md` | Usage and examples for each tool |
| `devops/infra/bin/` or script for CLI | Scaffolding (init/add) |
| Templates or embedded content in CLI | Base workflows (e.g. `.github/workflows/ci.yml`), common agents (`.cursor/rules/`, `.agents/`, AGENTS.md) |

---

### Submodule (TASK-1.10.9)

- Once devops/infra content is ready: create GitHub repo (e.g. ojson-platform/infra), move code there, remove the directory from metapackage git tracking and add as submodule: `git submodule add <url> devops/infra`. Update bootstrap/check-submodules if needed.

### Out of scope / follow-up

- Migrating existing packages (http, models, services, server) to use @ojson/infra: can be a separate task or done incrementally.
- openapi: no ESLint/Vitest today; can adopt infra later.
- Husky / lint-staged: not part of this task; can be added to infra or documented separately.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Decision update (2026-02-18): goal of `@ojson/infra` is explicitly "one devDependency" for consumers. We observed `pnpm exec prettier` may be missing when `prettier` is only a transitive dependency of `@ojson/infra` (even though it's installed). To make tool execution reliable, we created subtask TASK-1.10.10 to ship tool runner binaries via `bin` overrides (requested: expose `eslint`, `prettier`, `vitest`, `tsc` as bins implemented by Node wrappers inside `@ojson/infra`).

Research note: pnpm bin name collisions exist. In an experiment where consumer had both a direct `prettier` devDependency and another direct package exporting a `prettier` bin, the `prettier` bin resolved to the real `prettier` package. This is acceptable if we treat infra overrides as primarily for the infra-only install, and document that direct tool deps may take precedence.
<!-- SECTION:NOTES:END -->

## Subtasks

Implemented via sub-tasks (one per PR / session):

| ID | Title |
|----|--------|
| [TASK-1.10.1](task-1.10.1%20-%20infra-package-skeleton.md) | @ojson/infra: package skeleton |
| [TASK-1.10.2](task-1.10.2%20-%20infra-eslint-config.md) | @ojson/infra: ESLint flat config |
| [TASK-1.10.3](task-1.10.3%20-%20infra-prettier-config.md) | @ojson/infra: Prettier config |
| [TASK-1.10.4](task-1.10.4%20-%20infra-tsconfig-presets.md) | @ojson/infra: TypeScript presets |
| [TASK-1.10.5](task-1.10.5%20-%20infra-vitest-config.md) | @ojson/infra: Vitest config with coverage |
| [TASK-1.10.6](task-1.10.6%20-%20infra-README.md) | @ojson/infra: README and setup examples |
| [TASK-1.10.8](task-1.10.8%20-%20infra-scaffolding.md) | @ojson/infra: scaffolding (init/add CLI) |
| [TASK-1.10.7](task-1.10.7%20-%20infra-verify-workspace.md) | @ojson/infra: verify workspace usage |
| [TASK-1.10.9](task-1.10.9%20-%20infra-submodule.md) | devops/infra as git submodule |

Order: 1.10.1 first; 1.10.2–1.10.5 in any order after 1.10.1; 1.10.6 after configs; 1.10.8 after 1.10.6 (scaffolding); 1.10.7 (verify); 1.10.9 (devops/infra as submodule) — after infra content is ready, create the repo and add the submodule.
