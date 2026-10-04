# git-terminal-workflows Specification

## Purpose
Provide lightweight buffer Git operations and persistent shell/LazyGit terminals with predictable process identity, working directory, focus and external-change refresh.

## Requirements

### Requirement: Buffer Git hunks are actionable
Tracked buffers SHALL show staged/unstaged hunk state and offer described navigation, preview, stage/reset and blame actions without conflicting structural class keys.

#### Scenario: Hunk cycle
- **WHEN** a tracked fixture is modified, navigated, previewed and staged/unstaged
- **THEN** real index/diff state and signs reflect each operation

### Requirement: Shell terminals persist predictably
On-demand shell terminals SHALL support horizontal/vertical/float layouts, preserve each process cwd, expose explicit normal-mode exit/split navigation and return editing focus when closed/exited.

#### Scenario: Layout lifecycle
- **WHEN** shells are first toggled, hidden, reopened and exited
- **THEN** process identity/cwd persist until exit, the requested layout appears and focus returns to editing

### Requirement: LazyGit has dedicated lifecycle
`<leader>lg` SHALL toggle an isolated LazyGit float rooted in the active Git project/worktree, separate from ordinary shells, with reliable toggle/exit/reopen and actionable missing-binary feedback.

#### Scenario: First LazyGit and exit
- **WHEN** the user opens LazyGit, hides/reopens it then exits the process
- **THEN** the correct Git cwd and dedicated terminal are used and editing focus is restored

### Requirement: Returning refreshes external state
Terminal return SHALL reload externally changed unmodified files and refresh tree/Git state while protecting unsaved edits and view.

#### Scenario: External modification
- **WHEN** a Git/terminal process changes a file and returns
- **THEN** an unmodified buffer reloads with its view preserved and an unsaved buffer is not overwritten
