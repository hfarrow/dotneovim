# Validation evidence

Environment: macOS arm64, Neovim 0.12.5 Release/LuaJIT, 2026-10-04.

## Baseline before replacement

Measured full subprocess lifetime with `vim.system(...):wait()`, not first redraw.
- Minimal command: `nvim --headless -u NONE -i NONE +qa`.
- Ten warm process samples (ms): 19.107, 15.735, 15.356, 14.880, 15.066, 15.420, 14.957, 15.784, 15.530, 15.897.
- Reference command: `nvim --headless --cmd 'set rtp^=<reference>' -u <reference>/init.lua -i NONE +qa`, using installed legacy plugins. One sample: 320.738 ms, exit 0, startup print and `vim.tbl_flatten` deprecation warning. Not an isolated/fully functional original capability test or a multi-sample performance comparison.
- No runtime files had been replaced when these samples were taken.

## Foundation checks

- Explicit install and repeat locked restore passed in isolated XDG config/data/state/cache under `dotneovim-validation`; manager/theme revisions match the lockfile.
- `tests/core.lua` passed both provisioned and missing-manager environments: native/named/count deletes, clipboard operator/visual paste, last-yank preservation, no focus autosave, protected external reload/view, wrap transitions, undo file, cursor restoration, Lua compilation, both theme palettes.
- `tests/lifecycle.lua` passed with a deliberately installed unmanaged `pack/legacy/start/sentinel` plugin: sentinel remained on disk and did not load; plugin HEADs match lock; no dependency tasks scheduled.
- `tests/offline.lua` passed with unreachable HTTP/HTTPS/ALL proxy values and no install/update tasks. This validates no startup network work, not a system-level network sandbox.
- README bootstrap command exercised as written; bounded harness `DOTNEOVIM_TEST_HOME=<isolated base> nvim -l tests/run.lua <core|lifecycle|offline>` passed.
- `git diff --check` and strict OpenSpec validation passed. Personal `spell/` files have no diff.
- Installer initially exposed script mode disabling plugin loading; fixed by explicitly enabling it. A reload-protection fixture initially prompted on an intentional external conflict; fixed the test to force its deliberate test write. Neither remains a blocker.
- Real OS clipboard, live terminal appearance, and Windows/WSL runtime checks belong to subsequent integration acceptance; no claim they passed here.
