#!/usr/bin/env python3
"""Verify memory hierarchy is correctly structured."""

import os
from pathlib import Path

EXPECTED_STRUCTURE = {
    "corps": {
        "tools": None
    },
    "projects": None,
    "teams": {
        "roles": None
    }
}

def verify_structure(base_path: Path, structure: dict, path_parts: list = None) -> list:
    """Recursively verify directory structure. Returns list of errors."""
    path_parts = path_parts or []
    errors = []

    for name, children in structure.items():
        current_path = base_path / name
        current_parts = path_parts + [name]

        if children is None:
            # Expect a directory
            if not current_path.exists():
                errors.append(f"Missing directory: {'/'.join(current_parts)}")
            elif not current_path.is_dir():
                errors.append(f"Expected directory: {'/'.join(current_parts)}")
        else:
            # Recurse
            if current_path.exists():
                errors.extend(verify_structure(current_path, children, current_parts))
            else:
                errors.append(f"Missing directory: {'/'.join(current_parts)}")

    return errors


def find_git_root() -> Path:
    """Find git repository root."""
    try:
        import subprocess
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            return Path(result.stdout.strip())
    except Exception:
        pass
    return Path.cwd()


def find_memory_path() -> Path:
    """Find memory directory - check multiple possible locations."""
    git_root = find_git_root()
    candidates = [
        Path.cwd() / "memory",              # Current working directory
        git_root / "memory",                # Git repository root
        Path.home() / ".wlm" / "memory",   # ~/.wlm/memory
    ]

    for p in candidates:
        if p.exists():
            return p

    # Return first candidate if none exist
    return candidates[0]


def main():
    memory_path = find_memory_path()

    print(f"Checking memory hierarchy at: {memory_path}")
    print()

    if not memory_path.exists():
        print("Memory directory does not exist.")
        print("Creating expected structure...")
        memory_path.mkdir(parents=True, exist_ok=True)

        # Create expected subdirectories
        (memory_path / "corps" / "tools").mkdir(parents=True, exist_ok=True)
        (memory_path / "projects").mkdir(parents=True, exist_ok=True)
        (memory_path / "teams" / "roles").mkdir(parents=True, exist_ok=True)
        print("Created: memory/corps/tools/")
        print("Created: memory/projects/")
        print("Created: memory/teams/roles/")
        print()
        print("Verification passed!")
        return

    errors = verify_structure(memory_path, EXPECTED_STRUCTURE)

    if errors:
        print("Errors found:")
        for e in errors:
            print(f"  - {e}")
        return

    print("Verification passed!")
    print("Structure:")
    for root, dirs, files in sorted(os.walk(memory_path)):
        level = root.replace(str(memory_path), '').count(os.sep)
        indent = '  ' * level
        print(f"{indent}{os.path.basename(root)}/")


if __name__ == "__main__":
    main()
