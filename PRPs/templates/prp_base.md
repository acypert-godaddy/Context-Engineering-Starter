name: "Base PRP Template v2 - Context-Rich with Validation Loops"
description: |

## Purpose

Template optimized for AI agents to implement features with sufficient context and self-validation capabilities to achieve working code through iterative refinement.

## Core Principles

1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

---

## Goal

[What needs to be built - be specific about the end state and desires]

## Why

- [Business value and user impact]
- [Integration with existing features]
- [Problems this solves and for whom]

## What

[User-visible behavior and technical requirements]

### Success Criteria

- [ ] [Specific measurable outcomes]

## All Needed Context

### Context Root

If this project uses a consolidated context folder, record it:

```yaml
context_root: [path or '.' if not consolidated]
manifest: [path to context_manifest.yaml if present]
```

### Documentation & References (list all context needed to implement the feature)

```yaml
# MUST READ - Include these in your context window
- url: [Official API docs URL]
  why: [Specific sections/methods you'll need]

- file: [path/to/example.py]
  why: [Pattern to follow, gotchas to avoid]

- doc: [Library documentation URL]
  section: [Specific section about common pitfalls]
  critical: [Key insight that prevents common errors]

- docfile: [PRPs/ai_docs/file.md]
  why: [docs that the user has pasted in to the project]
```

### Current Codebase tree (run `tree` in the root of the project) to get an overview of the codebase

```bash

```

### Desired Codebase tree (delta-focused) with files to be added and responsibility of file

```bash

```

### Known Gotchas of our codebase & Library Quirks

```python
# CRITICAL: [Library name] requires [specific setup]
# Example: FastAPI requires async functions for endpoints
# Example: This ORM doesn't support batch inserts over 1000 records
# Example: We use pydantic v2 and
```

### Existing Artifacts Inventory (for existing project feature work)

| Path | Role | Current Behavior Summary | Tests Present? | Notes |

### Change Impact Matrix

| Path | Action (MODIFY/EXTEND/NEW/REMOVE) | Reason | Risk(1-5) | Rollback Strategy |

## Implementation Blueprint

### Data models and structure

Create the core data models, we ensure type safety and consistency.

```text
Examples (adapt to stack):
 - Data models (ORM / DTO / schema / interface definitions)
 - Validation objects / serializers
 - Domain entities & value objects
 - Migration specs (if persistence layer changes)
```

### list of tasks to be completed to fullfill the PRP in the order they should be completed

```yaml
Task 1:
MODIFY src/existing_module.py:
  - FIND pattern: "class OldImplementation"
  - INJECT after line containing "def __init__"
  - PRESERVE existing method signatures

CREATE src/new_feature.py:
  - MIRROR pattern from: src/similar_feature.py
  - MODIFY class name and core logic
  - KEEP error handling pattern identical

...(...)

Task N:
...

```

### Per task pseudocode as needed added to each task (use diff-style hints for modifications)

```text
# Task 1 Example Pseudocode (language-agnostic)
FUNCTION new_feature(input):
  # VALIDATE: ensure input meets constraints (reference existing validation utilities)
  validated = VALIDATE(input)

  # RESOURCE: acquire pooled connection (reuse existing resource acquisition pattern)
  WITH connection_pool.acquire() AS conn:
  # RETRY: wrap external call with standardized retry/backoff helper
  result = RETRY(max_attempts=3, backoff="exponential") DO
    rate_limiter.wait()
    RETURN external_service.call(validated)

  # FORMAT: normalize response via existing response formatter
  RETURN format_response(result)
```

### Integration Points

```yaml
DATABASE:
  - migration: "Add column 'feature_enabled' to users table"
  - index: "CREATE INDEX idx_feature_lookup ON users(feature_id)"

CONFIG:
  - add to: config/settings.py
  - pattern: "FEATURE_TIMEOUT = int(os.getenv('FEATURE_TIMEOUT', '30'))"

ROUTES:
  - add to: src/api/routes.py
  - pattern: "router.include_router(feature_router, prefix='/feature')"
```

## Validation Loop

### Regression Safeguards

List existing test modules / commands to run to ensure no unintended breakage.

```bash
# Example subset (choose equivalent for your stack)
# Jest (JavaScript): npx jest path/to/module.test.ts -i
# Go (Golang): go test ./pkg/existing -run TestExistingBehavior -count=1
# Java (Gradle): ./gradlew test --tests com.example.ExistingBehaviorTest
# Python (Pytest): pytest tests/test_existing_module.py::TestExistingBehavior -q
```

### Rollback Plan

Describe how to revert changes if deployment validation fails.

### Level 1: Syntax & Style

```bash
# Run these FIRST - fix any errors before proceeding (pick tools matching your stack)
# JavaScript/TypeScript: eslint . --fix && tsc --noEmit
# Go: golangci-lint run && go vet ./...
# Java: ./gradlew check (or mvn -q -DskipTests=false verify)
# Python: ruff check . --fix && mypy .
# .NET: dotnet format && dotnet build

# Expected: No errors. If errors, READ the error and fix.
```

### Level 2: Unit Tests each new feature/file/function use existing test patterns

```text
# Minimal test matrix (adapt syntax to your framework)
Test: happy path → expects success status / correct output shape
Test: validation error → invalid input triggers explicit validation failure (NOT generic exception)
Test: external dependency timeout → returns structured error with timeout indicator
Test: idempotency / repeat call (if applicable)
Test: concurrency (if feature is stateful or uses shared resources)
```

```bash
# Run and iterate until passing (examples):
# JS/TS: npx jest path/to/new_feature.test.ts --runInBand
# Go: go test ./... -count=1
# Java: ./gradlew test --tests *NewFeature*
# Python: pytest tests/test_new_feature.py -v
```

### Level 3: Integration Test

```bash
# Start the service (examples):
# JS/TS (Node): npm run dev
# Go: go run ./cmd/service
# Java: ./gradlew bootRun
# Python: uv run python -m src.main --dev

# Example HTTP test (adjust path):
curl -X POST http://localhost:8000/feature \
  -H "Content-Type: application/json" \
  -d '{"param": "test_value"}'

# Expected: JSON success payload (verify schema)
```

## Final validation Checklist

- [ ] All tests pass (command: <project-specific>)
- [ ] No lint/style errors (command: <linter command>)
- [ ] Static analysis/type checks clean (if applicable)
- [ ] Manual test successful: [specific curl/command]
- [ ] Error cases handled gracefully
- [ ] Logs are informative but not verbose
- [ ] Documentation updated if needed

---

## CHANGE HISTORY

| Version | Date       | Summary     |
| ------- | ---------- | ----------- |
| 1       | YYYY-MM-DD | Initial PRP |

## Anti-Patterns to Avoid

- ❌ Don't create new patterns when existing ones work
- ❌ Don't skip validation because "it should work"
- ❌ Don't ignore failing tests - fix them
- ❌ Don't use sync functions in async context
- ❌ Don't hardcode values that should be config
- ❌ Don't catch all exceptions - be specific
