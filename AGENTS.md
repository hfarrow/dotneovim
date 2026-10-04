# Repository agent guidance

This repository contains personal Neovim and IdeaVim configuration. Treat it as a configuration repo: preserve existing behavior unless the requested change calls for changing it, and keep the setup understandable and maintainable across machines.

## Primary workflow: OpenSpec

Use OpenSpec to define, plan, and implement substantive changes. Follow the repository-local `openspec-*` skills under `.agents/skills/` and the `spec-driven` schema in `openspec/config.yaml`. Keep requirements, design decisions, and implementation progress in the change artifacts so another agent can pick up the work without relying on conversation history.

The CLI is pinned in `.agents/tools/`. Run `npm ci --prefix .agents/tools` if its dependencies are missing, then run `.agents/tools/node_modules/.bin/openspec` from the repository root. In the workflow and skills, `openspec` is shorthand for this local binary; use it rather than relying on a global installation or fetching the latest version with `npx`.

1. **Find the current context.** Check active changes with `openspec list --json`, read relevant existing specs and change artifacts, and inspect the configuration the request touches. Continue the relevant change rather than creating a duplicate; ask when the intended change is ambiguous.
2. **Define the outcome.** Use `openspec-explore` when goals, scope, or tradeoffs need discussion. Clarify decisions that materially affect behavior or acceptance criteria. Exploration does not authorize implementation.
3. **Plan the change.** Use `openspec-propose` to create a named change with its proposal, capability delta specs, design where required, and actionable tasks. Use the CLI's status and artifact instructions to determine dependencies, templates, and paths. Specify observable behavior, acceptance scenarios, configuration/load-order decisions, setup requirements, and appropriate validation. Keep the plan detailed enough for a different agent to implement.
4. **Review before implementation.** Present the artifacts and stop after planning. Start `openspec-apply-change` only when the user subsequently asks to apply or implement the change. If the plan needs revision, use `openspec-update-change` and keep the proposal, specs, design, and tasks coherent.
5. **Implement from the artifacts.** Load the change's current apply instructions and all listed context files, then work through its tasks. Mark a task complete only after its specified behavior and relevant checks are complete. If implementation exposes a scope or design problem, resolve it in the artifacts before proceeding; do not silently narrow requirements or treat partial work as done.
6. **Validate and close out.** Check the implementation against the specs and acceptance scenarios, run the applicable checks below, and validate the change with OpenSpec. Report completed work, remaining tasks, and blockers. When the user requests finalization, use `openspec-archive-change` to sync delta specs into the main specs and archive the completed change.

Read-only questions, Git operations, and small documentation or agent-instruction maintenance can be handled directly unless the user requests an OpenSpec change. Do not create a change merely to administer this workflow.

### Forward-looking specs

- OpenSpec adoption starts with new work. Do not create retroactive capabilities, baseline specs, or historical changes to document the existing configuration.
- The forthcoming implementation is intended to be built essentially from scratch. Inspect the existing configuration as reference, but let the agreed change artifacts define the target behavior and what must be retained or replaced; do not assume every existing plugin, binding, or implementation choice must carry forward.
- An empty `openspec/specs/` directory is expected initially. Define only capabilities needed by the requested change, using added requirements for capabilities without a main spec. Main specs accumulate as implemented changes are synced and archived.
- Do not invent requirements or completed tasks from current code, and do not expand a change into a repository-wide inventory or migration unless requested.

## Working conventions

- Read the affected configuration and its callers before changing it; Neovim configuration is loaded in a particular order.
- Prefer current Neovim APIs and Lua over deprecated APIs or Vimscript when modernizing existing code.
- Keep Lua formatting consistent with the existing files (two-space indentation and single quotes where practical).
- Do not add a plugin or external executable when a built-in Neovim feature or existing dependency is sufficient.
- Keep machine-specific settings and secrets out of tracked files. Put optional host-specific behavior behind a clear check or documented local override.
- Update the README when setup requirements, plugin management, or supported Neovim versions change.
- Do not commit changes unless explicitly asked.

## Validation

There is no established automated test suite yet. For Lua changes, run the available Neovim/Lua syntax checks and use a headless Neovim startup check when the local plugin environment permits it. Report checks that could not run because a tool or plugin is unavailable; do not silently treat them as passing.

## Agent setup

`AGENTS.md` is the canonical repository guidance file. Claude Code imports it through `CLAUDE.md`. Keep reusable skills under `.agents/skills/`; OpenSpec-managed `openspec-*` skills may be regenerated by OpenSpec.
