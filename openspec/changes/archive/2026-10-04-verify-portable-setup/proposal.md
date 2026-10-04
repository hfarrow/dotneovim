# Proposal

## Why

Phases 1–6 supply the runtime, but delivery still needs a clean-machine install, consolidated health/setup guidance and executable Mac integration acceptance. Phase 7 of the approved umbrella makes those checks reproducible and distinguishes platform review from runtime evidence.

## What Changes

- Verify plugins at the lock, rebuilt parsers and exact managed tools in a new isolated environment, including deliberate locked restore and offline startup.
- Consolidate setup and health reporting across plugins, parsers, tools, external prerequisites and clipboard; repair platform executable/interpreter path handling found by review.
- Exercise the complete startup matrix and attached presentation; test the real Mac clipboard with full save/restore.
- Verify native startup and live appearance in the installed cmux/Ghostty host using a test surface and the subsequently authorized temporary system appearance switch with restoration. Unavailable real-host acceptance is a blocker, never a simulated pass.
- Document Windows/WSL paths, shells and prerequisites as reviewed but runtime-untested. Provision normal Mac data only after isolated acceptance and verified config destination, retaining legacy packages.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `plugin-lifecycle`: consolidated executable health and platform setup; fresh locked provisioning acceptance.
- `terminal-core`: automatic native host startup/live appearance and real clipboard acceptance.
- `language-tooling`: correct platform-specific managed executable and project interpreter resolution.

## Impact

Targets `lua/config/tools.lua`, `lsp.lua`, project tool lookup, new health module, tests and consolidated setup documentation. Uses existing dependencies and explicit provisioning scripts. No terminal configuration file or persistent OS appearance changes. Parent: `plan-terminal-neovim-rebuild`; phases 1–6 are prerequisites, phase 8 follows this acceptance gate.
