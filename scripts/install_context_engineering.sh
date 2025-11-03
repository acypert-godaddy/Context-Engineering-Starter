#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
REPO_DEFAULT="acypert-godaddy/Context-Engineering-Starter"
BRANCH_DEFAULT="main"
CONTEXT_ROOT="context"
REPO="$REPO_DEFAULT"
BRANCH="$BRANCH_DEFAULT"
WITH_COMMANDS=1
UPGRADE=0
QUIET=0
INCLUDE_LEGACY=0

COMMAND_FILES=(
  "init-context.md"
  "analyze-codebase.md"
  "generate-feature-prp.md"
  "execute-feature-prp.md"
  "update-prp.md"
)

LEGACY_COMMAND_FILES=(
  "generate-prp.md"
  "execute-prp.md"
)

usage() {
  cat <<USAGE
Context Engineering bootstrap script

Basic usage:
  curl -fsSL https://raw.githubusercontent.com/${REPO_DEFAULT}/${BRANCH_DEFAULT}/scripts/install_context_engineering.sh | bash

Options (as flags after the script when using curl | bash -s -- <flags>):
  --root <dir>            Context root directory (default: context)
  --repo <owner/repo>     Source repository (default: ${REPO_DEFAULT})
  --branch <branch>       Branch or tag (default: ${BRANCH_DEFAULT})
  --no-commands           Skip downloading .claude command files
  --legacy                Also include legacy greenfield commands (generate/execute-prp)
  --upgrade               Force re-download of command files even if they exist
  --quiet                 Suppress non-error output
  -h, --help              Show this help

Examples:
  # Default install with commands
  curl -fsSL https://raw.githubusercontent.com/${REPO_DEFAULT}/${BRANCH_DEFAULT}/scripts/install_context_engineering.sh | bash

  # Specify a different root directory
  curl -fsSL https://raw.githubusercontent.com/${REPO_DEFAULT}/${BRANCH_DEFAULT}/scripts/install_context_engineering.sh | bash -s -- --root ce

  # Upgrade command definitions later
  bash ${SCRIPT_NAME} --upgrade
USAGE
}

log() { [ "$QUIET" -eq 1 ] || echo "$@"; }
err() { echo "[error] $@" >&2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      CONTEXT_ROOT="$2"; shift 2 ;;
    --repo)
      REPO="$2"; shift 2 ;;
    --branch)
      BRANCH="$2"; shift 2 ;;
    --no-commands)
      WITH_COMMANDS=0; shift ;;
    --legacy)
      INCLUDE_LEGACY=1; shift ;;
    --upgrade)
      UPGRADE=1; shift ;;
    --quiet)
      QUIET=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      err "Unknown argument: $1"; usage; exit 1 ;;
  esac
done

log "[context-engineering] Installing into '$CONTEXT_ROOT' from $REPO@$BRANCH"

if [ -f "$CONTEXT_ROOT" ]; then
  err "'$CONTEXT_ROOT' exists and is a file. Choose a different name."; exit 1
fi

mkdir -p "$CONTEXT_ROOT/PRPs/templates" "$CONTEXT_ROOT/examples" "$CONTEXT_ROOT/analysis" "$CONTEXT_ROOT/research" "$CONTEXT_ROOT/docs" "$CONTEXT_ROOT/scratch"

# Copy base template from local repo if present (supports running inside template itself)
if [ -f "PRPs/templates/prp_base.md" ] && [ ! -f "$CONTEXT_ROOT/PRPs/templates/prp_base.md" ]; then
  cp PRPs/templates/prp_base.md "$CONTEXT_ROOT/PRPs/templates/prp_base.md"
fi

# Create INITIAL stub if missing
if [ ! -f "$CONTEXT_ROOT/INITIAL.md" ]; then
  cat > "$CONTEXT_ROOT/INITIAL.md" <<'EOF'
## FEATURE:

## EXISTING CONTEXT (if modifying):

## INTEGRATION POINTS:

## EXAMPLES TO FOLLOW:

## DOCUMENTATION:

## RISKS / GOTCHAS:

## SUCCESS CRITERIA:
EOF
fi

MANIFEST_JSON="$CONTEXT_ROOT/stack_manifest.json"
if [ ! -f "$MANIFEST_JSON" ]; then
  cat > "$MANIFEST_JSON" <<'EOF'
{
  "version": 1,
  "name": "context-onboarded-project",
  "languages": [],
  "quality": {
    "lint": [],
    "typeCheck": [],
    "tests": {}
  }
}
EOF
fi

YAML_MANIFEST="$CONTEXT_ROOT/context_manifest.yaml"
if [ ! -f "$YAML_MANIFEST" ]; then
  cat > "$YAML_MANIFEST" <<EOF
version: 1
context_root: $CONTEXT_ROOT
generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
sections:
  prps: PRPs/
  examples: examples/
  analysis: analysis/
  research: research/
  docs: docs/
  scratch: scratch/
EOF
fi

download_command_file() {
  local file="$1"
  local targetDir=".claude/commands"
  local targetPath="$targetDir/$file"
  mkdir -p "$targetDir"
  if [ -f "$targetPath" ] && [ $UPGRADE -eq 0 ]; then
    log "[skip] $file exists (use --upgrade to overwrite)"
    return 0
  fi
  local url="https://raw.githubusercontent.com/${REPO}/${BRANCH}/.claude/commands/${file}"
  if curl -fsSL "$url" -o "$targetPath"; then
    log "[ok] $file"
  else
    err "Failed to fetch $url"; return 1
  fi
}

if [ $WITH_COMMANDS -eq 1 ]; then
  log "Downloading command definitions..."
  for f in "${COMMAND_FILES[@]}"; do
    download_command_file "$f"
  done
  if [ $INCLUDE_LEGACY -eq 1 ]; then
    for f in "${LEGACY_COMMAND_FILES[@]}"; do
      download_command_file "$f"
    done
  fi
fi

log "Scaffolding complete. Suggested next steps:"
log "  1. /analyze-codebase analysis/initial_scan.md"
log "  2. /generate-feature-prp $CONTEXT_ROOT/INITIAL.md --analysis analysis/initial_scan.md"
log "  3. /execute-feature-prp context/PRPs/<generated-file>.md"

log "Done."
