# Design

## Context

See proposal.md and umbrella design section 9. Phase 7 is 759f95d and normal runtime is provisioned. Existing startup instrumentation only measures process lifetime; phase 1 minimal was 15–19 ms and original single sample 320.738 ms. All runtime plugins/tools are locked; phase 7 native host/pasteboard acceptance passed. Current largefile.check walks all lines on each call below byte threshold, including completion/decoration hot paths.

## Goals / Non-Goals

**Goals:** Explain actual launch/redraw/first-use costs; preserve approved behavior and exact budgets; repeatable data and final checks.

**Non-Goals:** Extra plugin/compiler dependencies, weakening budgets, synthetic VimEnter-only readiness, OS cache eviction, routine user-data resets or reference modifications.

## Decisions

1. Measurement harness launches `nvim --embed` with immediate 160×50 attached linegrid UI. Timestamp immediately before process spawn, reconstruct grids and observe flush containing fixture text plus filename in its usable native/plugin statusline or Hyper header/action labels. The native statusline counts as usable; do not require later lualine mode labels to define the first readable editor. Capture this external wall time, an injected early-command→VimEnter hrtime marker, and complete exit lifetime separately. Use true event reads rather than coarse 30-ms polling. This measures attached UI delivery, not Metal scanout; actual host screenshots/acceptance are separate.
2. Sample empty, sole directory, explicit `-c Dashboard`, text, Lua code, Markdown. One uncounted warmup then ten or more sequential samples, no concurrent tests/installers while timing. Empty cache: new disposable XDG_CACHE_HOME per scenario, retain installed data and isolated state; label editor-cache-empty, not OS cold. Minimal uses NONE with identical UI transport; original uses reference runtimepath and installed legacy plugins read-only, same fixture metric, isolated state/cache and original data; record errors and any unusable case.
3. First operations use separate fresh processes for tree/picker/completion/shell; timestamp immediately before real input and stop at flushed meaningful tree/result/menu/actual shell output. Publish at least ten samples each. Native server handshake remains asynchronous and excluded from initial readable-grid budget, tested independently. Do not preload first-action plugins in their measurement process.
4. Inspect startup profile and lazy stats; tune only measured unnecessary eager work. Keep theme and upstream-required Tree-sitter/Leap registration early, Mason executable setup before resolution and completion capabilities before native client activation. Semantic definitions load only on supported filetypes; Blink loads for semantic dependencies or first InsertEnter. Use the already checksum-verified locked-commit native receipt synchronously so first text and maps are ready; routine startup does not spawn Git version checks. Rainbow excludes prose/help grammars; retains all code-language delimiter behavior. Profile/test each changed owner; repeat final measurement after tuning.
5. Guard fixture: 8+ MiB log, 100,000+ short-line code under/near byte threshold, 200+ KiB minified single line. Guard at 50,000 lines as well as existing byte/line limits. Cache non-large guard decisions by changedtick to avoid unchanged rescans; changes invalidate the cache, positive large decision remains conservative. Existing large exclusion hooks supply parser/render/rainbow/LSP/pairs/completion policy. Stop highlighters restarted by native ftplugins and disable Syntax event replay for guarded buffers. Exercise real redraw/motion/search and protected external reload, not only guard flag assertions.
6. Publish raw JSON data plus docs/performance.md with versions/lock digest/revisions, invocation definitions, median/nearest-rank p95 and recipes (`--startuptime`, Lazy profile, harness). Initial accepted 100/150-ms medians remain hard budgets; if repeated final data cannot meet them after reasonable tuning, pause instead of revising thresholds. p95 is disclosed, no invented p95 target.
7. After tuning run all cross-capability suites, attached UI, real clipboard and actual native appearance/screenshots with restoration; default normal startup/health and no startup network audit. Validate/sync/archive child before commit; then complete/sync/archive umbrella before finalization commit. Record actual commit references in subsequent ledger checkpoint.

## Risks / Trade-offs

- Background Mac processes affect timing → sequential warmed samples, disclose tails/environment and no concurrent agent tests during timing.
- Dashboard readiness may be scheduled after VimEnter → grid content predicate and flush are authoritative.
- Deferred work can break first input → explicit first-operation samples plus full behavioral regression suites.
- Original plugins may no longer run on current Neovim → preserve reference, report errors and phase 1 limitations, never treat a broken run as a valid performance win.

## Migration Plan

Measure current delivered runtime first, tune local modules only if justified, rerun measurements and final acceptance, publish evidence, sync/archive and commit. Rollback the identified performance increment; plugin/tool lock remains unchanged unless a reviewed need emerges.
