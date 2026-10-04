# Final performance and acceptance evidence

2026-10-04, Apple M2 Max arm64/macOS 26.6.2 (25G83), Neovim 0.12.5 Release,
LuaJIT 2.1.1788856981; Node 24.15.0, Python 3.13.12, tree-sitter CLI 0.27.0.
Test-only Msgpack 1.2.3 in validation/ui-venv. Runtime measured from phase 8
working tree based on 759f95d; archived implementation commit supplies exact
revision. Lock SHA-256 b4ccd8aaf661b88a7dadd263534a5ec67887d4f7baf7e823762d4bc91e3b7fa5.
No plugin/tool revision changes. Exact manifest retained; native Rust matcher
and explicit Lua fallback both exercised.

## Measurements and tuning

See docs/performance.md and raw-data.md for protocol, 20 final samples per six
startup scenarios and four first actions, nearest-rank p95, independent VimEnter/
full lifetime, minimal baseline and separately labeled empty-editor-cache samples.
Raw full JSON also remains in fresh validation base performance-final.json;
baseline JSON and --startuptime Markdown profile retained there for attribution.

Delivered runtime ten-sample median/p95 redraw baseline (ms): empty 85.98/88.32,
directory 93.01/98.35, dashboard 92.79/96.42, text 82.04/84.94,
code 76.05/80.88, Markdown 106.63/112.27. Markdown failed initial 100-ms gate.
Original attached baseline attempted all scenarios against stable 9746670 and
legacy data, read-only reference; dashboards were native empty-editor instead of
the original dashboard and file invocations retained E116 dictwatcherdel. No
valid original timing claimed. Phase 1's historical one 320.738-ms lifetime is
explicitly a different metric.

Profile showed eager Blink/LSP definitions on prose/empty and duplicate guard
scans; semantic definitions now filetype-triggered, Blink InsertEnter or semantic
dependency, receipt-selected matcher synchronous and current-buffer maps immediate.
An initial lazy Blink attempt missed first Ctrl-y maps and produced native Ctrl-y
text; fixed by applying the configured maps at setup, attached regression passed.
No routine Git matcher discovery/downloader processes. Theme/Mason/Tree-sitter/
Leap remain early; no dependency additions. Rainbow restricted to code grammars.

An experimental predicate requiring deferred lualine's NORMAL label yielded code
103 ms/Markdown 115 ms; eager lualine did not fix it and was reverted. That is
later decoration readiness, not initial usable native statusline. Final predicate
requires flushed content plus filename in native/plugin statusline and Hyper
actions for dashboards; cannot be satisfied by empty initial grids or VimEnter.
Published budgets refer to this original useful-reading contract, not lualine.

Final median/p95 redraw (ms): empty 69.52/72.21, directory 76.64/80.08,
dashboard 75.76/78.11, text 67.33/70.50, code 82.77/84.51,
Markdown 88.35/94.38. Hard 100/150-ms median assertions passed; no relaxation.
Code increased ~6.7 ms relative to baseline due to semantic lazy replay; disclosed.
First action median/p95: tree 34.25/37.26, picker 90.99/94.37,
completion 26.27/27.27, terminal exact shell output 43.85/45.38. Completion's
~9-ms transfer to first use disclosed, acceptance preserved.

Large-input actual attached tests passed: 10.4 MB/400001-line log, 480012-byte/
120001-line Lua and 250028-byte minified JS. Added line-count limit 50000;
cached unchanged negative guard checks by changedtick; stop native ftplugin
highlighters and Syntax replay after guard. Motion/search/reload in final
sequential run respectively 19.80/39.42/200.54, 39.61/10.81/28.21,
9.90/9.30/10.81 ms. Guard invalidation after edits passed. No parsing/native
syntax/rainbow/semantic clients/completion/pairs; real paste/input/search correct.
Concurrent run's 737.6-ms many-line motion disclosed as contention, not omitted.

## Final acceptance after runtime changes

- All bounded Lua suites passed: core, navigation, reading, language, formatting,
  git, lifecycle, offline, setup, routine. Actual managed server handshakes,
  format-only saves/local pinned tools/manual fixes, actual Git hunks, registers,
  reload preservation and UI-local mappings retained.
- All runtime Lua compiled by core; default normal headless startup and all
  on-demand health items passed. Explicit normal installer re-run with the
  optimized Blink setup passed. Normal ~/.config/nvim still this checkout,
  normal plugins/parsers/tools retained under ~/.local/share/nvim; old pack data
  left on disk and unloaded.
- tests/ui.py passed in native Rust and DOTNEOVIM_BLINK_LUA=1 modes: full startup
  matrix, first completion selection/accept/newline/snippets, Zsh, Leap, actual
  shell PTYs and LazyGit/focus/reload. tests/clipboard.py real pbcopy/pbpaste passed
  and all original pasteboard formats restored.
- tests/appearance.py passed again after tuning: actual installed cmux 0.64.25
  (b685a275c)/embedded Ghostty 1.3.2 +4a0e9e185 dark and light startup, native
  live light→dark→light reports and exact base/derived highlights. Actual window
  PNG screenshots re-read and visually inspected; dashboard/tree/picker/icon/
  rendered Markdown/statusline layout and contrast remain correct. Original
  dark=false, AppleInterfaceStyle absent, auto key absent restored; original
  workspace:2 restored, test workspace/process closed and Ghostty config unchanged.
- Routine actual process audit: zero vim.system calls at empty startup in its
  300-ms observation, install/checker/registry disabled; semantic server launches
  on code are intended, not downloads. Offline proxy fixture and lifecycle tasks
  confirm no update/install task. No claim of OS network firewall enforcement.
- git diff --check; unchanged lazy lock, spell and IdeaVim; strict all OpenSpec
  validation passed. Reference remains 9746670fb9dc3640969151947b110380aac178f4.
- Windows/WSL remain setup/path/shell/virtualenv reviewed, runtime untested.

No acceptance blocker remains. Sync and archive this child before implementation
commit, then finalize umbrella separately; no push or reference deletion.
