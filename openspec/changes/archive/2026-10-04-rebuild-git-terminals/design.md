# Design

## Context

See proposal.md. Foundation already checks external file updates on focus/buffer entry. Structural class motions own `[c/]c`, so hunk keys must not overwrite them. Git 2.53.0 and LazyGit 0.60.0 available.

## Goals / Non-Goals

**Goals:** Real Git/index and terminal process/UI evidence, public plugin APIs, clear cwd and identity.

**Non-Goals:** Diffview, debugger terminals, OS terminal config or appearance changes.

## Decisions

- Stable Gitsigns real-file events, public API, guard exclusions and staged signs. Hunk movement `[h/]h`, leader-hp/hs/hr/hb plus visual stage/reset; no class-motion conflict or always-on blame.
- Stable Toggleterm command/key loading. `config.terminal` owns shell instances by layout (horizontal id1, vertical id2, float id3), closing visible alternate layouts first as upstream does not support mixing them. Shell cwd is editing directory at creation and persists. Dedicated LazyGit uses a native hidden terminal buffer/float under the same module: Toggleterm 2.13.1 concatenates commands into shell strings and cannot accept argv, so native jobstart supplies portable argv without private plugin overrides. Project switch replaces an old hidden Git process.
- Spawn LazyGit via argv executable through terminal job API support after checking current plugin implementation; no shell concatenation or git_dir private limitations. Resolve Git root with `git -C dir rev-parse --show-toplevel` argv (worktrees supported). Normal leader-lg and terminal Ctrl-g toggle dedicated Git float; Esc and Ctrl-\\ Ctrl-n leave terminal mode; terminal Ctrl-h/j/k/l navigate splits. LazyGit native q receives input unmodified.
- on_close/on_exit schedule editing focus, FocusGained reload and public Git/tree refresh. Do not write buffers or overwrite modified files. Preserve current view through existing core reload logic.
- Attached RPC UI tests exercise actual PTY jobs and delivered keys; scratch Git fixture commits use explicit per-command identity (not git config changes). Headless hunk tests inspect real index diffs and previews.

## Risks / Trade-offs

- [Terminal wrapper assumes command string] → Inspect current API; use argv where accepted or native jobstart bridge with public lifecycle, never interpolate host paths into shell text.
- [Exit callback races closed window] → Check window validity and schedule focus/refresh after plugin closes.
- [UI hunk mappings conflict] → Audit after filetype/Git attach; choose separate hunk family.

## Migration Plan

Provision locked plugins, run scratch Git and attached terminal lifecycle tests, document shell/LazyGit setup, sync/archive then commit. Revert increment/lock to roll back; no user shell/terminal config changes.
