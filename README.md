# Context Engineering Template
Forked from: https://github.com/coleam00/context-engineering-intro

A comprehensive template for getting started with Context Engineering - the discipline of engineering context for AI coding assistants so they have the information necessary to get the job done end to end.

> **Context Engineering is 10x better than prompt engineering and 100x better than vibe coding.**

## 🚀 Quick Start

```bash
# 1. Clone this template
git clone git@github.com:acypert-godaddy/Context-Engineering-Starter.git
cd Context-Engineering-Starter

# 2. Set up your project rules (optional - template provided)
# Edit CLAUDE.md to add your project-specific guidelines

# 3. Add examples (highly recommended)
# Place relevant code examples in the examples/ folder

# 4. Create your initial feature request
# Edit INITIAL.md with your feature requirements

# 5. Generate a comprehensive PRP (Product Requirements Prompt)
# In Claude Code, run:
/generate-prp INITIAL.md

# 6. Execute the PRP to implement your feature
# In Claude Code, run:
/execute-prp PRPs/your-feature-name.md
```

## ♻️ Using in an Existing Repository (Installation Mode)

If you already have a codebase and want to bring Context Engineering workflows to it:

```bash
# From the root of YOUR existing repo (not this template)
curl -O https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/scripts/install_context_engineering.sh
bash install_context_engineering.sh context  # or another folder name

# Copy the command markdown files (one-time)
mkdir -p .claude/commands
curl -o .claude/commands/init-context.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/init-context.md
curl -o .claude/commands/analyze-codebase.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/analyze-codebase.md
curl -o .claude/commands/generate-feature-prp.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/generate-feature-prp.md
curl -o .claude/commands/execute-feature-prp.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/execute-feature-prp.md
curl -o .claude/commands/update-prp.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/update-prp.md

# (Optional) Keep legacy greenfield commands too
curl -o .claude/commands/generate-prp.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/generate-prp.md
curl -o .claude/commands/execute-prp.md https://raw.githubusercontent.com/acypert-godaddy/Context-Engineering-Starter/main/.claude/commands/execute-prp.md
```

Then inside Claude Code:

```
/init-context context/
/analyze-codebase analysis/initial_scan.md
/generate-feature-prp context/INITIAL.md --analysis analysis/initial_scan.md
/execute-feature-prp context/PRPs/<generated>.md
```

### Context Root Folder

All context artifacts for an existing repo live under a **single root folder** (default: `context/`):

```
context/
   PRPs/
      templates/
   examples/
   analysis/         # codebase scan outputs
   research/         # external research notes
   docs/             # imported reference docs
   scratch/          # ephemeral working notes
   INITIAL.md        # feature request or enhancement spec
   context_manifest.yaml
```

Benefits:

- Isolation from production code
- Portable (can archive or diff context separately)
- Easy to onboard new contributors (read manifest first)

### Feature Modification Workflow (Existing Project)

1. `/init-context` (one-time)
2. Write or update `context/INITIAL.md` with the enhancement request
3. `/analyze-codebase analysis/<feature>_scan.md`
4. `/generate-feature-prp context/INITIAL.md --analysis analysis/<feature>_scan.md`
5. Review & refine PRP (optionally `/update-prp` if code drift occurs)
6. `/execute-feature-prp context/PRPs/<feature>.md`
7. Merge / deploy after validation gates pass

### When to Use Greenfield vs Feature Mode

| Situation                    | Command Set                                                            |
| ---------------------------- | ---------------------------------------------------------------------- |
| New repository from scratch  | `/generate-prp` → `/execute-prp`                                       |
| Enhancement to existing code | `/analyze-codebase` → `/generate-feature-prp` → `/execute-feature-prp` |
| PRP revision after refactor  | `/update-prp`                                                          |

### PRP Differences (Existing vs Greenfield)

### Stack Manifest (Optional but Powerful)

You can define a project stack contract in `context/stack_manifest.json` so commands auto-insert proper validation gates.

Example (TypeScript only):

```json
{
  "version": 1,
  "name": "my-project",
  "languages": [
    {
      "id": "typescript",
      "role": "core-app",
      "srcDir": "src",
      "packageManager": "npm"
    }
  ],
  "runtime": { "node": "20.x" },
  "build": {
    "install": "npm install",
    "build": "npm run build",
    "dev": "npm run dev"
  },
  "quality": {
    "lint": [{ "name": "eslint", "cmd": "npm run lint" }],
    "typeCheck": [{ "name": "tsc", "cmd": "npx tsc --noEmit" }],
    "tests": { "unit": { "cmd": "npm test" }, "coverageMinimum": 80 }
  }
}
```

Yarn Workspaces Variant:

