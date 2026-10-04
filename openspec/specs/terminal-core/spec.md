# terminal-core Specification

## Purpose

Provide predictable terminal editing and file-reading behavior independent of optional UI and language plugins.

## Requirements

### Requirement: Core editing habits
The editor SHALL establish Space leader before plugin mappings, retain insert escape chords, line-boundary motions, centered search, split navigation, and visual indentation reselection. Default indentation SHALL be two spaces, subject to project/filetype settings.

#### Scenario: Core mappings are used
- **WHEN** the user invokes `jj/jk/kj`, `H/L`, `n/N`, normal `<C-h/j/k/l>`, or visual `</>`
- **THEN** the approved motions/actions execute without plugin-dependent initialization

### Requirement: Independent clipboard and editing registers
Ordinary editing SHALL use native registers without synchronizing the system clipboard. Leader-y SHALL yank to the system clipboard, leader-p SHALL paste it, and leader-P SHALL paste the last Vim yank. Visual replacement SHALL preserve the selected paste source.

#### Scenario: Delete follows a yank
- **WHEN** the user yanks text, then deletes/changes other text
- **THEN** ordinary deletion behaves normally and leader-P still pastes the previous yank
- **AND** an explicit named-register delete honors that register

#### Scenario: Clipboard operation
- **WHEN** the user uses leader-y with a motion or selection, then leader-p
- **THEN** text is copied/pasted using the system clipboard rather than remapping ordinary y/p
- **AND** visual replacement does not overwrite the clipboard source

### Requirement: Explicit saving and safe external reload
The editor SHALL write only when explicitly requested and reload externally changed unmodified file buffers on focus/buffer checks while preserving their view. Unsaved edits SHALL NOT be replaced by automatic reload.

#### Scenario: Focus changes with edits
- **WHEN** a modified buffer loses focus or the user switches buffers
- **THEN** its edits remain unsaved

#### Scenario: File changes outside the editor
- **WHEN** an unmodified file changes externally and a reload check occurs
- **THEN** the buffer reflects the file while retaining its reading position
- **AND** a modified buffer instead retains its unsaved content

### Requirement: Prose display and persistent editing state
Markdown and plain text SHALL soft-wrap at words without physical line rewriting; code/logs SHALL default to no wrap. A per-window wrap toggle SHALL be available. Undo state and valid previous cursor positions SHALL survive reopening files without placing state files in project directories.

#### Scenario: Different reading buffers
- **WHEN** Markdown/text and code/log buffers are opened in the same window
- **THEN** each receives its appropriate wrap policy without inheriting the previous file's setting
- **AND** display wrapping does not modify file contents

### Requirement: Matched theme variants
The editor SHALL use the approved Gruvbox Material palette and accommodate both light and dark background values without forcing dark mode. Manual appearance selection SHALL be available for terminals lacking detection.

#### Scenario: Background variant changes
- **WHEN** the terminal or user changes the editor background between dark and light
- **THEN** the matching theme variant is applied with the agreed base foreground/background colors
