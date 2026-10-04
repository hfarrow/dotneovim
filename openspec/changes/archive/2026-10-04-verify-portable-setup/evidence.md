# Phase 7 evidence — acceptance complete

Date: 2026-10-04. Branch `rebuild/neovim-modernization`, starting revision
`c42979f`; runtime changes below are uncommitted. macOS 26.6.2 (25G83), arm64,
Apple M2 Max; Neovim 0.12.5 Release/LuaJIT, Node 24.15.0, Python 3.13.12,
tree-sitter CLI 0.27.0. No Windows or WSL runtime was exercised.

## Completed executable checks

Fresh isolated base (not copied from earlier plugin/tool data):
`/var/folders/fw/js0vb6j54xb6z48sywnb_vj40000gr/T/opencode/dotneovim-fresh-phase7`.
Four XDG roots point to config/data/state/cache there. The three explicit scripts
installed 22 locked plugins, 13 focused parsers with platform compilation and
compatible highlight queries, and all 10 exact Mason manifest receipts. Blink's
native library loads with the locked-commit receipt; attached UI confirms Rust
matcher initialization. Test-only Msgpack 1.2.3 remains in the earlier validation
`ui-venv`; exact Prettier/Biome/ESLint fixture was separately npm-provisioned into
the new base by `DOTNEOVIM_TEST_HOME=$BASE nvim -l scripts/format-fixtures.lua`.

Locked restore: Gruvbox HEAD intentionally displaced to
`afb275d8e6dc379762d122bd24e1773fc057abf3`; corrected installer restored
`11d779b26a9ab2b3db8c22c6ac9fb6e8ed4fea79`. Installer asserts every actual plugin
HEAD matches the input lock. `git diff --exit-code -- lazy-lock.json` passed.

Passed against the fresh environment:

- `tests/run.lua setup`: all revision/parser/receipt/executable/provider health,
  native SetupHealth buffer; deliberately missing managed paths and incorrect
  plugin-revision report; reviewed Windows suffix/layout decisions; actual Mac
  venv creation and execution in a path with spaces.
- `core`: register/mapping/save/reload/wrap/state/theme checks and all Lua modules
  compiled by `loadfile`. Repeated after the Markdown first-start fix.
- `navigation`: real ripgrep/Telescope visibility and scope matrices, Git/worktree
  roots/cwd, quickfix, first tree create/rename/copy/move/delete/focus.
- `reading`: actual focused parsers/queries/textobjects/motions, surround
  first/count/dot/visual, pairs, renderer/raw/spell/filetype cleanup, large guards
  and missing-parser fallback. Repeated after Markdown loading change.
- `language`: exact receipts/managed PATH, real Bash/TS/Lua/Pyright/Ruff
  initialization/definitions, ShellCheck, quiet diagnostics and exclusions.
- `formatting`: real local Prettier/Biome/ESLint, monorepo/policy/version/ambiguity,
  save format-only, manual lint fixes, defaults/exclusions/manual Markdown,
  opt-outs and timeout/failure preservation.
- `git`: actual Gitsigns hunks/navigation/preview/stage/index/reset and roots.
- `lifecycle`: all locked plugin HEADs; retained legacy sentinel not sourced;
  no plugin install/update tasks on startup. Harness now creates its own isolated
  sentinel, making the command reproducible.
- `offline`: unreachable HTTP/HTTPS/ALL proxies with provisioning/checking
  disabled and no dependency tasks. This is proxy-isolated acceptance, not an
  OS firewall claim.
- `tests/ui.py`: real attached grid/input, empty/directory/text/multiple/commit/
  code/Markdown startup; real stdin; dashboard/tree/picker controls, Leap,
  automatic no-preselect completion/Ctrl-y/Enter/native snippets/Zsh path,
  actual shell PTYs/cwd/layout/focus/process reuse/exits and LazyGit lifecycle/
  reload/protection. Useful grids and empty `v:errmsg` verified.
- `tests/clipboard.py`: actual pbcopy/pbpaste operator/visual yanks, clipboard
  paste/replacement-source preservation and ordinary yank/delete isolation.
  Swift/AppKit helper saves every pasteboard item/type as Data in process memory;
  complete original snapshot restored and compared. A second run intentionally
  failed its pbpaste assertion after a real yank; finally cleanup and full
  restoration verification still passed.
- Strict validation of child and umbrella; `git diff --check`;
  unchanged `lazy-lock.json`, spell source and `.ideavimrc`.

## Defects found and repaired (not waived)

1. StyLua/shfmt incorrectly got Windows .cmd suffix. Native executable list now
   yields .exe; both venv names use platform layouts; Python tries python3 then
   python. Native Windows execution remains untested.
2. Fresh parser process cached missing highlight queries before provisioning;
   verification now clears the native query cache after builds. Initial parser
   script failed on Bash queries; corrected run passed all focused queries.
3. Blink 1.10.2 recognizes commit receipts before its downloads-disabled branch,
   but release-tag receipts only after it. Installer checks download/native load
   and writes the locked commit receipt; native matcher now initializes without
   warnings/downloads. Lua fallback must be explicit during provisioning.
