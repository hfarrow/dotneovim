# dotneovim
## Prerequisites
- Many external binaries must installed manually through the system package manager. The configs do not automatically install external dependencies. This allows the system package manager to keep such dependencies up to date more easily.
  - See [this guide](https://gist.github.com/hfarrow/bc40bbef99019ae093b9f721db174070) for likely packages to install
  - TODO: make this README list required packages

## Agent setup

Repository-wide agent instructions live in the root [`AGENTS.md`](AGENTS.md); `CLAUDE.md` imports that file. Reusable skills live in [`.agents/skills/`](.agents/skills/), with `.claude/skills/` linking to that directory.

OpenSpec is the primary workflow for defining, planning, and implementing substantive changes. See `AGENTS.md` for the workflow and planning-to-implementation handoff. Specs are introduced with new work; existing configuration does not need retroactive specs or changes.

The OpenSpec CLI is pinned locally in `.agents/tools/` and requires Node.js 20.19.0 or newer and npm. Install the locked dependencies and invoke the CLI from the repository root:

```sh
npm ci --prefix .agents/tools
.agents/tools/node_modules/.bin/openspec list --json
```

The manifest and lockfile are tracked; installed `node_modules/` are ignored. To upgrade the CLI and refresh the repository-local skills, run:

```sh
npm install --prefix .agents/tools --save-dev --save-exact @fission-ai/openspec@latest
.agents/tools/node_modules/.bin/openspec update
```

OpenSpec is configured for the shared `.agents` skills target, so `update` writes skills into `.agents/skills/`.
