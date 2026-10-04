# Spec Delta

## Purpose

Honor project-required formatting versions and configuration while keeping explicit code saves format-only, recoverable on failure and independent from manual lint cleanup.

## ADDED Requirements

### Requirement: Project policy precedes defaults
Formatting SHALL honor explicit overrides, nearest package/workspace config and pinned local tools before managed defaults; missing or ambiguous project tools SHALL warn without substitution.

#### Scenario: Monorepo package policy
- **WHEN** nested packages declare different formatters/configs
- **THEN** each file uses its nearest relevant policy and installed pinned tool, with workspace dependency lookup

#### Scenario: Missing or ambiguous dependency
- **WHEN** a required formatter is missing, mismatched or competing policies have no declared owner
- **THEN** formatting is skipped with actionable feedback and explicit save succeeds

### Requirement: Explicit saves format only supported code
Explicit supported code saves SHALL run one bounded format-only operation before writing, never fixes/import organization or generic LSP fallback; Markdown/text/logs/Zsh/C#/Rust SHALL remain untouched automatically.

#### Scenario: Save supported code
- **WHEN** JS/TS, Lua, Python or Bash is explicitly saved with an available formatter
- **THEN** the written content is formatted while lint fixes, unused imports and import order remain untouched

#### Scenario: Excluded buffer
- **WHEN** Markdown/text/logs/Zsh/C#/Rust is saved
- **THEN** no automatic formatter changes its contents

### Requirement: Formatting failure preserves edits
Formatter timeout/failure SHALL preserve edits and permit save with a warning; global and per-buffer opt-outs SHALL suppress automatic formatting, with manual format available separately.

#### Scenario: Failure or opt-out
- **WHEN** a formatter fails/times out or automatic formatting is disabled
- **THEN** save retains the user's content and failure reports its reason

### Requirement: Lint cleanup is explicit
Configured project ESLint/Biome diagnostics SHALL use project tools and libraries; fixes and cleanup SHALL require an explicit action and SHALL never run on save.

#### Scenario: Configured lint project
- **WHEN** a configured project reports diagnostics then a file is saved
- **THEN** diagnostics remain without automatic fixes, and a deliberate fix command/code action can apply cleanup