```json
{
  "version": 1,
  "monorepo": {
    "workspaces": true,
    "packageManager": "yarn",
    "defaultPackage": "core-app",
    "packagesDirPatterns": ["packages/*"]
  },
  "packages": [
    {
      "name": "core-app",
      "location": "packages/core-app",
      "lang": "typescript"
    },
    { "name": "ui", "location": "packages/ui", "lang": "typescript" }
  ],
  "tools": {
    "commandsMap": { "lintAll": "yarn workspaces foreach -pt run lint" }
  }
}
```

Benefits:

- Eliminates guessing of commands in PRPs
- Enables automated drift detection (declared vs actual tools)
- Centralizes stack & quality gates for contributors and AI

If present, `/analyze-codebase` and `/generate-feature-prp` will read it and inject appropriate lint/test/type-check steps.

Add new tools? Update the manifest first, then regenerate or update the PRP.

### Monorepo / Multi-Package Support

Declare workspaces and packages in `context/stack_manifest.json`:

```json
{
  "monorepo": {
    "workspaces": true,
    "defaultPackage": "core-app",
    "packagesDirPatterns": ["packages/*"]
  },
  "packages": [
    {
      "name": "core-app",
      "location": "packages/core-app",
      "lang": "typescript"
    },
    { "name": "ui", "location": "packages/ui", "lang": "typescript" }
  ]
}
```

Workflow examples:

```bash
/analyze-codebase analysis/core_scan.md --package core-app
/generate-feature-prp context/INITIAL.md --analysis analysis/core_scan.md --package core-app
```

The commands will:

- Scope tree & pattern extraction to selected package
- Inject that package's specific lint/test/type commands
- Flag cross-package impacts (e.g., exported API changes consumed by other packages)

If a feature touches multiple packages: run analysis per package or broaden scope (omit `--package`) then clarify impact matrix by package.

- Adds Change Impact Matrix
- Includes regression safeguards & rollback plan
- Focuses on deltas instead of only net-new files

---

## 📚 Table of Contents

