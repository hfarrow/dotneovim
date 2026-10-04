# Tasks

## 1. Approval and execution setup

- [x] 1.1 Obtain explicit approval of this roadmap for execution and record the approved scope and authorization in an execution ledger; verify that approval occurs after the proposal is presented and before runtime changes.
- [ ] 1.2 Commit the approved planning artifacts on `rebuild/neovim-modernization` after inspecting status, diff, and recent history; verify only intended planning files are staged and the reference worktree still points to `9746670`.
- [ ] 1.3 Create the execution ledger with child-change names, dependencies, archive paths, commit IDs, validation results, and blockers; verify every phase in design section 8 has a pending entry and no unperformed checks are marked passed.

## 2. Terminal foundation increment

- [ ] 2.1 Propose `rebuild-terminal-foundation` with `terminal-core` and `plugin-lifecycle` deltas, baseline/isolation tasks, setup prerequisites, and precise register/save/reload/wrap scenarios; verify complete artifacts and strict OpenSpec validation before apply.
- [ ] 2.2 Apply the foundation child, replacing the legacy runtime loader with modular core configuration, lazy.nvim, the theme, and a tested lockfile; verify Lua syntax, isolated headless/core behavior, first bootstrap and provisioned offline startup, and deliver its setup/mapping documentation.
- [ ] 2.3 Finalize the foundation child only after its required checks pass: archive/sync deltas, commit intended files, and update the ledger; verify archive path, commit ID, recorded baseline measurements, and completed child tasks.

## 3. Navigation and dashboard increment

- [ ] 3.1 Propose `rebuild-navigation-dashboard` with `workspace-navigation` scenarios for dashboard routing, consistent `e` tree keys, three visibility modes in both scopes, tree operations, buffers, and shortcut discovery; verify artifacts, fixture matrix, and strict validation.
- [ ] 3.2 Apply navigation/dashboard with dashboard-nvim Hyper, Telescope, nvim-tree, Which-key, and the restrained statusline; verify real first-use actions, file/directory/stdin startup, search-result inclusion/exclusion, root/cwd behavior, tree focus/file operations, and publish its shortcut guide.
- [ ] 3.3 Archive and commit the navigation child after acceptance, updating the ledger; verify completed tasks, archive/commit references, mapping audit, and attached-UI evidence or explicit blockers.

## 4. Reading and editing increment

- [ ] 4.1 Propose `rebuild-reading-editing` with `reading-editing` deltas covering focused parsers, local Markdown behavior, structural objects/jumps, surround, pairs, Leap, rainbow delimiters, and large-file exclusions; verify upstream loading/API choices and strict validation.
- [ ] 4.2 Apply the reading/editing child and document its setup/toggles; verify installed parser/query compatibility, real select/move/surround operations including first use/counts/dot-repeat, pair behavior, raw/rendered Markdown without content changes, spell dictionary preservation, filetype cleanup, and missing-parser/large-file fallback.
- [ ] 4.3 Archive and commit the reading/editing child after acceptance, updating the ledger; verify recorded plugin/parser revisions, completed child tasks, test evidence, and archive/commit references.

## 5. Language tooling increment

- [ ] 5.1 Propose `rebuild-language-tooling` with `language-tooling` deltas, a versioned Mason provisioning procedure, native LSP ownership, completion acceptance semantics, and explicit Zsh fallback; verify server/runtime compatibility decisions and strict validation.
- [ ] 5.2 Apply Mason, native LSP definitions/activation, and stable Blink for Bash/JS/TS/Lua/Python, documenting runtimes and Python environment handling; verify real server initialization/navigation on fixtures, capability ordering, no C#/Rust/Zsh LSP attachment, quiet diagnostics, automatic/no-preselect completion, Enter newline, selected `<C-y>` acceptance, native snippets, and managed-tool precedence.
- [ ] 5.3 Archive and commit the language child after acceptance, updating the ledger; verify actual installed tool versions, completed checks/tasks, health results, and archive/commit references.

## 6. Project formatting increment

- [ ] 6.1 Propose `rebuild-project-formatting` with `project-formatting` deltas for project-pinned tools, nearest-package/monorepo policies, save format-only behavior, explicit lint fixes, missing-tool handling, and opt-outs; verify fixture cases and strict validation.
- [ ] 6.2 Apply Conform and project-scoped Biome/ESLint integrations, documenting policy and explicit fix commands; verify actual format-on-save and manual formatting for supported files, no save-triggered lint/import fixes, no automatic Markdown/text/log/Zsh/C#/Rust changes, project versions/configs, ambiguous/missing formatter feedback, timeout/failure preservation, and opt-outs.
- [ ] 6.3 Archive and commit the formatting child after acceptance, updating the ledger; verify completed tasks, executable formatter/lint evidence alongside policy fixtures, and archive/commit references.

## 7. Git and terminal increment

- [ ] 7.1 Propose `rebuild-git-terminals` with `git-terminal-workflows` deltas for Gitsigns, Toggleterm layouts, dedicated LazyGit lifecycle, focus/exit/navigation, and external-change handling; verify setup/mapping decisions and strict validation.
- [ ] 7.2 Apply Git/terminal workflows and document binary/shell requirements; verify real scratch-repo hunk navigation/preview, staged/unstaged updates, LazyGit launch/toggle/exit at `<leader>lg`, shell layout toggles, correct cwd/focus, and unmodified-buffer reload after external changes.
- [ ] 7.3 Archive and commit the Git/terminal child after acceptance, updating the ledger; verify completed tasks, terminal/attached-UI evidence, and archive/commit references.

## 8. Portable setup integration increment

- [ ] 8.1 Propose `verify-portable-setup` against the now-existing capability specs with fresh-install, health, path/shell/clipboard, and appearance integration scenarios; verify deltas update their owning capabilities and strict validation.
- [ ] 8.2 Apply any necessary integration/setup fixes and consolidate macOS/Windows/WSL documentation; verify fresh isolated provisioning and locked restore, provisioned offline startup, full startup matrix, executable health checks, macOS clipboard, and actual cmux/Ghostty light/dark startup and live switching; explicitly distinguish Windows/WSL review from unperformed runtime tests.
- [ ] 8.3 Archive and commit the portable-setup child after acceptance, updating the ledger; verify all required Mac checks, documented remaining platform checks, completed tasks, and archive/commit references.

## 9. Performance and final acceptance increment

- [ ] 9.1 Propose `optimize-terminal-performance` with evidence-grounded budgets and a repeatable measurement protocol for startup, first actions, and large files; verify original/minimal baseline limitations, sample definitions, reviewed targets, and strict validation.
- [ ] 9.2 Profile and optimize eager/deferred loading while honoring upstream constraints; verify at least ten warmed samples per startup scenario, separately labeled empty-cache results, median/p95 with environment/revisions, first picker/tree/completion/terminal latency, responsive large-log/minified-line fixtures, and no downloads/update work on normal startup.
- [ ] 9.3 Run final cross-capability acceptance after optimization and publish performance/validation evidence; verify core/plugin/mapping/startup/formatting checks still pass, appearance remains correct, budgets are met or explicitly reviewed, and no blocker is presented as success.
- [ ] 9.4 Archive and commit the performance child, update the complete execution ledger, then archive/sync and commit this umbrella change; verify all child and umbrella tasks are completed, strict OpenSpec validation passes, intended commits are on the rebuild branch, and the reference remains recoverable.
