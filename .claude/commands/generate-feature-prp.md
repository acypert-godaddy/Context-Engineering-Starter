---
description: Generate a feature PRP for modifying or extending an existing codebase
argument-hint: [feature-request-file] [--analysis path] [--context-root folder]
---

# Generate Feature PRP (Existing Codebase Mode)

Create a context-rich PRP focused on integrating with and modifying an existing codebase.

Arguments:

1. Required: Feature request file (e.g., `INITIAL.md` or `$CONTEXT_ROOT/INITIAL.md`)
2. Optional flags:
   - `--analysis path/to/analysis.md` (produced by `/analyze-codebase`)
   - `--context-root context/` (override detection)
   - `--package <name>` (for monorepo: limit scope to a single package; inject that package's build/test commands)

## Process

1. Detect `$CONTEXT_ROOT` via `context_manifest.yaml` or flag; else fallback to `.`.
2. Read feature request + optional analysis file.
3. Enumerate all referenced documentation & examples. If none, prompt yourself to search & add.
4. If `context/stack_manifest.json` exists:
   - Load lint, type-check, and test commands and embed them under Validation Loop
   - Insert environment variable prerequisites section
   - Flag any new tools implied by the feature that are absent from the manifest (suggest manifest patch)
   - If `--package` provided, pull commands from that package block; else fallback to root / defaultPackage commands
5. Perform delta planning:
   - For each impacted component: BEFORE summary (current behavior) → AFTER intent (target behavior).
   - Classify each as: MODIFY | EXTEND | NEW | REMOVE (rare; justify if used).
6. Derive Change Impact Matrix (include risk & rollback strategy each row).
7. Plan validation gates (unit, integration, regression tests referencing existing test patterns).
8. Populate updated PRP from enhanced template (include diff, compatibility, and stack-aligned validation gates).
9. File naming: `PRPs/<kebab-feature-name>.md` inside `$CONTEXT_ROOT` if present; else root `PRPs/`.

## Mandatory Sections

- Goal / Why / Success Criteria
- Existing Artifacts Inventory
- Change Impact Matrix
- Desired Codebase Tree (delta-focused)
- Tasks (ordered with dependency notes)
- Per-task pseudocode (diff style when modifying)
- Validation Loop (regression + new behavior)
- Rollback Plan (how to revert changes safely)

## Quality Bar Checklist (append to PRP)

```
- [ ] All modified files listed
- [ ] Each task has clear acceptance condition
- [ ] Regression tests planned (not just new tests)
- [ ] Rollback strategy documented
- [ ] Risk ≥4 items have mitigation
- [ ] External docs referenced with deep links
```

## Output

Write PRP file and report path + next step:
"PRP ready: <path>. Execute with: /execute-feature-prp <that path>"
