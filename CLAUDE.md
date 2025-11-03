### 🔄 Project Awareness & Context

- **Always read `PLANNING.md` (if present)** at the start of a new conversation to understand architecture, goals, style, and constraints.
- **Check `TASK.md` / task tracker** before starting a new task. If the task isn’t listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** already established in the codebase.
- **Activate the appropriate runtime environment** (venv, node version via nvm, Java toolchain, container, etc.) before running commands.

### 🧱 Code Structure & Modularity

- **Keep files focused** (soft guideline: avoid >500 LOC per file/module; split if growing complex).
- **Group code by responsibility or bounded context** (feature modules, layers, packages, services).
- For agent patterns, typical separation:
  - `agent.(py|ts|go|java)` / `Agent` class: core orchestration
  - `tools.*` / `tooling/`: tool & integration adapters
  - `prompts.*` / `prompts/`: system & behavioral prompts
- **Maintain consistent import / dependency patterns** (avoid cyclic dependencies, keep layering clear).
- **Use existing configuration patterns** (env files, config objects, DI containers) instead of inventing new ones.

### 🧪 Testing & Reliability

- **Always create or extend unit tests for new features** (functions, classes, endpoints, workflows, etc.).
- **When logic changes**, update or add regression tests.
- **Tests should live in a dedicated test directory** (e.g., `tests/`, `__tests__/`, `src/test/java/`).
  - Include at least:
    - 1 expected / happy path case
    - 1 edge / boundary case
    - 1 failure / error-handling case
- Prefer deterministic, isolated tests (mock external I/O where appropriate) + add at least one integration test for cross-module flows.

### ✅ Task Completion

- **Mark completed tasks in `TASK.md`** immediately after finishing them.
- Add new sub-tasks or TODOs discovered during development to `TASK.md` under a “Discovered During Work” section.

### 📎 Style & Conventions

- **Follow existing project conventions** (language style guides, lint rules, formatter configuration).
- Use automated formatters / linters (e.g., `eslint`, `prettier`, `ruff`, `black`, `golangci-lint`, `ktlint`, `spotless`) as configured.
- Use type systems / annotations where supported (TypeScript types, Java interfaces, Go types, Python type hints, etc.).
- Provide **API / public interface documentation** (docstrings, JSDoc, Javadoc, Go comments) consistent with ecosystem norms.
- Prefer explicit naming, pure functions where practical, and small cohesive modules.

### 📚 Documentation & Explainability

- **Update top-level docs** (README / architecture notes) when features, dependencies, or setup steps change.
- **Explain non-obvious logic** with concise comments focused on intent & trade-offs.
- For complex flows, add a short rationale block (e.g., `// Reason:` / `# Rationale:`) near the implementation.

### 🧠 AI Behavior Rules

- **Never assume missing context**—ask clarifying questions if ambiguity blocks correctness.
- **Never hallucinate libraries, frameworks, or functions**—only use dependencies present or approved.
- **Verify file paths, modules, and symbols** before referencing or modifying.
- **Do not remove or rewrite large sections** unless explicitly part of the accepted task scope.
- **Surface risks early** (e.g., potential breaking changes, migration needs, backward compatibility concerns).
