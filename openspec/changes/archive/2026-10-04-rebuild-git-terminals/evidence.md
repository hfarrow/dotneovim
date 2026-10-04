# Phase 6 evidence

2026-10-04, macOS arm64, Neovim 0.12.5, Git 2.53.0, LazyGit 0.60.0. Installed/locked Gitsigns 1.0.2 `7010000` and Toggleterm 2.13.1 `50ea089` explicitly in isolated XDG data.

`tests/run.lua git` passed actual scratch Git commit, Gitsigns attach, two real hunks, movement and popup preview, stage reflected in actual index diff, external unstage refresh and reset reflected in buffer, nonconflicting hunk mapping and Git/worktree root resolution. Fixture identity passed through process environment, no git config changes.

Attached `tests/ui.py` passed real Toggleterm shell PTYs in horizontal/vertical/float layouts, first-use/layout switch, job identity across hiding, process `pwd` output written inside fixture proving actual cwd, terminal Esc, split Ctrl-k/j, Ctrl-g focus return and `exit`. Actual LazyGit spawned with argv in native terminal float, Git-root cwd, leader-lg first use, hide/reopen same job, native q process exit, fresh reopen, external reload/view preservation and unsaved protection. Missing binary warning checked. Fixed delayed close-focus race and directory inheritance when switching from a terminal.

Toggleterm's current public implementation concatenates cmd strings, so dedicated LazyGit uses native jobstart argv plus float rather than private overrides or shell interpolation. Ordinary shell layouts remain Toggleterm. No cmux/Ghostty/OS configuration changed.

All core (runtime Lua compilation), reading, navigation, language, formatting, lifecycle and proxy-offline suites passed with phase 6 plugins installed. Full attached startup/Leap/Blink/Zsh suite passed with terminal additions. Explicit parser installer verified again; it now installs missing parsers before updating existing ones (upstream update intentionally excludes missing). Personal dictionary unchanged. No blockers.

Remaining integration belongs to parent phases 7–8: completely fresh install/tool/parser restore, macOS real system clipboard, actual Ghostty/cmux theme notification/live switching and glyph display, Windows/WSL runtime/path/shell review, health consolidation and repeated startup/first-use/large-file profiling. No claims of those checks passing.
