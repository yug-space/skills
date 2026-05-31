# cognitive-load — a Claude Code skill

Keep code changes **minimal, surgical, and low-cognitive-load for reviewers.**

This is a [Claude Code](https://claude.com/claude-code) skill that counteracts a default
behavior of capable models: **over-editing.** When asked to fix an off-by-one, a model will
often rewrite the whole function, rename variables, add validation nobody asked for, and
"improve" nearby code. The fix is correct, but the diff is large and expensive to review.

The scarcest resource in development is the attention a human reviewer can spend
understanding a change. This skill makes the model spend it wisely:

> **Make the smallest change that fully solves the task, and nothing else.**

It applies whenever you edit existing (brown-field) code — bug fixes, small features,
refactors, review follow-ups — both *before* editing (to scope the change) and *after*
(as a self-review pass that deletes anything the task didn't require).

Inspired by [_Coding Models Are Doing Too Much_](https://nrehiew.github.io/blog/minimal_editing/),
which measures over-editing with token-level Levenshtein distance and added cognitive
complexity, and shows that explicit constraints sharply reduce it.

## Install

### One-liner (recommended)

```bash
git clone https://github.com/yug-space/cognitive-load-skill ~/.claude/skills/cognitive-load
```

That's it — Claude Code auto-discovers any skill folder under `~/.claude/skills/`. Restart
your Claude Code session (or run `/doctor`) and the `cognitive-load` skill will be listed.

### Install script

```bash
git clone https://github.com/yug-space/cognitive-load-skill
cd cognitive-load-skill
./install.sh            # installs for your user (~/.claude/skills)
./install.sh --project  # installs into ./.claude/skills of the current repo instead
```

The script symlinks (or copies with `--copy`) the skill into place, so you can `git pull`
to update.

### Per-project install

To ship the skill with a specific repo so your whole team gets it, copy `SKILL.md` into
that repo at `.claude/skills/cognitive-load/SKILL.md` and commit it.

### Manual install

Copy `SKILL.md` to `~/.claude/skills/cognitive-load/SKILL.md`.

## Usage

Once installed, Claude invokes it automatically when it's about to edit existing code. You
can also invoke it explicitly:

```
/cognitive-load
```

…or just ask: *"keep this change minimal"* / *"don't over-edit."*

## Updating

```bash
cd ~/.claude/skills/cognitive-load && git pull
```

(If you installed with the script's `--copy` mode, re-run `./install.sh` instead.)

## Uninstall

```bash
rm -rf ~/.claude/skills/cognitive-load
```

## What's inside

- [`SKILL.md`](./SKILL.md) — the skill itself: the one rule, a pre-edit scoping checklist,
  the list of over-edit tells to avoid, the cognitive-load factors beyond diff size, a
  5-question self-review pass, and a worked example.

## License

[MIT](./LICENSE) — use it, fork it, ship it.

## Contributing

Issues and PRs welcome. Keep changes minimal and low-cognitive-load. 🙂
