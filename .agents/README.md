# Repository-local agent setup

`AGENTS.md` at the repository root is the canonical instructions file. `CLAUDE.md` imports it, and reusable skills live in `.agents/skills/`; `.claude/skills/` links to that skills directory.

Add reusable skills under `.agents/skills/<skill-name>/SKILL.md`. Install OpenSpec's repository-local skills by running its CLI against this repo with the `agents` target; do not install its skills into a home-directory skills folder.
