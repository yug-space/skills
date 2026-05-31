---
name: cognitive-load
description: Keep code changes minimal, surgical, and low-cognitive-load for reviewers. Use whenever editing existing code (brown-field work) — fixing a bug, adding a small feature, refactoring, or responding to review. Counteracts the tendency to over-edit (rewrite, reformat, rename, or "improve" code beyond what the task requires) so diffs stay small and easy to verify. Invoke before making non-trivial edits and again as a self-review pass before finishing.
metadata:
  author: Claude Code
  version: "1.0"
  source: https://nrehiew.github.io/blog/minimal_editing/
allowed-tools: Read Edit Write Grep Glob Bash
---

# Cognitive Load — Minimal Editing Discipline

The scarcest resource in software development is not compute or even time — it is the
attention a human reviewer can spend understanding a change. Every line you touch is a
line someone must read, reason about, and trust. This skill keeps changes **minimal,
surgical, and faithful to the existing code** so that cognitive load stays low and the
change is easy to verify.

It is grounded in the observation (from the source blog post above) that capable models
*over-edit*: they produce output that is functionally correct but **structurally diverges
from the original far more than the fix requires** — rewriting whole functions to fix an
off-by-one, renaming variables, adding validation nobody asked for, extracting helpers.
Over-editing is rarely a capability problem. It is a default behavior to suppress.

## The one rule

> **Make the smallest change that fully solves the task, and nothing else.**

A change is *over-edited* if you could delete part of the diff and the task would still be
solved. If so, delete that part.

## When to apply this skill

Apply it to **all edits to existing code**: bug fixes, small features, refactors, review
follow-ups. It matters most in brown-field work — code whose current structure reflects
deliberate, possibly hard-won, team decisions you cannot see.

It does **not** mean "never refactor." It means: separate the *fix* from the *cleanup*.
If real cleanup is warranted, name it, and either do it in a clearly-labeled separate
commit/step or ask first. Never smuggle cleanup into a fix.

## Before you edit: scope the change

1. **State the minimal fix in one sentence.** "Change `len(x) - 1` to `len(x)`." If you
   can't say it crisply, you don't understand the task yet — read more first.
2. **Read the surrounding code** and match its conventions: naming, comment density,
   error-handling style, level of abstraction. Your change should be indistinguishable
   from code the original author would have written.
3. **Locate the single smallest edit site.** Prefer changing one expression over one line,
   one line over one block, one block over one function.

## While editing: things NOT to do (unless the task asks)

These are the classic over-edit tells. Each adds diff and cognitive load for no task value:

- **Rewriting working code** that you're merely passing through.
- **Renaming** variables, functions, or files for style/clarity.
- **Reformatting / reflowing** lines, reordering imports, changing quotes or whitespace
  outside the lines you must touch. (Let the formatter do this in its own pass.)
- **Adding defensive code** — input validation, null checks, try/except — that wasn't
  requested and isn't required for correctness of the fix.
- **Extracting helpers or introducing abstractions** to "clean up" nearby code.
- **Changing control flow** — flattening nesting, swapping loops for comprehensions,
  early-return rewrites — when the existing flow already works.
- **Touching comments or docstrings** unrelated to your change.
- **"Upgrading"** to a newer API/idiom you happen to prefer.
- **Broadening the change** to "also fix" adjacent issues you noticed. Note them for the
  user instead; don't act unprompted.

## Cognitive load is more than diff size

A small diff is necessary but not sufficient. Also minimize:

- **New concepts.** Every new name, type, parameter, or dependency is something the reader
  must hold in working memory. Reuse what exists before introducing something new.
- **Added nesting / branching.** Each extra `if`, loop, or level of indentation multiplies
  the states a reader must track. The minimal fix should add **zero** unnecessary
  control-flow complexity.
- **Action at a distance.** Prefer changes local to one place over edits scattered across
  files. A reviewer can hold a local change in their head; a spread-out one they cannot.
- **Surprise.** Code that does what its surroundings lead you to expect is nearly free to
  read. Novelty — a clever trick, an inconsistent pattern — is expensive even when correct.

## Self-review pass (do this before finishing)

Re-read your own diff as a skeptical reviewer and ask:

1. **Can I delete any hunk and still solve the task?** If yes, delete it.
2. **Does every changed line trace back to the task?** If a line is there for "niceness,"
   revert it.
3. **Did I add any nesting, branch, or abstraction the task didn't require?** Remove it.
4. **Does the change read like the author wrote it** (naming, style, conventions)?
5. **Is the diff reviewable in one sitting** without the reviewer needing context I have
   but they don't? If not, shrink it or explain it.

If you find yourself wanting to make the surrounding code better, that instinct is fine —
**surface it as a suggestion to the user, separate from the change.** Don't fold it in.

## Example

Task: fix an off-by-one so the loop covers the last element.

**Over-edited (avoid):**
```python
def process(items):
    # Validate input
    if items is None:
        raise ValueError("items cannot be None")
    results = [transform(item) for item in items]  # rewrote the loop
    return results
```

**Minimal (prefer):**
```python
def process(items):
    results = []
    for i in range(len(items)):   # was: range(len(items) - 1)
        results.append(transform(items[i]))
    return results
```

The minimal version changes one token region. The over-edited version is "better code" by
some taste, but it forces the reviewer to verify a new validation branch, a comprehension
rewrite, and a changed return path — none of which the task asked for, any of which could
hide a regression.

## How to talk about it

When you finish, your summary should make the minimality legible: state the one-sentence
fix, and if you deliberately left nearby issues untouched, say so and offer them as
optional follow-ups. This tells the user the small diff was a *choice*, not an oversight.
