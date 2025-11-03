#!/usr/bin/env bash
set -euo pipefail

CONTEXT_ROOT=${1:-context}

echo "[context-engineering] Installing into '$CONTEXT_ROOT'"

if [ -f "$CONTEXT_ROOT" ]; then
  echo "ERROR: '$CONTEXT_ROOT' exists and is a file. Choose a different name." >&2
  exit 1
fi

mkdir -p "$CONTEXT_ROOT/PRPs/templates" "$CONTEXT_ROOT/examples" "$CONTEXT_ROOT/analysis" "$CONTEXT_ROOT/research" "$CONTEXT_ROOT/docs" "$CONTEXT_ROOT/scratch"

# Copy base template if available
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

MANIFEST="$CONTEXT_ROOT/context_manifest.yaml"
if [ ! -f "$MANIFEST" ]; then
  cat > "$MANIFEST" <<EOF
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
else
  echo "Manifest exists - leaving untouched"
fi

echo "Scaffolding complete. Suggested next steps:"
echo "  1. /analyze-codebase analysis/initial_scan.md"
echo "  2. /generate-feature-prp $CONTEXT_ROOT/INITIAL.md --analysis analysis/initial_scan.md"
echo "  3. /execute-feature-prp PRPs/<generated-file>.md"
