#!/usr/bin/env bash
set -euo pipefail

VERSION="0.1.0"
REPO="acypert-godaddy/Context-Engineering-Starter"
BRANCH="main"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
  cat <<USAGE
contextce v${VERSION} - Context Engineering helper

Usage: contextce <command> [options]

Commands:
  install        Run installer (bootstrap context/) with remote script
  upgrade        Re-run installer with --upgrade
  bootstrap      Alias of install
  version        Print version
  help           Show this help

Examples:
  contextce install --root ce
  contextce upgrade

Installer flags are passed through after '--':
  contextce install -- --root ce --legacy
USAGE
}

run_install() {
  local extra=("$@")
  curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/scripts/install_context_engineering.sh" | bash -s -- "${extra[@]}"
}

cmd=${1:-help}; shift || true

case "$cmd" in
  install|bootstrap)
    run_install "$@" ;;
  upgrade)
    run_install --upgrade "$@" ;;
  version)
    echo "$VERSION" ;;
  help|-h|--help)
    usage ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 1
    ;;
esac
