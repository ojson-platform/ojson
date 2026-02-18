# Backlog.md — task workflow

Use this command as: **`/task <id> <action>`**

Examples: `/task 1.2 research`, `/task 2.1 implement`, `/task 1.4 plan`, `/task 1.2 cancel`, `/task 1.2 reject "out of scope"`

After invoking the command, the user types the **task id** and **action** in chat. Interpret that as the full prompt below (substituting the given id, e.g. `1.2`, `2.1`, `task-1.4`).

---

## Actions

### `research`
**Expansion:** user wrote something like `1.2 research` or `task-1.4 research`.

Treat as full request:
> Work on **task-&lt;ID&gt;** only. Research the codebase and write an implementation plan in the task. Wait for my approval before coding.

(Substitute the actual task id for &lt;ID&gt;, e.g. task-1.2, task-2.1.)

---

### `implement`
**Expansion:** user wrote something like `1.2 implement` or `task-1.4 implement`.

Treat as full request:
> Implement **task &lt;ID&gt;** if there is no opened questions in task plan. Otherwise ask me these questions.

(Substitute the actual task id.)

---

### `plan`
**Expansion:** user wrote `&lt;id&gt; plan`.

Treat as full request:
> Work on **task-&lt;ID&gt;** only. If the task already has an implementation plan, summarize it and ask if I should proceed to implementation. If there is no plan, research the codebase and write an implementation plan in the task. Wait for my approval before coding.

---

### `decompose`
**Expansion:** user wrote `decompose` (no id) or described a feature and asked to split into tasks.

Treat as full request:
> Decompose this into small Backlog.md tasks with clear descriptions and acceptance criteria. Create tasks so that each can be done in one session; one task per PR.

(Use when breaking down a larger goal into backlog tasks.)

---

### `verify`
**Expansion:** user wrote something like `1.2 verify` or `task-1.4 verify`.

Treat as full request:
> For **task-&lt;ID&gt;** (just implemented): review the code, run tests, check linting, and verify the results match the task acceptance criteria and definition of done.

---

### `cancel` / `reject`
**Alias:** `reject` is equivalent to `cancel`.

**Expansion:** user wrote something like `1.2 cancel`, `task-1.4 reject`, or `1.2 cancel duplicate of 1.3` (optionally with a reason after the action).

Treat as full request:
> Cancel **task-&lt;ID&gt;** in Backlog.md: archive the task (or set status to cancelled) and do not implement it. If the user gave a reason (any text after `cancel` or `reject`), record it in the task or in the archive (e.g. in description or a note). If the task has an implementation plan or notes, clear or archive them. Confirm when done.

(Substitute the actual task id. Use Backlog.md CLI or MCP to archive/cancel the task.)

---

## When something is missing or wrong

- Only **id** given, no action → ask: "Specify the action: `research`, `implement`, `plan`, `verify`, `cancel`, or `reject`."
- Only **action** given, no id → ask for the task id.
- Unknown action → list the available ones: research, implement, plan, decompose, verify, cancel, reject.

---

## Backlog.md reference

- Tasks live under `backlog/` as Markdown files.
- Recommended loop: **decompose** → **research** (plan in task) → approval → **implement** → **verify**.
- Docs: [Backlog.md](https://github.com/MrLesk/Backlog.md#backlogmd).
