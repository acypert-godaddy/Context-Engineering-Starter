---
description: Execute a feature PRP that modifies an existing codebase with regression safeguards
argument-hint: [prp-file-path]
---

# Execute Feature PRP (Existing Codebase)

Implements modifications defined in a feature PRP with strong emphasis on safety, regression protection, and incremental validation.

## Pre-Flight

1. Read PRP fully.
2. List tasks → create local todo list (and optionally external task system if configured).
3. Confirm all impacted files still match the PRP's described BEFORE state; if drift is detected, pause and create an "UPDATE PRP" recommendation.

## Execution Principles

- Single-task focus: only one active modification at a time.
- Preserve existing patterns; mimic style / error handling.
- Add tests before or alongside changes (TDD where practical) for high-risk modifications.

## Cycle Per Task

1. Mark task in-progress
2. If MODIFY: capture minimal diff context (lines to be changed) before editing.
3. Apply change.
4. Run lint + type + targeted tests.
5. Update cumulative CHANGELOG snippet (in-memory or `$CONTEXT_ROOT/analysis/run_changes.md`).
6. Mark task complete.

## Validation Layers

1. Static: lint, type-check
2. Unit: new & impacted existing tests
3. Regression: run subset of existing suite relevant to touched modules
4. Full suite (at end)

## Rollback Safety

If a task introduces failing regressions that cannot be resolved quickly, revert that task's edits before proceeding (never pile unstable changes).

## Finalization

- Re-run full validation gates defined in PRP.
- Ensure checklist satisfied.
- Output summary: tasks completed, tests added/modified, risk items mitigated, remaining TODOs.

If successful, respond: "Feature PRP execution complete and validated." Otherwise, clearly list blocking issues.
