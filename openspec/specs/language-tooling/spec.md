# language-tooling Specification

## Purpose
Provide reproducible semantic language tools and deliberate completion for supported editing workflows, with quiet diagnostics and clear syntax-only boundaries.

## Requirements

### Requirement: Editor tools are explicitly provisioned
Editor tools SHALL use a versioned managed manifest and explicit install/update procedure; provisioned startup SHALL perform no registry refresh/download and SHALL not silently substitute host tools.

#### Scenario: Managed precedence
- **WHEN** a host executable also exists
- **THEN** supported servers use the manifest-managed executable and report missing provisioning rather than choosing the host copy

### Requirement: Supported semantic clients attach
Bash, JS/TS, Lua and Python SHALL initialize native semantic clients with completion capabilities prepared first, appropriate roots and project interpreter/compiler selection.

#### Scenario: Language handshake
- **WHEN** supported fixture files open
- **THEN** real clients initialize and navigation/diagnostics work; Bash diagnostics include ShellCheck, Lua knows Neovim runtime and Python uses its project environment

#### Scenario: Syntax-only and large buffers
- **WHEN** C#, Rust, Zsh or a guarded large buffer opens
- **THEN** no semantic client attaches; Zsh uses native dialect syntax and buffer/path completion

### Requirement: Diagnostics remain quiet
Diagnostics SHALL show signs and explicit float/navigation/picker without automatic inline or virtual-line messages.

#### Scenario: Diagnostic appears
- **WHEN** a server reports a problem
- **THEN** signs/picker/native navigation expose it without inline message decoration

### Requirement: Completion acceptance is deliberate
Completion SHALL show automatically without selection/insertion, keep Enter as newline and accept only a deliberately selected item with Ctrl-y, using native LSP snippets without extra collections.

#### Scenario: No selection
- **WHEN** a completion menu appears and Enter or Ctrl-y is pressed before selecting
- **THEN** Enter inserts a newline and Ctrl-y does not accept the first item

#### Scenario: Explicit selection
- **WHEN** Ctrl-n/Ctrl-p selects an item then Ctrl-y accepts it
- **THEN** the item is inserted once, native snippet placeholders work and automatic pairs do not duplicate brackets

### Requirement: Platform executable and interpreter paths
Managed tools SHALL resolve to the platform's native executable or command wrapper in the managed bin directory. Python project discovery SHALL recognize both .venv and venv layouts for the active platform and use an available host Python only when no project or explicit virtual environment is available.

#### Scenario: Windows path review
- **WHEN** native Windows paths are selected
- **THEN** native tools resolve with .exe, Node transports with .cmd, and both project environment names resolve Scripts/python.exe and formatter executables
- **AND** macOS/WSL retain POSIX bin paths without Windows suffixes

#### Scenario: Project Python environment
- **WHEN** a project environment or explicit VIRTUAL_ENV exists
- **THEN** its Python interpreter is selected independently of the managed language server runtime
