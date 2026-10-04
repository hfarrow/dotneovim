# Tasks

## 1. Baseline and isolation

- [x] 1.1 Capture minimal startup samples and original startup outcome before replacement; verify recorded invocation/version/architecture and do not treat failed original startup as a successful timing baseline.
- [x] 1.2 Prepare isolated config/data/state/cache validation with legacy-package detection checks; verify the environment cannot source shared Packer start packages.

## 2. Core implementation

- [x] 2.1 Replace the legacy entry point/modules/filetype helpers with options, keymaps and autocmd modules; verify Lua compilation and core tests for standard registers, clipboard/last-yank mappings, counts, named registers, visual paste, explicit saves, reload protection/view, wrap transitions, and cursor/undo behavior; publish core key documentation.
- [x] 2.2 Add locked lazy.nvim/Material provisioning and missing-dependency fallback; verify clean install, locked restore, provisioned offline startup, legacy isolation, theme base colors in both variants, and README setup commands.

## 3. Acceptance

- [x] 3.1 Run integrated isolated startup/core tests and record baseline/foundation evidence; verify strict OpenSpec validation, no required blocker, and unchanged personal spell dictionary before archive.
