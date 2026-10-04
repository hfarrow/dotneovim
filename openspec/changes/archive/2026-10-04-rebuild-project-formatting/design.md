# Design

## Context

Phase 4 disabled server formatting capabilities. See proposal.md and umbrella section 6. Conform is the single save pipeline; explicit fixes are independently invoked.

## Goals / Non-Goals

**Goals:** Per-file policy, pinned local executables, no save cleanup, actual formatter/lint evidence including missing/failure paths.

**Non-Goals:** Running project scripts heuristically, LSP formatting fallback, global eslint/biome substitution.

## Decisions

- Conform stable on BufWritePre/manual command. One `config.format` builds a single dynamic formatter using argv, stdin, filename and cwd from policy; synchronous bounded 1500ms, warnings and save continuation. Global/buffer flags and commands; Markdown manual only.
- Bounded ancestors stop at Git/home. JSON `.nvim-format.json` per-language `{formatter, command?, version?}` overrides detected policy; command is argv executable path relative to policy (no shell). Closest package declaration/config wins, workspace node_modules lookup. JS recognizes Biome/Prettier/ESLint configs and package fields/dependencies; both formatters ambiguous unless override. ESLint alone never formats. Exact installed package version checked against exact declaration; ranges require lockfile and installed metadata (npm/pnpm/yarn/bun lock presence). No project policy → managed Prettier default.
- Python recognizes Ruff/Black pyproject sections and `.venv/venv/bin` local executables; explicit tool versions checked when declared. Config implies project requirement and missing local tools warn. Lua/Bash analogous local/config requirement, managed StyLua/shfmt only absent project requirement. Defaults explicit manifest: StyLua v2.5.2, shfmt v3.14.1, Prettier 3.9.9; reuse Ruff.
- Biome formatter argv `format --stdin-file-path` only; never check/write/import actions. ESLint managed transport 4.10.0 only starts with config and project-local eslint library. settings disable format/codeActionOnSave; explicit EslintFixAll remains manual. Biome native LSP cmd is required local binary and config-only; explicit code actions remain native.
- Tests install exact local Prettier/Biome/ESLint in isolated fixtures, format actual code, preserve lint-error/import fixtures on save, test explicit ESLint fix, failure/missing/opt-outs/exclusions and monorepo/overrides. Use argv process scripts for timeout/error fixtures, no mocked conform.

## Risks / Trade-offs

- [Many possible project policies] → Conservative supported detection, explain ambiguity and documented explicit override rather than guess scripts.
- [ESLint formatter-like rules] → Diagnostics/manual fixes only, never formatter selection.
- [Tool fails on config] → Save continues with original edits and a reason; no substitute.

## Migration Plan

Provision managed/local fixture tools, test policy and real save/lint operations, document override shape, sync/archive then commit. Revert increment and preceding manifest/lock to roll back.
