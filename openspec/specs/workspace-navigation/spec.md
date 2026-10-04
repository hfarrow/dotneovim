# workspace-navigation Specification

## Purpose
Provide predictable terminal startup, directory browsing and explicit filename/content search boundaries without disrupting ordinary editing launches.

## Requirements

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

### Requirement: Warm dashboard startup budget
Warmed median process-launch-to-useful-attached-redraw latency SHALL be at most 150 ms for empty, directory and explicit dashboard launches on the tested Mac, with the Hyper header/actions visible and tree hidden. At least ten samples per scenario and median/p95 SHALL be published.

#### Scenario: Dashboard readiness
- **WHEN** each dashboard invocation is measured after provisioning and cache warmup
- **THEN** a flushed grid containing the usable dashboard is observed within the median budget, not inferred from VimEnter or process exit

### Requirement: Deferred first operations are measured
Acceptance SHALL measure actual first tree, picker, completion-menu and terminal readiness in separate fresh editor processes, retaining working first actions rather than hiding their latency through deferral. Routine startup SHALL perform no update/download work.

#### Scenario: First action after startup
- **WHEN** the first requested operation is invoked through real input
- **THEN** its useful UI/results or shell output appears and latency/sample definitions are reported separately from startup

### Requirement: Search shortcuts use paired final keys
Normal-mode search shortcuts SHALL share `<leader>f`: normal files/content use `'`/`"`, hidden files/content use `g`/`G`, and all files/content use `a`/`A`. Labels SHALL identify kind and visibility. Retired `<leader>'` and `<leader>fh` mappings SHALL be absent; format, buffer and project shortcuts SHALL remain available without prefix conflicts.

#### Scenario: Cold and warm paired dispatch
- **WHEN** each of the six shortcuts is invoked before and after the picker has loaded
- **THEN** it opens the correct filename or content picker in the selected visibility and default directory scope
- **AND** the mapping label identifies its kind and visibility

#### Scenario: Adjacent mapping ownership
- **WHEN** search, formatting, and buffer-navigation handlers are loaded
- **THEN** each paired key has one owner, no executable shorter-prefix or longer descendant mapping shadows it, and `<leader>ff`, `<leader>fb`, and `<leader>fp` retain their actions
- **AND** retired keys have no configuration mapping
