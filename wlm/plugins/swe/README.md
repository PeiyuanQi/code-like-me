# New Hire Onboarding Plugin

A Claude Code plugin for onboarding new team members by discovering communication tools, office suites, and organizational structure.

## Features

- Discover team communication tools (Slack, Teams, Google Chat, Discord, etc.)
- Identify office suites (Microsoft Office, Google Workspace, Feishu/Lark)
- Document organizational structure and team members
- Manage memory files with time-based organization
- Handle conflict resolution for outdated information

## Installation

This plugin can be installed by placing it in your Claude Code plugins directory.

## Skills

### new-hire-onboarding

Onboard a new hire by discovering communication tools, office suites, and organizational structure.

**Triggers:**
- "onboard the new hire"
- "new employee onboarding"
- "what tools does our team use"
- "discover communication tools"
- "company software"
- "office suite"
- "team tools"

## Memory Structure

The plugin creates and manages memory files organized as:

```
memory/
├── corps/           # Company-level information
│   └── tools/       # Communication and office tools
├── projects/        # Project-specific information
│   └── [project]/  # Per-project folders
└── teams/           # Team and organizational information
    └── [team]/     # Per-team folders
```

Each folder uses time-based subfolders (YYYY-MM format) for tracking when information was added.

## Usage

Simply ask Claude to help onboard a new team member, and the skill will:

1. Ask discovery questions about communication tools and office suites
2. Document findings in memory files
3. Provide a summary of discovered tools and team structure
4. Handle conflict resolution when information changes