4. Existing install-then-restore could rewrite the input lock from a drifted
   installed HEAD. The explicit restore process now loads the captured lock,
   disables lock writes in that process, installs with lockfile=true, restores
   and asserts all actual HEADs. Normal deliberate Lazy update retains upstream
   behavior. Automatic missing installation is disabled even during setup;
   the installer alone owns its explicit operations.
5. First attached Markdown startup hit native FileType replay/undo duplicate
   unmaps (`E31`). Renderer now preloads on Markdown BufReadPre/BufNewFile;
   FileType remains the fallback for subsequently assigned Markdown buffers.
   Actual first Markdown attached startup now has no errors and proper wrap/spell.

## Initial actual-host investigation (resolved by subsequent permission)

Installed cmux **0.64.25 (106), b685a275c**; its bundled helper is Ghostty
**1.3.2-HEAD +4a0e9e185**, app runtime `.none`. There is no standalone Ghostty.app
under /Applications. User's Ghostty config already has Material dark/light and
system window theme; it was read only, never edited. OS appearance was not changed.

Created only test workspace `workspace:14` (`dotneovim-phase7-host-check`),
surface:40, with `--focus false`. Its actual Ghostty PTY launched the new config
with the fresh XDG data and an isolated Neovim listen socket. No editor appearance
commands or fake terminal responses were used. Remote inspection observed
`background=light`, Normal.bg **#fbf1c7**, Normal.fg **#654735**, `v:errmsg=''`.
Actual host read-screen showed the complete Hyper header/action/recent layout
and statusline icon characters. This proves current native light startup/text
layout, not dark/live notification or rendered font glyph shapes.

Installed capabilities contain no per-surface appearance/color-scheme setter;
Ghostty list-actions likewise has no appearance action. Source at installed
revision shows appearance is app-global through AppearanceSettings and app
effectiveAppearance; preview override is DEBUG-only. The supplied cmux-source
directory is an incomplete .git stub, so reference was read from upstream at
`b685a275c` instead. `debug.window.screenshot` returns method_not_found in the
installed release. macOS System Events reports UI automation disabled. A global
cmux settings/theme modification would affect others' panes and violates the
task's constraints. Injected OSC/mode reports or :Appearance would not satisfy
actual-host acceptance.

**BLOCKED:** real dark startup, light→dark→light native live host reports, derived
theme highlight refresh and visual glyph/presentation inspection. Need a
user-operated isolated instance/profile that can switch its own appearance,
or a user-provided safe actual-host control. Accessibility/screen capture would
need user-enabled access if automation is wanted. Do not change OS theme or the
current cmux app settings to obtain a pass.

Cleanup: quit only test Neovim; closed workspace:14; current workspace remained
workspace:11. The test host socket/process was not retained. No user panes were
changed. Clipboard fully restored.

## Resumed actual-host acceptance and delivery

The user subsequently enabled Accessibility/Automation/screen capture and
authorized temporary appearance switching. `tests/appearance.py` exercised the
actual installed host: dark startup, live light→dark→light, fresh light startup,
exact Normal colors, and changes/restoration of TelescopeNormal, NvimTreeNormal,
lualine_a_normal and RenderMarkdownH1Bg. Captured actual OSC 11 host reports
included fbfb/f1f1/c7c7 and 2828/2828/2828; no editor appearance commands or fake
responses. CoreGraphics window screenshots were read and visually inspected:
Hyper header/shortcuts/recent icons, tree folder/file/Git symbols, picker borders/
results/preview and statusline glyphs are legible and aligned in both variants;
light and dark Markdown/tree backgrounds and contrast match the palette.

Images and structured results are in the fresh base (`appearance-*.png`,
`appearance-results.json`), reproducible with the documented consent-gated script.
Original dark=false, AppleInterfaceStyle absent and automatic-mode key absent
were restored and compared; cmux appearanceMode remained system. Selected
workspace:2 restored, only test workspace closed, no user pane contents edited.
Ghostty config SHA-256 unchanged. Restoration also ran on initial fixture errors.

Actual first tree opening revealed nvim-tree's suppressed FileExplorer cleanup
left E216 in v:errmsg because core already disables netrw. Disabled redundant
hijack_netrw cleanup; repeated real host acceptance and navigation/attached suites
passed. Normal provisioning revealed concurrent Blink setup/installer download
writers; setup now uses Lua only during provisioning and the explicit checked
download is serialized after restore. Normal installer rerun passed with Rust.

Normal `~/.config/nvim` resolves to this checkout. The three explicit installers
completed for normal `~/.local/share/nvim`; parsers built locally and all exact
tool receipts verified. Default `nvim --headless` startup checked all SetupHealth
items, correct checkout and empty v:errmsg. Normal state is
`~/.local/state/nvim`; shared legacy packages retained. Test dependencies remain
isolated, not installed into normal runtime. Strict all-spec/change validation
and diff/lock/spell/IdeaVim checks passed. Phase 7 is ready for sync/archive then
commit; phase 8 will independently measure performance.
