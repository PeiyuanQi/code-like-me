# code-like-me

Shared Cursor and Claude configuration: rules and skills you can install into your user profile or copy into specific projects.

## Contents

- **`.cursor/rules/`** — Cursor rules (e.g. Node/nvm, Python/uv, Flutter/fvm) applied when you use Cursor.
- **`.claude/skills/`** — Claude skills (e.g. prepare-code-for-commit) for consistent behavior.

## Quick start

1. Clone this repo (or use it as a template).
2. Run the installer:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   This copies `.claude` and `.cursor` into your user profile (`~/.claude` and `~/.cursor`), merging with existing config without overwriting your files.

## Optional: copy skills to a project

To install **only the skills** into a specific project (so that project gets the same skills locally), pass the project path with `--skills-to`. The path must be a **complete system path** (absolute).

```bash
./install.sh --skills-to /Users/you/projects/my-app
```

This creates or updates:

- `<project>/.claude/skills/`
- `<project>/.cursor/skills/` (if this repo has `.cursor/skills`)

Use this when you want a project to use these skills without changing your global profile.

## Requirements

- Bash.
- `rsync` is used when available for safer merging; the script falls back to `cp` if `rsync` is not installed.

## Help

```bash
./install.sh --help
```

## License

Use and adapt as you like.
