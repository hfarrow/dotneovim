# Spec Delta

## ADDED Requirements

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
