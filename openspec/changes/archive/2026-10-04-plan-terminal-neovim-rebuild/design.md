# Design

## Context

See `proposal.md` for motivation and `specs/configuration-delivery/spec.md` for the delivery contract. This is an umbrella roadmap, not a single monolithic runtime replacement. The user's workflow interview is the source of the target decisions below; historical installation alone does not establish a requirement.

- Reference: `9746670fb9dc3640969151947b110380aac178f4`, originally branch `v2`.
- Detached reference worktree: `/var/folders/fw/js0vb6j54xb6z48sywnb_vj40000gr/T/opencode/dotneovim-v2-reference-20261004`.
- Rebuild branch: `rebuild/neovim-modernization`, created before any commits.
- Initial working tree was clean. Local and upstream stable Neovim were 0.12.5 during research on 2026-10-04.
- No active OpenSpec changes or main capability specs existed. Three read-only parallel audits covered core editing, language tooling, and navigation/UI. No full original-config startup or rebuilt plugin installation has been claimed.

### Grounded problems to repair

| Evidence in reference | Consequence | Target decision |
| --- | --- | --- |
| `init.lua:13-16,31-41`; `settings.lua:17` | Generated plugin mappings precede Space leader | Set leaders before all mapping owners |
| `packer_compiled.lua`; captured attach callback in `plugins.lua:55-85` | Serialized configuration loses captured locals and embeds host paths | Use ordinary modules/functions and lazy specs |
| `keymaps.lua:16-17,58`; `plugins.lua:587-614,926` | Multiple search owners and duplicate paragraph/history keys | One mapping owner; no unused history/search decorators |
| `keymaps.lua:35-49`; `settings.lua:85,89` | Clipboard coupling, discarded explicit-register intent, ambiguous leader prefixes | Native registers, explicit clipboard keys, finite mapping timeout |
| `settings.lua:77,132-135` | Implicit writes during navigation/focus changes | Explicit saves only |
| `ftplugin/markdown.lua:12-13,23-42` | Global Markdown mappings and delayed helper setup | Buffer-local filetype behavior after runtime defaults |
| `plugins.lua:103-225,642-661,834-847` | Obsolete LSP/Trouble APIs, language leakage, Linux executable paths | Current APIs and discovered/managed tool paths |

## Goals / Non-Goals

**Goals:**
- Make each increment usable and independently verifiable; maintain handoff-ready artifacts.
- Separate core editing, startup routing, plugins, and tool policy so loading order is obvious.
- Treat startup and first-use latency as separate metrics; preserve upstream-required early loading.
- Prefer one owner per capability and explicit project policy over implicit fallback chains.

**Non-Goals:**
- A custom distribution, bespoke plugin manager, generalized cross-editor framework, or inventory of every historical binding.
- New sessions/projects frameworks, debugging, browser Markdown preview, Zsh LSP experiments, or full C#/Rust development tooling.
- Modifying terminal configuration outside this repo as part of the rebuild.

## Decisions

### 1. Approved target and scope boundaries

| Workflow | Agreed target |
| --- | --- |
| Editor role | Lightweight standalone terminal editor: reading/search plus occasional code edits |
| Readable file types | Text, logs, Markdown, C#, Bash/Zsh, JS/TS, Lua, Rust, Python |
| Semantic tooling | Bash, JS/TS, Lua, Python; no C#/Rust LSP initially |
| Zsh | Native dialect-appropriate highlighting and buffer/path completion; no Shuck, dedicated server, Bash linting, or automatic formatting |
| Startup | Plain `nvim` and directory-only invocation show the familiar Hyper dashboard; tree is opened on demand |
| Navigation | Fuzzy files, contents, recent files, buffers; polished tree browsing and create/rename/move/copy/delete |
| Search visibility | Normal, hidden, and all/ignored modes, each quickly accessible for files and contents |
| Search scope | Opened/current directory by default; quick project-root widening without changing cwd |
| Saves | Manual saves; supported code formats on save; no focus-loss or navigation autosave |
| Formatter policy | Project-required/pinned tools and config win; Mason defaults only when no project policy exists |
| Fixes | ESLint fixes and import/code-cleanup actions explicit, never implicitly run on save |
| Reading | Markdown/text soft wrap at words; code/logs nowrap; per-window toggle |
| External file updates | Reload unmodified buffers on focus/buffer checks, preserving view; no live-follow feature |
| Diagnostics | Signs plus explicit float/navigation/picker; no automatic inline or virtual-line messages |
| Appearance | Gruvbox Material palette close to current terminal; automatic terminal light/dark tracking |
| Git/terminal | Gitsigns, frequent LazyGit use, retained Toggleterm shells/layouts |
| Editing aids | Surround `gz` vocabulary, automatic pairs, Leap, rainbow delimiters, function/class/argument objects and structural jumps |
| Discovery/completion | Which-key; automatic completion without preselection, explicit accept, native LSP snippets only |
| Host scope | Terminal first; clean separation for potential VS Code/IdeaVim follow-ups |

