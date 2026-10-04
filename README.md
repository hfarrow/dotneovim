# dotneovim
## Prerequisites
- Many external binaries must installed manually through the system package manager. The configs do not automatically install external dependencies. This allows the system package manager to keep such dependencies up to date more easily.
  - See [this guide](https://gist.github.com/hfarrow/bc40bbef99019ae093b9f721db174070) for likely packages to install
  - TODO: make this README list required packages

## Agent setup

Repository-wide agent instructions live in the root [`AGENTS.md`](AGENTS.md); `CLAUDE.md` imports that file. Reusable skills live in [`.agents/skills/`](.agents/skills/), with `.claude/skills/` linking to that directory.

OpenSpec is the primary workflow for defining, planning, and implementing substantive changes. See `AGENTS.md` for the workflow and planning-to-implementation handoff. Specs are introduced with new work; existing configuration does not need retroactive specs or changes.

OpenSpec is configured for the shared `.agents` skills target. To refresh the repository-local OpenSpec skills after upgrading the CLI, run:

```sh
npx --yes @fission-ai/openspec@latest update
```

This writes OpenSpec skills into `.agents/skills/`; it does not install skills into a home-directory location.
