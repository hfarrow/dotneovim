# Design

## Context

Navigation owns Telescope lazy keys in `lua/plugins/navigation.lua`; search callbacks call the shared `config.search.open` with kind/visibility, which supplies directory scope. Existing `workspace-navigation` specs already contract visibility and scope. Runtime/source audit found free quote pairs, an intentional fg reassignment, and distinct ff/fb/fp actions.

## Goals / Non-Goals

Goals: memorize one mode key and its Shift counterpart; verify actual input/lazy replay and key ownership.
Non-goals: new plugins, search algorithm/root-policy changes, a new dashboard layout, or extra aliases.

## Decisions

- Change only the six declared normal-mode key callbacks. Normal files/content use `f'` / `f"`; hidden uses `fg/fG`; all uses `fa/fA`. Remove old quote-only/fh declarations rather than keep multiple vocabularies.
- Keep dashboard one-key launch actions (f/F/a and /), but label them Files normal/hidden/all and Content normal. These local launch keys don't imply a different global search contract. Global leader-f pairs remain available on the dashboard.
- Describe every pair uniformly as `Find files (normal|hidden|all, ignored)` or `Search content (...)`; retain Which-key group and other actions.
- Add a focused attached-UI fixture using existing RPC client. Run each key in its own fresh file launch to verify first lazy dispatch, then all keys in a loaded instance; inspect actual picker title, type, directory, no errors, and audit source spec/lazy registries/global/local maps including prefix overlaps. Test existing dashboard actions and global pairs on dashboard too.
- Existing real navigation visibility/root/operation suite establishes unchanged behavior; run it and core checks once. No full language/performance re-run or new dependency provisioning is warranted.

## Risks / Trade-offs

- [Shift-quote depends on keyboard layout] → Store literal quote keys, test actual RPC input with both, document US-layout Shift relationship rather than assume all layouts.
- [Reusing fg surprises habitual normal-grep users] → Explicit migration table; old fg now hidden filenames, normal grep is f-double-quote.
- [Only startup maps look correct while lazy replay fails] → Cold/warm real input fixture and post-load ownership audit.

## Migration Plan

User explicitly approved this exact layout and full automatic workflow. Present brief progress; apply, verify, sync the added requirement into the existing Purpose/Requirements spec, archive, then commit. Restart existing Neovim instances to pick up the new keys; lazy doesn't support re-sourcing setup.
