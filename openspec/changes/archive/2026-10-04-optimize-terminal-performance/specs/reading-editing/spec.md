# Spec Delta

## MODIFIED Requirements

### Requirement: Large files avoid expensive decoration
Large or long-line buffers SHALL disable parser, renderer, rainbow, semantic tooling, completion and automatic pairing work while retaining editing, search and reload. Guard checks SHALL avoid repeated whole-buffer work when contents are unchanged. Acceptance SHALL measure many-line logs and minified inputs, retaining responsive reading/search and reporting interaction timings.

#### Scenario: Large input
- **WHEN** a buffer exceeds the documented byte/line-length limits
- **THEN** expensive decorations do not attach and ordinary reading/search continues

#### Scenario: Many lines or minified content
- **WHEN** a sizable log, many short lines or a long minified line is opened and searched/reloaded
- **THEN** excluded features stay inactive, native operations remain correct and bounded interaction timings are recorded
