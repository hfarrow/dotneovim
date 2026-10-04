# Performance and final acceptance

## Protocol

Use the test-only Python Msgpack venv and provisioned isolated XDG base described
in [setup](setup.md). Run sequentially while other tests/installers are idle:

```sh
DOTNEOVIM_TEST_HOME="$BASE" /path/to/ui-venv/bin/python -B tests/performance.py \
  --samples 20 --first-use --enforce-budgets --output "$BASE/performance.json"
DOTNEOVIM_TEST_HOME="$BASE" /path/to/ui-venv/bin/python -B tests/large_input.py
DOTNEOVIM_TEST_HOME="$BASE" nvim -l tests/run.lua routine
```

The harness timestamps immediately before spawning `nvim --embed -i NONE`, attaches
a real 160×50 linegrid, reconstructs content/scroll events, and records a flushed
grid containing the fixture or Hyper header/actions. This external wall-clock
fixture predicate includes the filename in the native/plugin statusline; it does
not wait for the deferred lualine mode decoration to define readability. An
experimental lualine-required run was kept separate and rejected as a different
readiness definition, not used to claim compliance.
useful-redraw metric includes process launch and UI transport; it is not a Metal
scanout timestamp. Actual cmux screenshots/native appearance are verified separately.
An early `--cmd` hrtime→VimEnter marker is reported independently, as is complete
process lifetime through quit. First-use measures separate fresh processes and
actual input; readiness means tree entries, picker results, automatic unselected
completion menu, or an exact output line from a real `/bin/sh` PTY command.

Each scenario has one uncounted warmup plus the published samples. Empty-cache
measurements use a new editor XDG cache with installed dependencies retained;
they are **not OS-cold-cache** results. Minimal NONE uses the identical UI transport
and file fixtures; its dashboard columns mean native empty editor, since it has
no dashboard plugin. p95 is nearest rank; targets are median ≤100 ms for file
launches and ≤150 ms for dashboard variants on this Mac. No p95 target is invented.

Original comparison: pass `--reference /path/to/dotneovim-v2-reference-20261004`.
Original Packer data is read only, state/cache isolated. On current Neovim the
original attached dashboard does not render and file launches leave E116
`dictwatcherdel` errors; these are failed acceptance, not valid speed baselines.
Phase 1 recorded one original **320.738 ms process lifetime** and ten minimal
**14.9–19.1 ms** lifetimes before replacement; they are historical, different-metric
evidence, not the final attached-redraw comparison.

## Loading and large-input policy

Theme, upstream Tree-sitter setup, Leap registration and Mason paths remain early.
Native language definitions load for semantic filetypes only. Blink loads on first
InsertEnter or as a semantic dependency; capabilities are prepared before clients.
The provisioned locked-commit matcher is selected synchronously, and first buffer
maps installed immediately, preventing lost first typed text/Ctrl-y. Routine startup
does not run Blink Git discovery/download processes; explicit installer still
verifies downloaded checksums. ToolHealth/diagnostic keys remain available globally.

Unchanged guard decisions are cached by changedtick. Files over **1 MiB**, **50,000
lines**, or a line over **10,000 bytes** exclude Tree-sitter, renderer, rainbow,
semantic clients, completion and typed pairs. Native syntax is disabled on guarded
buffers even if a later ftplugin tries to restore it. Positive decisions remain
conservative for the buffer lifetime; reopen a reduced file to regain heavy aids.
Rainbow excludes prose/help grammars; code-language delimiter coloring remains.

## Profiling recipes

```sh
nvim --startuptime /tmp/nvim-startup.log README.md
```

Use `:Lazy profile` to inspect plugin load ownership and `:lua print(vim.inspect(require('lazy').stats()))`
for loaded counts. `--startuptime` is useful attribution, not proof of useful
dashboard readiness. Core SetupHealth and exact lock/tool manifests are separate
from performance; normal startup never runs provisioning or health scans.

## Final Mac results (2026-10-04)

