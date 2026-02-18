# OJson Platform

Meta-package for ojson platform development.

## What is OJson

OJson is an ecosystem of TypeScript/Node packages: HTTP client with composable middleware, shared data models, services, an OpenAPI-to-typed-client generator, and a server application. Each package is published under the `@ojson` scope and can be used standalone or developed together via this metapackage.

## Packages

| Path | Package |
|------|---------|
| `packages/http` | `@ojson/http` |
| `packages/models` | `@ojson/models` |
| `packages/services` | `@ojson/services` |
| `packages/openapi` | `@ojson/openapi` |
| `packages/server` | `@ojson/server` |

All are git submodules (separate repositories in [ojson-platform](https://github.com/ojson-platform)).

## Getting started

**Clone with submodules:**

```bash
git clone --recurse-submodules https://github.com/ojson-platform/ojson.git
cd ojson
```

**Bootstrap (init submodules + install dependencies):**

```bash
pnpm run bootstrap
```

If you already cloned without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
pnpm install
```

**From root you can run:**

- `pnpm run check-submodules` — verify all submodules are initialized
- `pnpm run build` — build all packages
- `pnpm run test` — run tests in all packages

## Metapackage vs standalone

Each package is a **separate Git repository** and can be cloned, developed, and published on its own. The metapackage is optional and used for coordinated development across packages.

## For AI agents

See [AGENTS.md](AGENTS.md) and [.agents/core.md](.agents/core.md) for metapackage structure, dependencies, and workflow.
