# GitHub Repository Setup

## Branch Structure
- `main` / `master` - Production/stable version
- `develop` - Development version (active work)
- `feature/*` - Feature branches

## Releases
Tags should follow semantic versioning: `v1.0.0`, `v1.0.1`, etc.

## CI/CD
GitHub Actions workflow validates:
- Terraform syntax and formatting
- Ansible lint
- Repository structure

## Pull Requests
- Require review from code owner
- Must pass all CI checks
- Reference an issue or ADR when applicable