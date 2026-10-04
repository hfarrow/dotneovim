# Phase 2 evidence — 2026-10-04

Neovim 0.12.5, macOS arm64, isolated XDG paths under the approved validation environment. Provisioned with `nvim -l scripts/install.lua` and locked all revisions in lazy-lock.json. Tree 1.18.0, Telescope 0.2.2, Which-key 3.17.0; untagged Dashboard/devicons/plenary/lualine reviewed at locked upstream commits.

Passed `tests/run.lua core` (including compilation of every runtime Lua file), `navigation`, `lifecycle`, and `offline` with unreachable proxies. Navigation exercises real rg and Telescope files/grep × three modes × two scopes, nested roots, worktree marker, no-project fallback, cwd preservation, quickfix, recent/buffer/current-buffer first use and real tree create/rename/copy/cut/paste/full-path move/delete with fixture-only prompt answers.

Passed attached external UI `tests/ui.py`: actual grid redraw events, empty/directory/file/multi-file/commit startup, header, first dashboard `e` and leader tree close/focus, first `f`, visibility/scope input controls and actual stdin launch. Installed test-only `msgpack==1.2.3` in validation/ui-venv. No host Python packages modified.

Theme notifications and Nerd Font terminal rendering remain phase 7 checks; this validates the attached grid, not Ghostty/cmux appearance. No blockers.