Omit initially: Barbar/buffer bar, Neoclip/SQLite persistence, Zen Mode, Diffview, DAP/adapters, Rust tools, C# tooling, YAML LSP, snippet collections/extra engine, lsp_lines, Comment.nvim, vim-sensible, interestingwords, hlslens, scrollbar, and bespoke blog-image helpers. Preserve the personal spell source dictionary; regenerate its binary only through Neovim if needed. Do not add unrelated features such as AI completion or session restoration.

### 2. Simple modular configuration with lazy.nvim

Proposed structure (exact filenames can be refined by child design without changing behavior):

```text
init.lua                      minimal entry point
lua/config/options.lua        leaders and core preferences
lua/config/keymaps.lua        core keys, descriptions, ownership
lua/config/autocmds.lua        reload, cursor restore, wrap, safeguards
lua/config/lazy.lua            bootstrap and manager settings
lua/config/startup.lua         empty/directory/file/stdin routing
lua/config/tools.lua           editor-managed tool/version policy
lua/config/project.lua         bounded roots and formatter policy
lua/config/health.lua          actionable dependency/capability reporting
lua/plugins/*.lua             small capability-oriented lazy specs
after/ftplugin/*.lua           local overrides and undo cleanup
lazy-lock.json                tested plugin revisions
tests/                        focused fixtures and portable Lua checks
docs/                         setup, keymap guide, validation/performance
```

Set leaders/options first, then core behavior, then manager/plugin initialization. Scope filetype changes locally and implement cleanup. Keep host-specific conditions isolated; do not build inactive adapters. Use two-space Lua indentation and single quotes where practical. Remove the legacy runtime paths/compiled loader during foundation replacement rather than keeping a parallel legacy setup.

Use lazy.nvim instead of Packer or native `vim.pack`: the user chose declarative lazy loading, management UI, lockfile restore, and profiling. `vim.pack` remains experimental in versioned 0.12.5 docs and requires more orchestration code. Establish a documented install/bootstrap step; no auto-update, registry refresh, or tool/parser installation during provisioned routine startup.

### 3. Focused plugin set and loading ownership

Versions below are research references, not an instruction to install stale revisions when implementation begins. Recheck upstream stable tags/current compatibility, then lock the tested revision. Prefer stable releases; use reviewed current commits when a maintained project has no suitable release. Record exceptions and parser compatibility in child evidence.