- [What is Context Engineering?](#what-is-context-engineering)
- [Template Structure](#template-structure)
- [Step-by-Step Guide](#step-by-step-guide)
- [Writing Effective INITIAL.md Files](#writing-effective-initialmd-files)
- [The PRP Workflow](#the-prp-workflow)
- [Using Examples Effectively](#using-examples-effectively)
- [Best Practices](#best-practices)

## What is Context Engineering?

Context Engineering represents a paradigm shift from traditional prompt engineering:

### Prompt Engineering vs Context Engineering

**Prompt Engineering:**

- Focuses on clever wording and specific phrasing
- Limited to how you phrase a task
- Like giving someone a sticky note

**Context Engineering:**

- A complete system for providing comprehensive context
- Includes documentation, examples, rules, patterns, and validation
- Like writing a full screenplay with all the details

### Why Context Engineering Matters

1. **Reduces AI Failures**: Most agent failures aren't model failures - they're context failures
2. **Ensures Consistency**: AI follows your project patterns and conventions
3. **Enables Complex Features**: AI can handle multi-step implementations with proper context
4. **Self-Correcting**: Validation loops allow AI to fix its own mistakes

## Template Structure

```
context-engineering-starter/
├── .claude/
│   ├── commands/
│   │   ├── generate-prp.md    # Generates comprehensive PRPs
│   │   └── execute-prp.md     # Executes PRPs to implement features
│   └── settings.local.json    # Claude Code permissions
├── PRPs/
│   ├── templates/
│   │   └── prp_base.md       # Base template for PRPs
│   └── EXAMPLE_multi_agent_prp.md  # Example of a complete PRP
├── examples/                  # Your code examples (critical!)
├── CLAUDE.md                 # Global rules for AI assistant
├── INITIAL.md               # Template for feature requests
├── INITIAL_EXAMPLE.md       # Example feature request
└── README.md                # This file
 scripts/
    install_context_engineering.sh  # Bootstrap script for existing repos
```

This template doesn't focus on RAG and tools with context engineering because I have a LOT more in store for that soon. ;)

## Step-by-Step Guide

### 1. Set Up Global Rules (CLAUDE.md)

The `CLAUDE.md` file contains project-wide rules that the AI assistant will follow in every conversation. The template includes:

- **Project awareness**: Reading planning docs, checking tasks
- **Code structure**: File size limits, module organization
- **Testing requirements**: Unit test patterns, coverage expectations
- **Style conventions**: Language preferences, formatting rules
- **Documentation standards**: Docstring formats, commenting practices

**You can use the provided template as-is or customize it for your project.**

### 2. Create Your Initial Feature Request

Edit `INITIAL.md` to describe what you want to build:

```markdown
## FEATURE:

[Describe what you want to build - be specific about functionality and requirements]

## EXAMPLES:

[List any example files in the examples/ folder and explain how they should be used]

## DOCUMENTATION:

[Include links to relevant documentation, APIs, or MCP server resources]

## OTHER CONSIDERATIONS:

[Mention any gotchas, specific requirements, or things AI assistants commonly miss]
```

**See `INITIAL_EXAMPLE.md` for a complete example.**

### 3. Generate the PRP

PRPs (Product Requirements Prompts) are comprehensive implementation blueprints that include:

- Complete context and documentation
- Implementation steps with validation
- Error handling patterns
- Test requirements

They are similar to PRDs (Product Requirements Documents) but are crafted more specifically to instruct an AI coding assistant.

Run in Claude Code:

```bash
/generate-prp INITIAL.md
```

**Note:** The slash commands are custom commands defined in `.claude/commands/`. You can view their implementation:

- `.claude/commands/generate-prp.md` - See how it researches and creates PRPs
- `.claude/commands/execute-prp.md` - See how it implements features from PRPs

The `$ARGUMENTS` variable in these commands receives whatever you pass after the command name (e.g., `INITIAL.md` or `PRPs/your-feature.md`).

This command will:

1. Read your feature request
2. Research the codebase for patterns
3. Search for relevant documentation
4. Create a comprehensive PRP in `PRPs/your-feature-name.md`

### 4. Execute the PRP

Once generated, execute the PRP to implement your feature:

```bash
/execute-prp PRPs/your-feature-name.md
```

The AI coding assistant will:

1. Read all context from the PRP
2. Create a detailed implementation plan
3. Execute each step with validation
4. Run tests and fix any issues
5. Ensure all success criteria are met

## Writing Effective INITIAL.md Files

### Key Sections Explained

**FEATURE**: Be specific and comprehensive

- ❌ "Build a web scraper"
- ✅ "Build an async web scraper using BeautifulSoup that extracts product data from e-commerce sites, handles rate limiting, and stores results in PostgreSQL"

**EXAMPLES**: Leverage the examples/ folder

- Place relevant code patterns in `examples/`
- Reference specific files and patterns to follow
- Explain what aspects should be mimicked

**DOCUMENTATION**: Include all relevant resources

- API documentation URLs
- Library guides
- MCP server documentation
- Database schemas

**OTHER CONSIDERATIONS**: Capture important details

- Authentication requirements
- Rate limits or quotas
- Common pitfalls
- Performance requirements

## The PRP Workflow

### How /generate-prp Works

The command follows this process:

1. **Research Phase**

   - Analyzes your codebase for patterns
   - Searches for similar implementations
   - Identifies conventions to follow

2. **Documentation Gathering**

   - Fetches relevant API docs
   - Includes library documentation
   - Adds gotchas and quirks

3. **Blueprint Creation**

   - Creates step-by-step implementation plan
   - Includes validation gates
   - Adds test requirements

4. **Quality Check**
   - Scores confidence level (1-10)
   - Ensures all context is included

### How /execute-prp Works

1. **Load Context**: Reads the entire PRP
2. **Plan**: Creates detailed task list using TodoWrite
3. **Execute**: Implements each component
4. **Validate**: Runs tests and linting
5. **Iterate**: Fixes any issues found
6. **Complete**: Ensures all requirements met

See `PRPs/EXAMPLE_multi_agent_prp.md` for a complete example of what gets generated.

## Using Examples Effectively

The `examples/` folder is **critical** for success. AI coding assistants perform much better when they can see patterns to follow.

### What to Include in Examples

1. **Code Structure Patterns**

   - How you organize modules
   - Import conventions
   - Class/function patterns

2. **Testing Patterns**

   - Test file structure
   - Mocking approaches
   - Assertion styles

3. **Integration Patterns**

   - API client implementations
   - Database connections
   - Authentication flows

4. **CLI Patterns**
   - Argument parsing
   - Output formatting
   - Error handling

### Example Structure

```
examples/
├── README.md           # Explains what each example demonstrates
├── cli.py             # CLI implementation pattern
├── agent/             # Agent architecture patterns
│   ├── agent.py      # Agent creation pattern
│   ├── tools.py      # Tool implementation pattern
│   └── providers.py  # Multi-provider pattern
└── tests/            # Testing patterns
    ├── test_agent.py # Unit test patterns
    └── conftest.py   # Pytest configuration
```

## Best Practices

### 1. Be Explicit in INITIAL.md

- Don't assume the AI knows your preferences
- Include specific requirements and constraints
- Reference examples liberally

### 2. Provide Comprehensive Examples

- More examples = better implementations
- Show both what to do AND what not to do
- Include error handling patterns

### 3. Use Validation Gates

- PRPs include test commands that must pass
- AI will iterate until all validations succeed
- This ensures working code on first try

### 4. Leverage Documentation

- Include official API docs
- Add MCP server resources
- Reference specific documentation sections

### 5. Customize CLAUDE.md

- Add your conventions
- Include project-specific rules
- Define coding standards

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)