Apple M2 Max arm64, macOS 26.6.2 (25G83), Neovim 0.12.5 Release/LuaJIT;
Node 24.15.0, Python 3.13.12, tree-sitter CLI 0.27.0 and local clang.
Tested phase 8 working-tree runtime based on 759f95d; exact implementation is
the archived performance commit. Plugin lock SHA-256:
`b4ccd8aaf661b88a7dadd263534a5ec67887d4f7baf7e823762d4bc91e3b7fa5`.
22 plugins/13 focused parsers/10 tool manifest entries remain unchanged.
20 measured warmed samples per scenario/action; timings in milliseconds.

| Scenario | Useful redraw median / p95 | VimEnter median | Lifetime median | Budget |
| --- | ---: | ---: | ---: | ---: |
| Empty | 69.52 / 72.21 | 25.86 | 73.38 | 150 |
| Directory | 76.64 / 80.08 | 25.69 | 80.52 | 150 |
| Explicit dashboard | 75.76 / 78.11 | 31.56 | 79.67 | 150 |
| Text | 67.33 / 70.50 | 49.13 | 88.47 | 100 |
| Lua code | 82.77 / 84.51 | 64.86 | 109.48 | 100 |
| Markdown | 88.35 / 94.38 | 63.60 | 119.54 | 100 |

All approved median budgets passed with `--enforce-budgets`; no relaxation.
Empty-editor-cache useful redraw (one sample each): empty **96.49**, directory
**106.85**, explicit dashboard **104.54**, text **89.24**, code **120.27**,
Markdown **115.79**. Minimal NONE redraw medians **17.11–17.66** with p95
**18.01–20.11**; those measure basic editor, not equivalent capabilities.

| First operation (20 fresh processes each) | Median / p95 |
| --- | ---: |
| Tree entries | 34.25 / 37.26 |
| Picker with actual file results | 90.99 / 94.37 |
| Automatic unselected completion menu | 26.27 / 27.27 |
| Shell PTY exact output | 43.85 / 45.38 |

Delivered-runtime baseline (10 samples): empty **85.98**, directory **93.01**,
explicit dashboard **92.79**, text **82.04**, code **76.05**, Markdown **106.63**
median redraw. Markdown missed 100 ms and triggered tuning. Code increased
~6.7 ms after semantic-filetype lazy replay while remaining within budget;
this tradeoff is disclosed, not presented as an across-the-board speedup.
First completion moved from **17.13** to **26.27** ms after deferred loading,
while no-first-input-loss/acceptance tests still pass.

Large-input final sequential operations (one correctness/timing fixture each):

| Input | Bytes / lines | First UI | Motion | Search | External reload |
| --- | ---: | ---: | ---: | ---: | ---: |
| Log | 10,400,012 / 400,001 | 146.20 | 19.80 | 39.42 | 200.54 |
| Many short Lua lines | 480,012 / 120,001 | 101.21 | 39.61 | 10.81 | 28.21 |
| Minified JS | 250,028 / 2 | 119.01 | 9.90 | 9.30 | 10.81 |

These are excluded-input interaction checks, not warmed-file budget samples.
No parsing/native syntax/semantic clients/completion/pairing/rainbow attached;
motion/search/reload correct, guard cache invalidation verified. A concurrent
integration pass showed a **737.6 ms** many-line motion tail while host/UI tests
were running; final table is the sequential run, not a claim of zero contention.

Final acceptance passed all Lua suites (`core navigation reading language
formatting git lifecycle offline setup routine`), attached startup/Leap/completion/
snippets/Zsh/shell/LazyGit workflows in Rust and Lua matcher modes, actual Mac
clipboard with complete snapshot restoration, native dark/light startup and
live changes plus visually inspected real screenshots, normal default health,
unchanged lock/spell/IdeaVim and strict OpenSpec validation. Windows/WSL remain
reviewed only. Raw startup/action data and final evidence live in
`openspec/changes/archive/2026-10-04-optimize-terminal-performance/`.