| Owner / plugin | Purpose and loading policy |
| --- | --- |
| lazy.nvim | Manager early; v11.17.5 observed |
| sainnhe/gruvbox-material | Theme early before first useful redraw; medium/material palette |
| nvimdev/dashboard-nvim | Hyper dashboard only for applicable empty/directory startup |
| nvim-tree/nvim-tree.lua | Tree on command/key, one directory-handler owner; 1.18.0 observed |
| nvim-tree/nvim-web-devicons | Shared icon provider for tree/picker/UI; loaded through consumers |
| nvim-telescope/telescope.nvim + plenary.nvim | Single picker; command/key loaded; v0.2.2 tag observed |
| folke/which-key.nvim | Deferred shortcut discovery; descriptions from actual mappings |
| nvim-lualine/lualine.nvim | Proposed restrained statusline; use theme-derived colors, no buffer bar |
| nvim-treesitter/nvim-treesitter | Current `main` APIs, eager as required upstream; parser list explicit |
| nvim-treesitter-textobjects | Current compatible APIs; explicit select/move mappings, no swap module |
| HiPhish/rainbow-delimiters.nvim | Parser-backed nested-delimiter colors; exclude expensive large buffers |
| MeanderingProgrammer/render-markdown.nvim | Markdown-only render/raw toggle; no browser or external Glow dependency |
| kylechui/nvim-surround | Current v4 `<Plug>` mapping API with defaults disabled; `gz` family |
| windwp/nvim-autopairs | Insert-triggered typed-character pairing; no competition for completion acceptance |
| Leap, current Codeberg upstream | Small plugin registration early; internal lazy loading per upstream, not lazy key replay |
| lewis6991/gitsigns.nvim | Real file buffer events, hunk signs/preview/navigation; no second diff provider |
| akinsho/toggleterm.nvim | Shells and isolated LazyGit instance on keys/commands |
| neovim/nvim-lspconfig | Server definition data with native `vim.lsp.config/enable`, not legacy setup |
| mason-org/mason.nvim | Minimal setup early before executable resolution, not delayed behind `:Mason` |
| saghen/blink.cmp | Stable v1 compatible series (v1.10.2 observed); capabilities prepared before any server starts |
| stevearc/conform.nvim | One formatting owner; save-event/manual-command loaded |

Use native commenting, diagnostics, snippet expansion, EditorConfig, undo, clipboard provider discovery, and quickfix/location lists. Omit Trouble initially: diagnostic/result pickers and native persistent lists cover current needs. Do not add nvim-lint/none-ls unless a later requirement has diagnostics unavailable from the chosen servers.

No native Telescope sorter by default: measure first before adding its compiler/build dependency. Blink's prebuilt matcher is preferred where supported; document a tested Lua fallback. No extra Mason auto-enabling bridges are required unless implementation demonstrates a concrete simplification without losing explicit ownership.

### 4. Mapping contract and discovery

**Confirmed keys:**

| Key / mode | Target |
| --- | --- |
| Space | Leader, established before plugins |
| `jj`, `jk`, `kj` / insert | Escape |
| `H`, `L` / normal | First nonblank / end of line |
| `H`, `L` / visual | First nonblank / last nonblank |
| `n`, `N` | Native search movement, centered |
| `<C-h/j/k/l>` / normal | Split navigation |
| `<`, `>` / visual | Indent and reselect |
| `<leader>y` / normal, visual | Explicit system clipboard yank, including operator motions |
| `<leader>p` / normal, visual | System clipboard paste; replacement must not clobber its source |
| `<leader>P` / normal, visual | Paste register `0`, including after delete/change; preserve source on replacement |
| `<leader>e` / normal; `e` / dashboard | Tree toggle/open; consistent tree mnemonic |
| `<leader>lg` | Toggle the dedicated LazyGit float |
| Insert `<C-n>/<C-p>` | Select completion; no auto-insertion |
| Insert `<C-y>` | Accept deliberately selected completion; no implicit first-item acceptance |
| Insert Enter | Newline, never completion acceptance; autopairs may indent between pairs |
| `gz` family | Add/change/delete surrounds; retain familiar vocabulary |
| `af/if`, `ac/ic`, `aa/ia` / visual, operator | Function/class/parameter selection where queries exist |

Ordinary registers are independent of the system clipboard: empty `clipboard` option and native `d/c/x/y/p`. No black-hole remaps or leader cut aliases. Test counts, explicit registers, visual replacement, dot-repeat, and operator pending clipboard yanks.

**Proposed defaults to review with the roadmap:** retain `<leader>'` for normal files, `<leader>;` recent files, `<leader>/` current-buffer search, `<leader>fb` buffers, `<leader>fg/fG/fA` normal/hidden/all grep, and `<leader>ff` explicit formatting. Add `<leader>fh/fa` hidden/all filename search. Dashboard `f/F/a` selects normal/hidden/all files; `/` opens normal grep with accessible visibility/scope controls. Expose every visibility × directory/project combination through described commands and picker controls, avoiding a dozen obscure shortcuts. `<leader>fp` opens project-root file search (retiring the old paragraph-format mapping); retain native `gq/gw` for prose. Keep native diagnostic/LSP key families where possible rather than blocking `gr*` with a short `gr` mapping.

