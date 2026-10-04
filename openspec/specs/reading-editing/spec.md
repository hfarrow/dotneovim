# reading-editing Specification

## Purpose
Make supported code and prose readable and structurally editable while preserving native editing semantics, document contents and responsiveness for large files.

## Requirements

### Requirement: Focused syntax and structural objects
Supported languages SHALL have deliberately provisioned syntax highlighting and query-dependent function/class/argument selection and movement; unavailable queries SHALL degrade gracefully without blanket structural indentation or swapping.

#### Scenario: Supported parser
- **WHEN** Lua, Bash, JS/TS/TSX, Python, C#, Rust or Markdown is opened after parser provisioning
- **THEN** highlighting works and available `af/if/ac/ic/aa/ia` objects and structural jumps operate on real syntax

#### Scenario: Missing parser or query
- **WHEN** a parser/query is unavailable
- **THEN** ordinary editing and native motions remain usable and the missing capability is reported

### Requirement: Editing aids retain intended keys
Surround SHALL use the `gz` family with counts and dot-repeat; typed automatic pairs SHALL avoid duplicate completion brackets; Leap SHALL work on its first invocation in normal, visual and operator modes.

#### Scenario: First editing operations
- **WHEN** a user surrounds, changes/deletes a surround, repeats/counts it, types pairs or leaps to a visible target
- **THEN** the intended operation occurs without lazy replay loss or clipboard coupling

### Requirement: Markdown presentation is local
Markdown SHALL render in-buffer with an explicit raw/render toggle, native US-English spelling and the preserved personal dictionary, without modifying contents or leaking mappings/options to other filetypes.

#### Scenario: Render and edit
- **WHEN** a Markdown buffer renders, switches to editing/raw mode and back
- **THEN** its contents remain identical and render/spell behavior remains local

### Requirement: Large files avoid expensive decoration
Large or long-line buffers SHALL disable parser, renderer, rainbow, semantic tooling, completion and automatic pairing work while retaining editing, search and reload. Guard checks SHALL avoid repeated whole-buffer work when contents are unchanged. Acceptance SHALL measure many-line logs and minified inputs, retaining responsive reading/search and reporting interaction timings.

#### Scenario: Large input
- **WHEN** a buffer exceeds the documented byte/line-length limits
- **THEN** expensive decorations do not attach and ordinary reading/search continues

#### Scenario: Many lines or minified content
- **WHEN** a sizable log, many short lines or a long minified line is opened and searched/reloaded
- **THEN** excluded features stay inactive, native operations remain correct and bounded interaction timings are recorded
