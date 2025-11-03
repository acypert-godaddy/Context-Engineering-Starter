---
description: Structured analysis of an existing codebase to feed feature PRP generation
argument-hint: [output-analysis-file]
---

# Codebase Pattern & Impact Analysis

Generate a structured analysis report to support implementing or modifying features in an existing repository.

Argument: Path (relative to context root or repo root) for the analysis report (e.g. `analysis/feature_x_scan.md`).

## Goals

1. Capture architecture & layering
2. Identify relevant modules/classes/functions for upcoming feature
3. Extract patterns (naming, error handling, testing, dependency injection, configuration)
4. List potential integration points & change impact
5. Provide dependency risk + quick win assessment

## Steps

1. Determine `$CONTEXT_ROOT` (look for `context_manifest.yaml` or `context/stack_manifest.json`); fallback to `.` if absent.
   - If `stack_manifest.json` exists, parse it to:
     - List declared language(s) & source directories
     - Extract lint / test commands for later PRP injection
     - Note any required env vars for readiness checks
2. Read INITIAL / PRP / plan files if they exist to infer target feature.
3. If monorepo (`monorepo.workspaces == true` in manifest):
   - Enumerate `packages` entries
   - If user supplied `--package <name>` flag, focus analysis on that package plus any declared dependency packages
   - Otherwise analyze root + defaultPackage
   - For each package produce: tree snippet, dependency manifest summary (package.json fields dev/prod deps), test coverage placeholders
4. Build codebase inventory:
   - Directory tree (depth-limited sensible defaults, e.g., 5)
   - Count of files by type
5. Pattern extraction:
   - Common initializers (e.g., `__init__.py`, factory patterns)
   - Error handling idioms (search for `try:` + custom Exceptions)
   - Configuration access patterns (env vars, settings modules)
   - Logging patterns
   - Testing style (fixtures, test naming, assertion style)
6. Similar feature search (per scope): grep for keywords from INITIAL/feature name within focused package paths first, then globally.
7. Impact candidate list: for each candidate file, classify impact type: MODIFY | EXTEND | NEW.
8. Risk assessment (scale 1–5): complexity, coupling, test coverage presence.
9. Recommendations: sequencing & refactor prep items (package-local vs cross-package changes; note if manifest needs new inter-package dependency entries).

## Output Format (Markdown Skeleton)

```
# Codebase Analysis: <Feature / Context>

## Summary
- Scope: ...
- Key integration areas: ...
- Suggested starting point: ...

## Inventory (Root / Packages)
### Package Focus
Target Package: <name or ALL>
Dependency Graph (simplified):
```

<pkg-a> -> <pkg-b>

```

```

```bash
<tree output>
```

```

## Patterns
### Architecture
### Error Handling
### Configuration
### Logging
### Testing

## Similar Implementations
| File | Why Relevant | Notes |

## Impact Matrix (Aggregated)
| Path | Impact | Reason | Risk(1-5) | Tests Exist? |

## Recommendations
### Stack & Workspace Alignment
- Manifest present: YES/NO
- Drift items (files or tools used but not declared)
- Package drift (package.json scripts missing from manifest, or manifest references nonexistent packages)
1. ...

## Open Questions
- ...

## Raw Notes
```

<scratch observations>
```
```

## Completion

Confirm file written and reference next step:
"Analysis saved to: <path>. Next: /generate-feature-prp <INITIAL or request file> --analysis <that path>"