Use current supported Leap `<Plug>` bindings: proposed `s` jump in current window and normal `S` cross-window jump. These intentionally take over native `s/S` substitutes; standard `d/c/x` are preserved. Do not import remote/treeselect/automatic-paste examples or override native `an/in` selection. Structural jump keys, surround v4 targets, wrap/render/format toggles, and terminal exit/navigation keys are explicitly enumerated and audited in their child changes. Special UI buffers own their local keys; descriptions document intentional exceptions.

Finite `timeoutlen` is required; Which-key's display delay is separate. Audit prefix ambiguity and mapping owners after startup, language attachment, and opening each UI—not only the initial global map table.

### 5. Startup, navigation, and project search

Retain Hyper header, global recent-file list (up to 20), recent-files/search/config shortcuts, and disabled package/project sections. Move tree shortcut `y` to `e`. Preserve file/stdin/commit-message/multi-file launches without dashboard takeover; directory invocation sets its scope then shows dashboard with tree hidden. Ensure reopening the tree works even while dashboard is active. Never eagerly require the tree/picker just to register a dashboard action.

Use nvim-tree for the established sidebar workflow rather than Oil's editable-directory-buffer model or a richer overlapping explorer. Include help, current-file reveal, sensible focus return, Git indicators, file operations, and predictable behavior after external LazyGit changes. Do not import private tree-width APIs or bufferline offset glue.

Telescope remains the picker because it directly supports current file/content/recent/buffer workflows and useful interaction choices. Retain `<C-j>/<C-k>` selection and `;` confirmation if compatible, with standard Enter also available. Quickfix handoff replaces unused Trouble integration. Each prompt shows visibility and scope:
- **Normal:** ignore-aware, hidden excluded.
- **Hidden:** ignore-aware, hidden included.
- **All:** hidden and ignored included, `.git` contents excluded.

Use argument arrays, not shell-built command strings. Do not follow symlinks indiscriminately. Resolve project scope per selected buffer/directory with bounded ancestor lookup and Git worktree support; widening search does not silently change cwd. No-project fallback stays at directory scope and is visible. Test nested directories, hidden/ignored fixtures, paths containing spaces, `.git` exclusion, and project-root combinations for both files and contents.

### 6. Language tools and project formatting

Mason owns editor tools and prepends its `bin` directory; no arbitrary Homebrew/npm/Python tool copy can silently replace that choice. Document minimum Node/Python runtime requirements separately. Record exact installed editor-tool versions in a repo-managed provisioning manifest/evidence and provide explicit install/update commands; the lazy lockfile does not lock tools. Discover Python project virtual environments independently of the language-server runtime.

Initial language choices:
- Bash: BashLS plus ShellCheck diagnostics; Conform/shfmt owns formatting, not both Conform and BashLS.
- Zsh: correctly detect dotfiles/scripts, use native Zsh syntax and buffer/path completion. No BashLS attachment, shellcheck invocation, or automatic shfmt. This is the explicitly agreed simple baseline.
- JS/TS (including JSX/TSX): native client with current compatible TypeScript server definitions; prefer Mason server transport and the project's TypeScript version. Validate current server/compiler compatibility rather than following old setup examples.
- Lua: LuaLS with Neovim runtime awareness, modest project library scope, StyLua formatting. No whole-plugin-directory scan; add lazydev only if concretely needed for acceptable config editing.
- Python: Pyright for typing/navigation and Ruff for project-configured linting/formatting; avoid duplicated hover/diagnostic ownership. Honor project-selected alternatives such as Black when declared.

JS/TS uses the project's Biome or ESLint configuration/versions where declared. A Mason-managed ESLint transport can load the project's ESLint library. Biome's actual binary must match project requirements; do not silently run Mason Biome instead of a missing project dependency. Activate lint integrations only in configured projects. If both tools are deliberately configured, honor each role rather than disabling one by repository-wide guesswork.

Conform provides the single explicit format/save pipeline. Priorities are: explicit project policy and relevant workspace/package config → project-local matching tool → Mason default only when no project requirement exists. Default proposals: StyLua for Lua, Ruff format for Python, shfmt for Bash, Prettier for standalone JS/TS and manually requested Markdown. Default tools respect config and EditorConfig. Nearest-package/monorepo resolution and missing/ambiguous policy diagnostics are tested.

