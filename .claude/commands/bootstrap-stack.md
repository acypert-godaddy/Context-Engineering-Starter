---
description: Infer project stack & generate or enrich context/stack_manifest.json
argument-hint: [optional-output-path]
---

# Bootstrap Stack Manifest

Infer the repository's technology stack and produce (or merge into) a `stack_manifest.json` inside the context root.

## Usage

```
/bootstrap-stack                # writes to context/stack_manifest.json (or existing root)
/bootstrap-stack context/stack_manifest.json  # explicit path
```

Optional flags (append after the path):

```
--force          # overwrite existing manifest instead of merging
--package <name> # focus inference on a specific package (monorepo)
--no-scripts     # do not try to infer build/test scripts, only languages
```

## Goals

1. Detect primary languages & their roles
2. Identify package / module boundaries (monorepo vs single package)
3. Infer build, lint, test, type-check commands from existing config (package.json, pyproject.toml, etc.)
4. Record quality gates in a normalized structure
5. Avoid overwriting user customizations unless `--force` provided
6. Provide actionable drift notes (declared vs inferred differences)

## Detection Heuristics

| Concern      | Heuristic Sources                                                                 |
| ------------ | --------------------------------------------------------------------------------- |
| Monorepo     | root `package.json` with `workspaces`, yarn/npm/pnpm lockfiles, `packages/*` dirs |
| Languages    | File extensions & density (e.g. `.ts`, `.py`, `.go`, `.rb`, `.java`, `.cs`)       |
| TypeScript   | Presence of `tsconfig.json` or `.ts` > `.js` count                                |
| Python       | `pyproject.toml`, `requirements.txt`, `setup.cfg`                                 |
| Build script | `package.json:scripts.build`, or default: `yarn build` / `npm run build`          |
| Dev script   | `scripts.dev`, fallback: `yarn dev` / `npm run dev`                               |
| Lint         | Detect eslint config or script name containing `lint`                             |
| Tests        | `scripts.test`, or presence of `pytest.ini`, `vitest.config.*`, `jest.config.*`   |
| Type-check   | `tsc` in devDependencies or script containing `tsc`                               |

## Manifest Schema Snippet

```jsonc
{
  "version": 1,
  "name": "<inferred-or-existing>",
  "monorepo": { "workspaces": true|false, "packageManager": "yarn|npm|pnpm", "packagesDirPatterns": ["packages/*"] },
  "packages": [
    { "name": "core-app", "location": "packages/core-app", "lang": "typescript" }
  ],
  "languages": [
    { "id": "typescript", "role": "core", "srcDir": "src" }
  ],
  "build": { "install": "yarn install", "build": "yarn build", "dev": "yarn dev" },
  "quality": {
    "lint": [{ "name": "eslint", "cmd": "yarn lint" }],
    "typeCheck": [{ "name": "tsc", "cmd": "yarn tsc --noEmit" }],
    "tests": { "unit": { "cmd": "yarn test" }, "coverageMinimum": 80 }
  },
  "tools": { "commandsMap": {} }
}
```

## Steps

1. Determine `$CONTEXT_ROOT`: prefer explicit user path's parent; else detect `context/` folder; fallback to `.`.
2. If existing `stack_manifest.json` found and no `--force`:
   - Load it into memory for merging
   - Track fields replaced vs appended
3. Gather repository signals:
   - Root & package `package.json` files
   - Lockfiles: `yarn.lock`, `package-lock.json`, `pnpm-lock.yaml`
   - Configs: `tsconfig.json`, `.eslintrc*`, `jest.config.*`, `vitest.config.*`, `pytest.ini`, `pyproject.toml`
4. Infer package manager priority: yarn > pnpm > npm (by lockfile presence)
5. Enumerate packages (if monorepo):
   - Expand `workspaces` globs if in package.json
   - For each package, detect language (dominant extension) & key scripts
6. Build language list (deduplicate by id) and choose roles:
   - First becomes `core`, others `support` unless heuristics (e.g. `ui` name → role `frontend`)
7. Infer quality commands:
   - Lint: prefer explicit script containing `lint`
   - Tests: script containing `test` (exclude `pretest`/`posttest` wrappers) or fallback commands
   - Type-check: detect `tsc` via devDependencies or script
8. Compose new manifest object
9. Merge policy (when not `--force`):
   - Do not delete unknown existing keys
   - For arrays (languages, packages) merge by `id`/`name` (existing wins on conflicts unless inferred entry has missing fields)
   - For nested objects (quality.\*) fill only missing commands
10. Write manifest (pretty JSON) and produce a drift report section listing:

- Added fields
- Updated fields (old → new)
- Skipped (unchanged)

11. Output next-step suggestions: `/generate-feature-prp` referencing inferred quality gates.

## Output Format

```
Bootstrap Stack Manifest
Status: created|merged at <path>

Detected:
- Package manager: yarn
- Monorepo: yes (2 packages)
- Languages: typescript (packages: core-app, ui)
- Lint: yarn lint
- Tests: yarn test
- Type-check: yarn tsc --noEmit

Changes:
- Added build.install
- Added quality.lint[eslint]
- Merged packages[core-app]

Next:
  /analyze-codebase analysis/stack_scan.md --package core-app
  /generate-feature-prp context/INITIAL.md --analysis analysis/stack_scan.md
```

## Safety

- Never remove user-defined custom keys unless `--force`.
- If manifest invalid JSON after merge, abort and show diff with candidate replacement.
- If conflicting package names with different paths, list as conflict and skip changing that entry.

## Completion Criteria

- Manifest file present with at least: version, name, (languages OR packages), quality stub
- Clear drift/change report rendered
- Next step instructions provided

Respond with the completed output.
