# Design

## Context

Phase 1 of the approved umbrella. See its design for retained habits and subsequent owners. Neovim 0.12.5 arm64 is installed. Current lazy stable is v11.17.5; Material has no required semver release and current reviewed revision is `11d779b26a9ab2b3db8c22c6ac9fb6e8ed4fea79`.

## Goals / Non-Goals

Goals: usable plugin-independent core, explicit installation, realistic baseline, isolated checks.
Non-goals: navigation/dashboard/language plugin functionality delivered by later phases.

## Decisions

- Entry point derives repo root from its own source, adds it to runtimepath for `-u /path/init.lua` use, and loads options/keymaps/autocmds before lazy setup. Replace all legacy Lua runtime and root filetype helpers; retain personal spell source.
- Set packpath to the Neovim runtime only before plugin scanning. lazy owns dependencies under `stdpath('data')/lazy`; unmanaged old Packer start plugins do not load. This is simpler and safer than cleaning shared user installations.
- An explicit `nvim -l scripts/install.lua` bootstrap clones lazy at the locked commit, then starts this init and executes synchronous lazy install/restore. Routine startup does not clone and uses `install.missing=false`, checker disabled, and no change notifications.
- Lockfile path follows the actual repo root, not an assumed ~/.config/nvim path. Manager itself is locked and validated by installer; no absolute installed paths are tracked.
- `clipboard=''`; leader-y maps to `"+y`; normal pastes use `"+p`/`"0p`, visual pastes use `P` with explicit source to preserve it. Test actual mapping behavior using deterministic clipboard provider stub; real OS clipboard validation belongs to integration.
- Two-space defaults, ignorecase/smartcase, absolute numbers, right/below splits, finite 500ms mapping timeout, 50ms terminal timeout, persistent undo, safe backups outside projects. Disable autowrite/autowriteall. No physical auto-wrap (`formatoptions` removes t/c/a; textwidth retained for explicit prose formatting).
- Reload only unmodified ordinary file buffers. Capture window views around checktime; defer out of fast events; no notification spam or overwrite of unsaved edits. Cursor restoration excludes commit/special buffers. Apply wrap policy on buffer/window enter after filetype detection; `.txt` filetype detection explicit.
- Theme eager with medium/material colors; never set background. Manual `Appearance dark/light` command remains available. Actual terminal switching belongs to phase 7.
- Portable Lua tests invoked by `nvim --headless -u init.lua -c 'luafile tests/core.lua'`; separate XDG data/state/cache environment. Script mode (`-l`) disables user startup/plugin loading, so the explicit installer enables loading itself. Baseline captured before deleting runtime: minimal startup, original `-u reference/init.lua` with explicit rtp. Original failures recorded rather than timed as success.

## Risks / Trade-offs

- [Worktree does not isolate dependency state] → Dedicated XDG environment and packpath audit.
- [Clipboard provider isn't available headlessly] → Core mock verifies register semantics; real provider deferred to explicit integration checks.
- [Missing dependencies during first launch] → Core fallback plus explicit documented installer, never implicit downloads.

## Migration Plan

Capture original evidence; implement and provision in isolated data; run core, missing-dependency, locked restore and offline checks; update README/keymap guide/evidence; complete tasks; archive/sync both specs; commit implementation. No shared plugin deletion.
