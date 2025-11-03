---
description: Initialize or upgrade context engineering scaffolding in a repo
argument-hint: [optional-context-root-folder]
---

# Initialize Context Engineering Scaffolding

You set up (or upgrade) the context engineering workspace inside an existing project.

## Usage

```
/init-context            # uses default folder: context/
/init-context ce/        # custom folder name
```

## Behavior

1. Determine context root (default: `context/`). Call it `$CONTEXT_ROOT`.
2. Create (if missing) the following structure (do NOT overwrite existing files unless noted):
   ```
   $CONTEXT_ROOT/
     PRPs/
       templates/
     examples/
     analysis/          # codebase analysis outputs
     research/          # external research notes
     scratch/           # temporary working notes (ignored in PRPs)
     docs/              # imported reference docs
   ```
3. Copy baseline templates:
   - `PRPs/templates/prp_base.md` (only if not present OR user explicitly removed; never overwrite modified file)
   - Example INITIAL template → `$CONTEXT_ROOT/INITIAL.md` (if absent)
4. If the repository already has legacy top-level `PRPs/` or `examples/`, offer a consolidation note (do NOT auto-move). Document paths in `$CONTEXT_ROOT/analysis/consolidation_suggestions.md`.
5. Add or update a context manifest: `$CONTEXT_ROOT/context_manifest.yaml` containing:
   ```yaml
   version: 1
   context_root: $CONTEXT_ROOT
   generated: <timestamp>
   sections:
     prps: PRPs/
     examples: examples/
     analysis: analysis/
     research: research/
     docs: docs/
   commands:
     generate_feature_prp: /generate-feature-prp
     execute_feature_prp: /execute-feature-prp
   ```
6. Verify `.claude/commands/` contains the extended commands (`generate-feature-prp`, `execute-feature-prp`, `analyze-codebase`, `update-prp`). If missing, instruct the user to copy them from the template repository.

## Output

Summarize actions taken, newly created files, and any skipped (existing) files. Provide next command suggestions:

```
Next: /analyze-codebase analysis/initial_codebase_scan.md
Then: /generate-feature-prp INITIAL.md
```

## Safety

- Never delete or overwrite user content.
- If a conflicting directory exists but is a file, halt and report.

## Completion Criteria

- All required folders exist
- Manifest created / updated
- Template(s) present
- Clear next steps printed

If everything is ready, respond: "Context engineering initialized at $CONTEXT_ROOT".