Formatting runs before the user's save with a bounded timeout and per-buffer/global opt-out. Text/logs, Markdown, Zsh, C#, and Rust have no initial automatic formatting. On formatter failure/missing dependency, preserve edits, report the reason, and permit saving without substituting a different tool. Do not use ESLint `--fix`, `biome check --write`, organize-import actions, Ruff fix-all, or generic multi-client LSP fallback on save. Biome formatting must use format-only behavior. ESLint-only projects with no separate formatter remain unformatted on save unless their policy exposes a format-only operation; fixes remain a manual command/code action.

### 7. Reading, structural editing, and appearance

Use current nvim-treesitter `main` because the legacy branch is frozen and does not support the selected Neovim baseline. Start highlighting with native APIs; install focused parsers during setup/update only: Lua, Bash, JS, TS, TSX, Python, C#, Rust, Markdown and inline Markdown, with only necessary support parsers. Zsh uses its native syntax fallback instead of pretending the Bash grammar understands every construct. Missing queries/parsers degrade gracefully and are reported by health checks. No experimental blanket Tree-sitter indentation.

Structural objects are query-dependent: preserve function/class/argument intent, use sensible linewise function/class selection instead of copying the old accidental blockwise class choice, and support native motions when queries are absent. Rainbow delimiters share the parser pipeline. Surround v4 uses disabled defaults and explicit `<Plug>` mappings. Typed automatic pairs load on insert; completion-generated brackets have one owner to prevent duplicates.

Render-markdown replaces the archived Glow wrapper, not the maintained external CLI itself. Render only Markdown, reveal raw syntax for editing, offer explicit toggle, preserve real contents, and use large-file exclusions. Keep US-English spell support and the personal dictionary; implement Markdown link actions locally only where justified by existing behavior.

Terminal palette evidence from `~/.config/ghostty/config` and cmux bundled themes:
- Dark: background `#282828`, foreground `#d4be98`.
- Light: background `#fbf1c7`, foreground `#654735`.
- The current medium/material theme matches principal accent colors in both variants.

Do not hard-code `background=dark`. Neovim 0.12.5 queries OSC 11 and handles mode-2031 theme updates; a background change reloads an accommodating theme. Validate actual installed cmux/Ghostty startup and live changes, including theme-derived picker/tree/statusline/render highlights. Use a manual fallback on terminals that cannot report appearance. Avoid a polling/OS-specific plugin unless native integration demonstrably fails and the revised design is reviewed. No runtime dependency on another machine's Ghostty config paths.

### 8. Incremental roadmap and capability ownership

Only the umbrella exists initially. Proposed child names below are created one at a time after approval; each introduces/updates the named main capabilities and carries its own detailed tasks. Maintain an execution ledger with child name, archive path, commit, checks, and blockers.

| Phase / proposed change | Depends on | Capability deltas | Delivery checkpoint |
| --- | --- | --- | --- |
| 1. `rebuild-terminal-foundation` | Roadmap approval | `terminal-core`, `plugin-lifecycle` | Capture baseline, isolate data/state/cache, replace loader/core, add lazy/theme, implement register/save/reload/wrap policy, install/lock minimal dependencies; syntax/core/headless checks |
| 2. `rebuild-navigation-dashboard` | 1 | `workspace-navigation` | Hyper startup router, three-mode/two-scope Telescope, polished nvim-tree, Which-key, restrained statusline; startup/search/tree fixtures |
| 3. `rebuild-reading-editing` | 1, 2 | `reading-editing` | Focused parsers/current textobjects, surround/autopairs/Leap/rainbow, Markdown rendering/spell/link behavior, large-file exclusions; first-use/operator/filetype checks |
| 4. `rebuild-language-tooling` | 1, 3 | `language-tooling` | Mason manifest/setup, Bash/JS/TS/Lua/Python native LSP and Blink, quiet diagnostics, Zsh fallback; server attachment/navigation/completion/environment checks |
| 5. `rebuild-project-formatting` | 4 | `project-formatting` | Conform project policy, Biome/ESLint integrations, format-on-save/manual fixes, opt-out/failure handling; project/missing-tool/monorepo fixtures |
| 6. `rebuild-git-terminals` | 1, 2 | `git-terminal-workflows` | Toggleterm shell layouts and LazyGit, Gitsigns hunk actions/reload; scratch Git repo, terminal focus/exit tests |
| 7. `verify-portable-setup` | 2-6 | Relevant setup/health requirements in owned capabilities | Fresh install/lock restore, startup matrix, health/setup docs, path/shell/clipboard review for Windows/WSL, live appearance checks; no untested-platform claims |
| 8. `optimize-terminal-performance` | 7 | Performance budgets in relevant owned capabilities | Profile repeated startup + first use + large files; tune loading without losing first operation; full final acceptance and evidence |

