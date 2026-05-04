# AGENTS.md

Concise source of truth for AI agents working on this repo.

## Project

zshenv is a Bash-based automated installer for ZSH + Oh My Zsh + Atuin on Ubuntu/Debian systems. Multi-user capable, idempotent, non-interactive. Supports backup and rollback.

## Versioning

- Semantic Versioning only: `MAJOR.MINOR.PATCH`.
- Root `VERSION` is the single source of truth.
- Scripts read version from `../VERSION` at runtime.
- Any behavior, installer, script, docs, or compatibility change must bump `VERSION`.
- Update `CHANGELOG.md` in the same change as `VERSION`.
- Update `README.md` when user-facing commands, files, install behaviour, errors, or defaults change.

## GitHub Sync

- This repository is public on GitHub; keep `main` synchronised after completed version changes unless the user explicitly says not to push.
- Before committing a version change, verify `VERSION`, `CHANGELOG.md`, and any required `README.md` updates are included.
- Use Conventional Commit messages: `feat:`, `fix:`, `docs:`, `chore:`.
- After a successful commit, push the current branch to `origin`.

## Naming

- Canonical prefix: `zshenv-`.
- Main command: `bin/zshenv-install`.
- Bootstrap installer: `install.sh`.

## Safety

- Always non-interactive (supports `--non-interactive` for downstream automation).
- Backup existing `.zshrc` before overwriting.
- Generate rollback script on every run.
- Idempotent: safe to re-run, skips already-installed components.
- Multi-user: `--user alice,bob` or `--all` for UID >= 1000.

## Validation

Run before handoff:

```bash
bash -n install.sh
bash -n bin/zshenv-install
bin/zshenv-install version
./install.sh --dry-run
```

## Dependency Order (internal)

0. Check required dependencies (git, curl — prompt to install if missing)
1. Check distro compatibility
2. Install ZSH
3. Set ZSH as default shell (add to /etc/shells first)
4. Install Oh My Zsh (must come before plugins)
5. Clone plugins into $ZSH_CUSTOM/plugins/ (needs OMZ installed)
6. Write .zshrc
7. Install Atuin
8. Validate (.zshrc syntax, all dirs, shell)
9. Generate rollback script
