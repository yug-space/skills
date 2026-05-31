# skills

A collection of [Claude Code](https://claude.com/claude-code) / agent **skills**,
installable with the [`npx skills`](https://github.com/vercel-labs/skills) package manager.

| Skill | What it does |
|-------|--------------|
| [`cognitive-load`](./skills/cognitive-load/SKILL.md) | Keeps code changes minimal, surgical, and low-cognitive-load for reviewers — counteracts model **over-editing**. |

## Install

### With `npx skills` (recommended)

```bash
# Install every skill in this repo
npx skills add yug-space/skills

# See what's available first
npx skills add yug-space/skills --list

# Install just one skill, globally, for Claude Code, no prompts
npx skills add yug-space/skills --skill cognitive-load -g -a claude-code -y
```

`npx skills` works with Claude Code, Cursor, Codex, OpenCode, and 50+ other agents, and can
install globally (`-g`, into `~/.claude/skills`) or into the current project (`./.claude/skills`).

### One-liner without npx

```bash
# Clone a single skill straight into your skills dir
git clone --depth 1 https://github.com/yug-space/skills /tmp/yug-skills \
  && cp -r /tmp/yug-skills/skills/cognitive-load ~/.claude/skills/cognitive-load \
  && rm -rf /tmp/yug-skills
```

### With the bundled script

```bash
git clone https://github.com/yug-space/skills
cd skills
./install.sh cognitive-load            # user install (~/.claude/skills), symlinked
./install.sh cognitive-load --project  # into ./.claude/skills of the current repo
./install.sh --all                     # install every skill in the repo
```

Symlink is the default, so `git pull` in this repo updates your installed skills.

## Updating

```bash
npx skills add yug-space/skills          # re-run to pull latest
# or, if you cloned:  cd skills && git pull
```

## Uninstall

```bash
rm -rf ~/.claude/skills/cognitive-load
```

## Repository layout

```
skills/
  cognitive-load/
    SKILL.md          # one folder per skill — name + description in YAML frontmatter
```

`npx skills` discovers any `skills/<name>/SKILL.md`. To add a new skill, create a new
folder under `skills/` with its own `SKILL.md` and push — it becomes installable
immediately, no manifest or config required.

## Authoring a new skill

```bash
cd skills && npx skills init my-new-skill   # scaffolds skills/my-new-skill/SKILL.md
```

A valid `SKILL.md` needs YAML frontmatter with at least `name` and `description`:

```yaml
---
name: my-new-skill
description: One line on what it does and when to use it — this is what the agent matches on.
---

# My New Skill
Instructions for the agent...
```

## License

[MIT](./LICENSE)