Follow the dependency order above for readability, even where increments could run independently. The initial approved scope is sufficient authorization for its bounded child loop; no repeated user approval per child is required. If workflow skill boundaries require presenting new child artifacts before apply, honor that boundary and continue execution in a subsequent authorized step rather than bypassing it. Any material change to the agreed behavior/dependencies returns for review.

### 9. Validation and performance strategy

Use a temp validation environment with separate config/data/state/cache and explicit runtimepath, preventing the old installed `pack/*/start` plugins from contaminating tests. A worktree alone does not isolate Neovim dependencies. Keep fixtures/check scripts portable Lua where possible, with macOS launch instructions and forward-looking Windows/WSL equivalents.

Validation layers:
1. Compile all changed Lua; validate every OpenSpec change strictly; run headless startup with timeout and captured messages/errors.
2. Assert observable core behavior, maps, register semantics, filetype-local cleanup, reload protection, and formatting selection using focused fixtures.
3. Exercise real selected plugins after installation: first action, operator counts/dot-repeat, parser/textobjects, Markdown renderer, search/tree, completion, Git/terminal flows, and relevant health checks.
4. Exercise real language-server handshakes and semantic operations with tiny projects; separate formatter policy tests from executable format/lint checks. Do not equate mocked executable lookup with a working tool.
5. Attached-TUI/manual checks for dashboard focus/layout, labels/icons, terminal key delivery, clipboard, and appearance changes that headless runs cannot establish. Use a PTY/attached UI where available; record user-assisted checks when needed.

Initial performance review targets (not falsely measured outcomes): warmed median startup to useful redraw within 100 ms for text/code file launches and 150 ms for empty/directory dashboard on this Mac, excluding initial provisioning and asynchronous server readiness. Establish baseline/variance in phase 1; make hard budgets in the performance child from evidence, and seek review if targets need relaxation. Include process/headless startup and attached-TUI readiness separately; a `VimEnter` timestamp is not proof the dashboard rendered.

Run at least 10 warmed samples per startup scenario; label a first-run empty-cache measurement separately from true OS cold-cache behavior. Record Neovim version, machine/architecture, plugin lock, tool versions, invocation, median and p95. Compare minimal and original startup where runnable; report original errors rather than treating its failed startup as a timing baseline. Measure first picker/tree/insert completion/terminal use to avoid hiding work behind lazy loading. Large-file fixtures include a sizable multi-line log and a long/minified line; disable expensive parsing, semantic tooling, renderer and decoration appropriately without breaking read/search/reload. Keep network/update checks out of ordinary startup.

## Risks / Trade-offs

- [Latest plugins can require incompatible APIs] → Recheck releases, lock tested versions, test first-use paths, and document current-commit exceptions for Treesitter/Leap and untagged projects.
- [Mason does not isolate all runtimes or lock tools with lazy] → Versioned tool manifest and explicit provisioning, documented Node/Python prerequisites, project interpreter detection, no routine auto-installs.
- [ESLint/Biome project rules can overlap] → Separate formatting from fixes, discover policy per package, keep save format-only, test both/neither/missing cases.
- [A slim setup still contains several focused plugins] → Judge by actual capability and measured loading; retain requested aids, omit unused subsystems, no redundant engines.
- [Zsh fallback has less semantic support] → Explicitly document limitation; no misapplied Bash tools or Shuck investigation.
- [Native theme notifications vary by installed terminal/multiplexer] → Test cmux/Ghostty live changes; portable manual fallback and truthful compatibility notes.
- [Mapping/default migrations change muscle memory] → Preserve agreed keys, publish explicit tree/clipboard/dashboard changes, audit UI-local exceptions and native `gr*` prefixes.
- [Heavy file work or lazy key replay can introduce latency/correctness bugs] → Shared large-file guard, upstream loading contracts, first-keystroke/operator tests, first-use profiling.
- [Windows parser/clipboard/shell paths differ] → Standard paths and argument arrays, separate per-platform setup, no transferred parser binaries, macOS-only test claims.

