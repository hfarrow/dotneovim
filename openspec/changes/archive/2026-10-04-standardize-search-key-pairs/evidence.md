# Validation evidence

2026-10-04; macOS arm64, Neovim 0.12.5. User explicitly approved exact pairs and automatic apply/sync/archive/commit.

- Source audit: new quote keys unused, fg deliberately reassigned, ff/fb/fp distinct. Removed old leader-quote/fh declarations.
- `DOTNEOVIM_TEST_HOME=<dotneovim-fresh-phase7> <validation/ui-venv/bin/python> -B tests/search_keys.py` passed: each of six keys cold in a fresh file process, all six warm and on dashboard, actual Telescope kinds/titles/results, declaration counts plus normal global/buffer-local ownership/prefix audits after formatting/Which-key handlers loaded, ff/fb/fp retained, retired keys absent, dashboard labels and one-key actions exercised.
- The initial test tried decoding every raw special-key mapping through Msgpack UTF-8; corrected the fixture to inspect only relevant leader maps inside Lua and return safe fields. No runtime mapping defect was masked.
- `tests/run.lua navigation` passed real rg/Telescope inclusion/scope/root/worktree/cwd/quickfix/file-operation checks.
- `tests/run.lua core` passed and compiles all runtime Lua files. `git diff --check` and unchanged lazy lock passed.
- Keymap guide includes the paired layout, Shift relationship, visibility definitions and old-key migration. Dashboard labels explicitly identify filename/content and visibility without changing its launch actions.

Finalization uses canonical spec sync followed by archive, then commit. Existing editor instances must restart to load new lazy key registrations.
