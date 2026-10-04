# Repository-local agent setup

`AGENTS.md` at the repository root is the canonical instructions file. `CLAUDE.md` imports it, and reusable skills live in `.agents/skills/`; `.claude/skills/` links to that skills directory.

Add reusable skills under `.agents/skills/<skill-name>/SKILL.md`. Install OpenSpec's repository-local skills by running its CLI against this repo with the `agents` target; do not install its skills into a home-directory skills folder.

The OpenSpec CLI is pinned in `.agents/tools/package.json` and its lockfile. From the repository root, install it with `npm ci --prefix .agents/tools`, then invoke `.agents/tools/node_modules/.bin/openspec`. Keep installed dependencies out of Git.
