---
name: git-start-work
description: Use when user wants to start new code work, create a new feature branch, begin coding on a fresh branch, or switch to latest main before starting work.
---

# Git Start Work

Start new code work from the latest main branch. This skill ensures your local repository is up-to-date and creates a properly named feature branch.

## When to Use

- User says: "start new work", "start new feature", "begin coding", "new branch"
- User wants to work on a bug fix or new feature
- User needs to refresh their branch from latest main

## Branch Naming Convention

Use these prefixes based on the type of work:
- `feat/` - New features (e.g., `feat/user-authentication`)
- `fix/` - Bug fixes (e.g., `fix/login-validation`)
- `docs/` - Documentation changes
- `refactor/` - Code restructuring
- `test/` - Adding or updating tests
- `chore/` - Maintenance tasks

## Step 1: Check Repository Exists

Check if the repository exists locally:
```bash
ls -la /path/to/repo/.git
```

If not exists, clone from remote:
```bash
git clone <remote-url>
cd repo-name
```

## Step 2: Fetch Latest Changes

```bash
git fetch origin
```

## Step 3: Determine Main Branch

Check what the default branch is called:
```bash
git remote show origin | grep "HEAD branch"
```

Common names: `main`, `master`, `develop`

## Step 4: Checkout Latest Main

```bash
git checkout origin/<main-branch> -b <main-branch>
```

## Step 5: Create New Branch

If user specified a branch name:
```bash
git checkout -b <prefix>/<description>
```

If user didn't specify, ask them:
- What type of work? (feature/fix/docs/refactor)
- What is the short description?

Example:
```bash
git checkout -b feat/user-login
```

## Step 6: Confirm

Report:
- Branch name created
- Current branch
- Any relevant next steps
