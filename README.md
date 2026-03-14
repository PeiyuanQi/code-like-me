# work-like-me

Shared Cursor rules, Claude skills, and Claude plugins that encode how you work — install them into your user profile or individual projects so every AI assistant follows the same conventions.

## Repository layout

```
.cursor/rules/          Cursor rules (Node/nvm, Python/uv, Flutter/fvm)
wlm/                    Claude plugin package ("work-like-me")
  plugins/swe/            SWE plugin — skills for software engineering workflows
    skills/
      onboard-as-new-hire/  Agent self-onboarding: discovers team tools & org structure
install.sh              Installer — copies rules/config to your user profile
```

### Cursor rules

| Rule | File | Description |
|------|------|-------------|
| Node 24 via nvm | `node-nvm-24.mdc` | Always `nvm use 24` before npm/yarn/pnpm |
| Python via uv | `python-use-uv.mdc` | Always use `uv` instead of raw pip/python |
| Flutter via fvm | `flutter-use-fvm.mdc` | Always use `fvm flutter` / `fvm dart` |

### Claude plugin — `wlm`

The `wlm/` directory is a Claude plugin package. It currently ships one plugin:

- **swe** — Software Engineer skills
  - **onboard-as-new-hire** — Guides the agent through discovering communication tools, office suites, and org structure, then persists findings into a `memory/` tree.

## Quick start

### 1. Install rules to your user profile

```bash
chmod +x install.sh
./install.sh
```

This copies `.cursor/` into `~/.cursor/`, merging with existing config without overwriting your files.

### 2. Copy rules into a specific project

To install rules into a target project (so that project gets the same conventions locally), pass the project path:

```bash
./install.sh --rules-to /absolute/path/to/project
```

This creates or updates `<project>/.cursor/rules/`.

### 3. Install the Claude plugin

To install the `wlm` Claude plugin package into a target project:

```bash
./install.sh --plugin-to /absolute/path/to/project
```

This copies `wlm/` into `<project>/wlm/` so Claude Code can discover it.

### Combined

```bash
./install.sh --rules-to /Users/you/projects/my-app --plugin-to /Users/you/projects/my-app
```

## Requirements

- Bash
- `rsync` (preferred) — falls back to `cp` if unavailable

## Help

```bash
./install.sh --help
```

## License

Use and adapt as you like.
