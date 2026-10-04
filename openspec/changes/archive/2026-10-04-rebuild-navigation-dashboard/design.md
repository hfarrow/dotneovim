# Design

## Context

Phase 1 established core options, explicit saves, lazy lock restore and package isolation. See proposal.md and the approved umbrella design. No navigation plugin currently owns directory routing.

## Goals / Non-Goals

**Goals:** One startup router; shared bounded directory/project resolution; test real picker results and tree filesystem changes.

**Non-Goals:** Sessions, buffer bars, native sorters or project registries.

## Decisions

- Disable netrw before plugin loading. Capture stdin and invocation intent early; at VimEnter replace a sole directory with an empty buffer, set cwd to it, then explicitly load Dashboard. Dashboard's automatic startup is suppressed for other invocations by command-only loading.
- Use nvim-tree v1.18.0 and Telescope v0.2.2; current untagged dashboard/lualine/devicons/plenary commits and Which-key stable are locked after provisioning. Tree never hijacks directories; subsequent directory edits explicitly open it.
- Share `config.project` roots using bounded native ancestor search for `.git`, workspace and language markers, including `.git` files. Search captures directory context before opening UI. ripgrep argv implements both result matrices, always excluding `.git`; no shell commands or cwd changes. Picker `<C-v>` cycles visibility and `<C-r>` changes scope, preserving prompt text.
- Keep standard tree file-operation keys with explicit help and focus toggle. Telescope Enter/normal `;` confirm, `<C-j/k>` navigate and `<C-q>` hand off results. Which-key consumes described mappings; lualine uses automatic theme.
- Add an attached external-UI harness using Python Msgpack 1.2.3 in an isolated venv, plus headless real-plugin assertions. A Neovim-hosted RPC client did not handle incoming UI redraw notifications; the external client consumes them explicitly. UI tests validate dashboard routing and first tree/picker drawing, not terminal-specific glyph rendering or appearance notifications (phase 7).

## Risks / Trade-offs

- [Dashboard default takeover] → Command-only loading under the startup router and a launch matrix.
- [Picker controls lose context] → Capture immutable directory/root and restart only the picker with its prompt.
- [Tree destructive operations prompt] → Use real API operations with controlled fixture-only input callbacks in tests.

## Migration Plan

Provision locked dependencies in isolated data, validate fixtures and startup/UI, sync/archive, then commit. Revert this increment and restore the preceding lock to roll back.
