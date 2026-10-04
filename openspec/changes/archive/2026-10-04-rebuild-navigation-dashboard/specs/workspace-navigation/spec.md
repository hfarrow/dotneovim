# Spec Delta

## Purpose

Provide predictable terminal startup, directory browsing and explicit filename/content search boundaries without disrupting ordinary editing launches.

## ADDED Requirements

### Requirement: Startup respects invocation intent
The editor SHALL show the Hyper dashboard only for empty or sole-directory launches, with the tree initially hidden and the directory as search scope.

#### Scenario: Empty or directory invocation
- **WHEN** Neovim starts without files or with one directory
- **THEN** the dashboard shows its header, up to twenty global recent files and search/config/tree shortcuts, with `e` opening the tree

#### Scenario: Editing invocation
- **WHEN** Neovim starts with a file, multiple arguments, commit message or stdin
- **THEN** editing contents remain visible without dashboard takeover

### Requirement: Search visibility is explicit
Filename and content search SHALL offer normal, hidden and all modes; normal excludes hidden and respects ignores, hidden respects ignores, and all includes ignored paths but excludes `.git` contents.

#### Scenario: Inclusion matrix
- **WHEN** both kinds of search run against normal, hidden, ignored and `.git` fixtures including paths containing spaces
- **THEN** each result set matches the selected visibility mode without following symlinks indiscriminately

### Requirement: Search scope is explicit
Search SHALL default to the opened/current directory and allow project-root widening without changing cwd, with scope and visibility displayed in the picker.

#### Scenario: Nested project
- **WHEN** a picker widens from a nested directory to its Git/worktree project
- **THEN** parent results become available and cwd remains unchanged

#### Scenario: No project
- **WHEN** no bounded project marker exists
- **THEN** the picker labels its directory fallback

### Requirement: Tree supports daily file operations
The tree SHALL be on demand at `<leader>e`, expose help/reveal and create/rename/move/copy/delete, display Git state, and return focus predictably on close.

#### Scenario: Tree operation cycle
- **WHEN** a user opens the tree, creates and renames a file, copies/moves it, deletes it and closes the tree
- **THEN** filesystem results match the operations and focus returns to the editing window

### Requirement: Navigation is discoverable
The editor SHALL offer recent-file, buffer and current-buffer pickers, selection/confirmation and quickfix handoff, described keys, deferred shortcut discovery and a restrained statusline without a buffer bar.

#### Scenario: First use
- **WHEN** navigation actions are first invoked
- **THEN** the real plugins perform the action, display theme-derived UI and preserve native editing/register keys