## Migration Plan

1. Present and iterate on these artifacts; do not alter runtime configuration before explicit approval.
2. After approval, record authorization in the umbrella ledger and commit the accepted planning artifacts on the rebuild branch. Keep the reference worktree available.
3. For each child: use CLI instructions to author artifacts, validate, apply using the applicable workflow, execute required checks, complete tasks, archive/sync its deltas, inspect status/diff/recent history, and commit only intended files. Update the umbrella ledger/tasks after verified completion.
4. Provision/test in isolation before normal use. Remove legacy files deliberately through foundation tasks; preserve agent/OpenSpec tooling and user data. Never clean shared plugin installations blindly.
5. Finalize only after fresh-install, behavioral, appearance, and performance evidence is recorded. Archive the umbrella only when all increments are complete; leave blockers explicit otherwise.
6. Rollback uses the original branch/reference commit or reverts an identified increment, followed by documented plugin/tool restore. Do not reset shared user state or delete the reference worktree until the user no longer needs it.

## Open Questions

No blocking workflow decisions remain. Child planning resolves current exact plugin/tool revisions, formatter detection fixtures, UI dimensions, timeout values, and measured performance thresholds within the approved behavior. Actual project-specific policy that cannot be inferred must use an explicit documented override, not a guessed formatter or automatic lint fixes.

### Research references

Checked on 2026-10-04; implementation rechecks versioned documentation where relevant.

- [Packer unmaintained notice](https://github.com/wbthomason/packer.nvim), [lazy.nvim](https://github.com/folke/lazy.nvim), [versioned native package docs](https://github.com/neovim/neovim/blob/v0.12.5/runtime/doc/pack.txt).
- [Current Treesitter API/loading requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md), [textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/README.md).
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua), [Telescope](https://github.com/nvim-telescope/telescope.nvim), [dashboard](https://github.com/nvimdev/dashboard-nvim), [Which-key](https://github.com/folke/which-key.nvim).
- [Blink stable installation](https://cmp.saghen.dev/installation.html), [keymaps](https://cmp.saghen.dev/configuration/keymap.html), [native snippets](https://cmp.saghen.dev/configuration/snippets.html), [nvim-lspconfig migration](https://github.com/neovim/nvim-lspconfig).
- [Mason](https://github.com/mason-org/mason.nvim), [Conform recipes](https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md), [ESLint definition](https://github.com/neovim/nvim-lspconfig/blob/v2.12.0/lsp/eslint.lua), [Biome definition](https://github.com/neovim/nvim-lspconfig/blob/v2.12.0/lsp/biome.lua).
- [Native appearance detection](https://github.com/neovim/neovim/blob/v0.12.5/runtime/lua/vim/_core/defaults.lua), [theme-update handling](https://github.com/neovim/neovim/blob/v0.12.5/src/nvim/tui/input.c), [Ghostty theme configuration](https://ghostty.org/docs/config/reference#theme), [Material palette](https://github.com/sainnhe/gruvbox-material/blob/master/autoload/gruvbox_material.vim).
- [Render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim), [Glow wrapper archive notice](https://github.com/ellisonleao/glow.nvim), [Surround v4 docs](https://github.com/kylechui/nvim-surround/blob/v4.0.5/doc/nvim-surround.txt), [Leap current upstream/loading guidance](https://codeberg.org/andyg/leap.nvim).
- [BashLS](https://github.com/bash-lsp/bash-language-server), [current shfmt Zsh dialect](https://github.com/mvdan/sh/blob/v3.14.1/cmd/shfmt/shfmt.1.scd). Zsh formatter/LSP expansion is deliberately deferred.
