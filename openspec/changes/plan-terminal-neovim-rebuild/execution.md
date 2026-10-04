# Execution ledger

## Authorization

On 2026-10-04, after reviewing the initial proposal, the user explicitly approved the roadmap and authorized orchestration until completion or a blocker requiring input. Child changes may be created, applied, synchronized, and archived without additional human approval within the approved scope. Material scope decisions and unavailable required acceptance checks still require input.

Every implementation change follows **validate → archive/sync → commit**. Do not commit an implementation while its change remains active. The initial approved planning checkpoint is separate; this umbrella stays active until the whole roadmap is delivered.

Branch: `rebuild/neovim-modernization`. Reference: `9746670fb9dc3640969151947b110380aac178f4`, preserved in the detached reference worktree named in `design.md`.

## Checkpoints

| Phase | Change | Dependencies | Status | Archive | Commit | Evidence / blockers |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | rebuild-terminal-foundation | Approval | Complete | 2026-10-04-rebuild-terminal-foundation | f382bbd | Core/lifecycle/offline/missing-manager checks passed; see archived evidence.md |
| 2 | rebuild-navigation-dashboard | 1 | Complete | 2026-10-04-rebuild-navigation-dashboard | 3d60756 | Real search/tree and attached UI matrix passed; see archived evidence.md |
| 3 | rebuild-reading-editing | 1, 2 | Complete | 2026-10-04-rebuild-reading-editing | 0a1acf5 | Real parsers/objects/aids/rendering/guards and attached Leap passed |
| 4 | rebuild-language-tooling | 1, 3 | Complete | 2026-10-04-rebuild-language-tooling | 222a191 | Real managed server handshakes/navigation/ShellCheck and attached completion passed |
| 5 | rebuild-project-formatting | 4 | Complete | 2026-10-04-rebuild-project-formatting | Recorded in next checkpoint | Real Conform save pipeline, project tools/lint/manual fix, exclusions and failures passed |
| 6 | rebuild-git-terminals | 1, 2 | Pending | — | — | Not run |
| 7 | verify-portable-setup | 2–6 | Pending | — | — | Not run |
| 8 | optimize-terminal-performance | 7 | Pending | — | — | Not run |

Planning validation: strict OpenSpec validation passed before approval. Approved planning checkpoint: `60556a6`. Phases 1–2 implemented and tested in isolation. Phase commits are created only after verified sync/archive; the next checkpoint records each actual prior commit.
