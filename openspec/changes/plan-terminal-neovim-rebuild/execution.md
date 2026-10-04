# Execution ledger

## Authorization

On 2026-10-04, after reviewing the initial proposal, the user explicitly approved the roadmap and authorized orchestration until completion or a blocker requiring input. Child changes may be created, applied, synchronized, and archived without additional human approval within the approved scope. Material scope decisions and unavailable required acceptance checks still require input.

Every implementation change follows **validate → archive/sync → commit**. Do not commit an implementation while its change remains active. The initial approved planning checkpoint is separate; this umbrella stays active until the whole roadmap is delivered.

Subsequent phase 7 authorization: the user enabled Accessibility, Automation and screen capture, restarted cmux, and explicitly permitted temporary light/dark switching for testing. Accessibility and CoreGraphics screen-capture preflight now both pass. Capture the original appearance settings and restore them after testing; do not modify terminal config files or other panes' contents.

Branch: `rebuild/neovim-modernization`. Reference: `9746670fb9dc3640969151947b110380aac178f4`, preserved in the detached reference worktree named in `design.md`.

## Checkpoints

| Phase | Change | Dependencies | Status | Archive | Commit | Evidence / blockers |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | rebuild-terminal-foundation | Approval | Complete | 2026-10-04-rebuild-terminal-foundation | f382bbd | Core/lifecycle/offline/missing-manager checks passed; see archived evidence.md |
| 2 | rebuild-navigation-dashboard | 1 | Complete | 2026-10-04-rebuild-navigation-dashboard | 3d60756 | Real search/tree and attached UI matrix passed; see archived evidence.md |
| 3 | rebuild-reading-editing | 1, 2 | Complete | 2026-10-04-rebuild-reading-editing | 0a1acf5 | Real parsers/objects/aids/rendering/guards and attached Leap passed |
| 4 | rebuild-language-tooling | 1, 3 | Complete | 2026-10-04-rebuild-language-tooling | 222a191 | Real managed server handshakes/navigation/ShellCheck and attached completion passed |
| 5 | rebuild-project-formatting | 4 | Complete | 2026-10-04-rebuild-project-formatting | 0d497dc | Real Conform save pipeline, project tools/lint/manual fix, exclusions and failures passed |
| 6 | rebuild-git-terminals | 1, 2 | Complete | 2026-10-04-rebuild-git-terminals | c42979f | Real scratch Git and attached shell/LazyGit lifecycle/cwd/focus/reload passed |
| 7 | verify-portable-setup | 2–6 | Complete | 2026-10-04-verify-portable-setup | Recorded after commit | Fresh restore/suites/clipboard, actual native dark/light/live and screenshots passed; normal runtime provisioned |
| 8 | optimize-terminal-performance | 7 | Pending | — | — | Not run |

Planning validation: strict OpenSpec validation passed before approval. Approved planning checkpoint: `60556a6`. Phases 1–6 implemented and tested in isolation. Phase commits are created only after verified sync/archive; the next checkpoint records each actual prior commit.

## Phases 2–6 handoff

All child archives contain evidence.md. Reusable validation: `tests/run.lua core|navigation|reading|language|formatting|git|lifecycle|offline`; attached UI: validation/ui-venv/bin/python tests/ui.py with DOTNEOVIM_TEST_HOME. Explicit fixture dependencies installed by scripts/format-fixtures.lua. Actual parser builds use tree-sitter-cli 0.27.0, clang; test-only Python Msgpack 1.2.3 in isolated venv. Managed versions are in config.tools and receipts; local fixture Prettier/Biome/ESLint are exact and npm-locked.

Phase 7 completed after subsequent authorized appearance switching. Actual native dark/light startup, light→dark→light live updates and derived highlights passed; actual window screenshots visually inspected. Original light setting and absent automatic/style keys restored; terminal config unchanged; test workspace cleaned and original workspace restored. See archived phase 7 evidence for initial blocker and resolution. Normal runtime plugins/parsers/tools explicitly provisioned and default startup/health passed; legacy data retained.

Phase 8 now owns performance samples/tuning and final acceptance. Windows/WSL reviewed only, runtime-untested. Spell and IdeaVim source unchanged. Umbrella remains active until all final checks and phase 8 delivery complete.
