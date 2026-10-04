# Phase 3 evidence

2026-10-04, macOS arm64, Neovim 0.12.5, isolated validation XDG. Installed `brew install tree-sitter-cli` 0.27.0 (the preexisting tree-sitter library provided no executable). Built thirteen focused parsers with clang through explicit `scripts/parsers.lua`, plus inherited ecma/jsx query support. Exact parser revisions are the install_info table in locked nvim-treesitter `e289100`; compatible textobjects `5c7b026`. Surround 4.0.5 `2e93e15`; current Codeberg Leap `277e04f`; remaining plugins in lazy-lock.json.

Passed real-parser parse/highlight-query checks for every provisioned language. `tests/run.lua reading` passed native highlight attachment, Lua function/argument objects and function movement, Python linewise class/movement, surround first operation/count/dot-repeat/change/delete/visual, actual typed pairs, real Markdown extmarks/toggle/content preservation/spell/filetype cleanup, Zsh parser exclusion, >1 MiB/long-line guard and actionable missing-parser warning. Personal spell files have no diff.

Attached `tests/ui.py` passed first normal/visual/operator Leap through real input, alongside prior dashboard launch/first-use matrix. Core (all runtime Lua compilation), navigation, lifecycle and unreachable-proxy offline checks passed again. Native gx is retained. Live terminal appearance/platform integration and profiling stay phases 7–8. No blockers.
