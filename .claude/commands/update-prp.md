---
description: Update or refine an existing PRP after code drift or feedback
argument-hint: [prp-file-path]
---

# Update / Refine PRP

Purpose: Adjust an existing PRP to accommodate codebase drift, new requirements, or review feedback without losing original intent.

## Steps

1. Load original PRP.
2. Detect code drift: verify each MODIFY target still matches expected BEFORE context. Record deviations.
3. Incorporate new requirements (ask: have success criteria changed? any new edge cases?).
4. Update sections: Impact Matrix, Tasks, Pseudocode, Validation, Risk.
5. Increment version header in PRP (e.g., `Version: 1 -> 2`).
6. Append a CHANGE HISTORY section summarizing modifications.

## Output

Overwrite the same PRP file (preserve original content ordering where possible). Announce: "PRP updated (vN). Ready for /execute-feature-prp".

## Safety

- Never remove previous success criteria—mark deprecated instead.
- If scope creep detected, explicitly note it.
