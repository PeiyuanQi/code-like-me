#!/usr/bin/env bash
#
# install.sh — Copy .claude and .cursor config from this repo to user profile,
#             and optionally copy skills to a target project directory.
#
# Usage:
#   ./install.sh                    # install to ~/.claude and ~/.cursor only
#   ./install.sh --skills-to /path  # also copy skills to project at /path
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="${SCRIPT_DIR}/.claude"
CURSOR_SRC="${SCRIPT_DIR}/.cursor"
CLAUDE_HOME="${HOME}/.claude"
CURSOR_HOME="${HOME}/.cursor"
SKILLS_TO=""

# -----------------------------------------------------------------------------
# Ask user to confirm before creating a directory. Returns 0 if dir exists or
# user confirmed create; 1 if user declined.
# -----------------------------------------------------------------------------
confirm_create_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    return 0
  fi
  echo "Directory does not exist: $dir"
  read -r -p "Create it? [y/N] " reply
  if [[ "$reply" =~ ^[yY]$ ]]; then
    mkdir -p "$dir"
    return 0
  fi
  return 1
}

# -----------------------------------------------------------------------------
# Parse optional --skills-to <path>
# -----------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills-to)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --skills-to requires a path argument." >&2
        exit 1
      fi
      SKILLS_TO="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--skills-to <absolute-project-path>]"
      echo ""
      echo "  (no args)        Copy .claude and .cursor to user profile only."
      echo "  --skills-to PATH Copy skills into project at PATH (must be absolute)."
      echo "  -h, --help       Show this help."
      exit 0
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      echo "Use --help for usage." >&2
      exit 1
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Validate --skills-to is an absolute path
# -----------------------------------------------------------------------------
if [[ -n "$SKILLS_TO" ]]; then
  if [[ "$SKILLS_TO" != /* ]]; then
    echo "Error: Project path must be a complete system path (absolute). Got: $SKILLS_TO" >&2
    exit 1
  fi
  # Existence of SKILLS_TO is checked later; we may ask to create it
fi

# -----------------------------------------------------------------------------
# Copy .claude to user profile
# -----------------------------------------------------------------------------
if [[ ! -d "$CLAUDE_SRC" ]]; then
  echo "Warning: No .claude directory in repo, skipping." >&2
else
  echo "Installing .claude to ${CLAUDE_HOME} ..."
  if confirm_create_dir "$CLAUDE_HOME"; then
    rsync -a --ignore-existing "${CLAUDE_SRC}/" "${CLAUDE_HOME}/" 2>/dev/null || {
      cp -R "${CLAUDE_SRC}"/* "${CLAUDE_HOME}/" 2>/dev/null || true
    }
    echo "  done."
  else
    echo "  Skipping .claude (directory not created)."
  fi
fi

# -----------------------------------------------------------------------------
# Copy .cursor to user profile
# -----------------------------------------------------------------------------
if [[ ! -d "$CURSOR_SRC" ]]; then
  echo "Warning: No .cursor directory in repo, skipping." >&2
else
  echo "Installing .cursor to ${CURSOR_HOME} ..."
  if confirm_create_dir "$CURSOR_HOME"; then
    rsync -a --ignore-existing "${CURSOR_SRC}/" "${CURSOR_HOME}/" 2>/dev/null || {
      cp -R "${CURSOR_SRC}"/* "${CURSOR_HOME}/" 2>/dev/null || true
    }
    echo "  done."
  else
    echo "  Skipping .cursor (directory not created)."
  fi
fi

# -----------------------------------------------------------------------------
# Optional: copy skills to target project
# -----------------------------------------------------------------------------
if [[ -n "$SKILLS_TO" ]]; then
  if ! confirm_create_dir "$SKILLS_TO"; then
    echo "Skipping skills copy (project directory not created)."
  else
    echo "Copying skills to project: ${SKILLS_TO} ..."
    if [[ -d "${CLAUDE_SRC}/skills" ]]; then
      if confirm_create_dir "${SKILLS_TO}/.claude/skills"; then
        rsync -a "${CLAUDE_SRC}/skills/" "${SKILLS_TO}/.claude/skills/" 2>/dev/null || {
          cp -R "${CLAUDE_SRC}/skills"/* "${SKILLS_TO}/.claude/skills/" 2>/dev/null || true
        }
        echo "  .claude/skills installed."
      else
        echo "  Skipping .claude/skills (directory not created)."
      fi
    fi
    if [[ -d "${CURSOR_SRC}/skills" ]]; then
      if confirm_create_dir "${SKILLS_TO}/.cursor/skills"; then
        rsync -a "${CURSOR_SRC}/skills/" "${SKILLS_TO}/.cursor/skills/" 2>/dev/null || {
          cp -R "${CURSOR_SRC}/skills"/* "${SKILLS_TO}/.cursor/skills/" 2>/dev/null || true
        }
        echo "  .cursor/skills installed."
      else
        echo "  Skipping .cursor/skills (directory not created)."
      fi
    fi
    if [[ ! -d "${CLAUDE_SRC}/skills" ]] && [[ ! -d "${CURSOR_SRC}/skills" ]]; then
      echo "  (no skills in this repo to copy)"
    fi
    echo "  done."
  fi
fi

echo "Install complete."
