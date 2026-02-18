# Submodule management

Use this command as: **`/submodule <action> [args]`**

Examples:
- `/submodule add git@github.com:ojson-platform/foo.git`
- `/submodule add` (will ask for the URL)
- `/submodule remove packages/foo`
- `/submodule check`

After invoking the command, the user types the **action** and optional arguments in chat. Follow the workflow for the corresponding action below.

---

## Actions

### `add`

Connect a new git repository as a submodule of the ojson metapackage.

**Full workflow — execute every step in order:**

#### Step 1. Get the repository URL

If a URL was given, use it. Otherwise ask:
> "What is the git URL of the repository to add? (e.g. `git@github.com:ojson-platform/foo.git`)"

#### Step 2. Analyze the repository

Clone or inspect the repository (read `package.json`, `README.md`, directory structure). Determine:

- **Package name** (`name` field in `package.json`)
- **Is it a new/empty repo or does it have existing code?**
- If it has code: **what does it do?** (purpose, main exports, dependencies)

#### Step 3. Propose a target directory

Based on the package role, propose one of:

| Role | Directory |
|---|---|
| Shared library / npm package | `packages/<name>` |
| Application / server / service | `packages/<name>` |
| Dev tooling (lint, tsconfig, build) | `devops/<name>` |

Ask the user to confirm or specify a different path.

#### Step 4. Infrastructure checklist

Inspect the package and report status for each item. For any ❌ item, propose adding a Backlog.md task:

| # | Check | What to look for |
|---|---|---|
| 1 | Uses **pnpm** | `pnpm-lock.yaml` exists, `"packageManager"` in `package.json` |
| 2 | Uses **@ojson/infra** for ESLint | `eslint.config.*` imports from `@ojson/infra` |
| 3 | Uses **@ojson/infra** for Prettier | `prettier.config.*` imports from `@ojson/infra` |
| 4 | Uses **@ojson/infra** for TypeScript | `tsconfig.json` extends `@ojson/infra/tsconfig/*` |
| 5 | Uses **@ojson/infra** for Vitest | `vitest.config.*` imports from `@ojson/infra` |
| 6 | Has **tests** | `*.test.ts` / `*.spec.ts` files exist |
| 7 | Has **CI** workflow | `.github/workflows/` contains at least one workflow |
| 8 | Has **README** | `README.md` exists and is non-trivial (>10 lines) |
| 9 | Has **no `private: true`** (if it's a publishable library) | check `package.json` |

Present the checklist as a table with ✅ / ❌ per item.

For each ❌ item, ask: "Should I create a Backlog.md task for this?"
Create the tasks the user approves (use `task_create` via Backlog.md MCP, label `infra` or `setup`).

#### Step 5. Confirm and connect

Show a summary:
```
Repository:  git@github.com:ojson-platform/foo.git
Target path: packages/foo
Package:     @ojson/foo
```

Ask: "Proceed with `git submodule add`?"

If confirmed:
```bash
git submodule add git@github.com:ojson-platform/foo.git packages/foo
git add .gitmodules packages/foo
git commit -m "chore: add @ojson/foo as git submodule"
git push
```

Confirm success and print the final `git submodule status` line for the new module.

---

### `remove`

Remove an existing submodule from the metapackage.

**Workflow:**

1. If a path was given (e.g. `packages/foo`), use it. Otherwise ask for it.
2. Show the submodule to be removed and ask for confirmation.
3. Run:

```bash
git submodule deinit -f <path>
git rm -f <path>
rm -rf .git/modules/<path>
git commit -m "chore: remove <name> submodule"
git push
```

4. Confirm success.

---

### `check`

Check the status of all submodules in the metapackage.

Run `git submodule status` and for each entry show:
- Path
- Current commit hash
- Whether it is **up-to-date** with `origin/master` or **behind**

If any submodule is behind, list them and ask: "Should I update them to latest master?"

If yes, run:
```bash
git submodule update --remote --merge
git add .
git commit -m "chore: update submodules to latest master"
git push
```

---

## When something is missing or wrong

- No action given → ask: "Specify the action: `add`, `remove`, or `check`."
- Unknown action → list the available ones: add, remove, check.
- `add` given but URL cannot be resolved → report the error and ask for the correct URL.

---

## Metapackage layout reference

```
ojson/
├── packages/   # libraries and tools: http, models, services, openapi, server
└── devops/     # dev infrastructure: infra (lint, tsconfig, vitest)
```

`pnpm-workspace.yaml` already includes `packages/*` and `devops/*`.
