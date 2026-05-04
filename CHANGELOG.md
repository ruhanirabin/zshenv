# Changelog

All notable changes follow Semantic Versioning.

## [0.5.1] - 2026-05-04

### Added
- Initial release of zshenv automated installer
- Multi-user support: `--user`, `--all`, `--dry-run` modes
- Non-interactive Oh My Zsh install with `--unattended` flag
- Auto-cloning of `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
- Atuin installation with `--non-interactive` skip for setup prompts
- `fino-time` Oh My Zsh theme configured by default
- Auto-update mode enabled (every 13 days)
- Case-insensitive completion and arrow-key tab navigation
- Backup of existing `.zshrc` before every install run
- Auto-generated `rollback.sh` per run (restores shell + .zshrc)
- Validation step: .zshrc syntax check, directory existence, shell verification
- Version read from `VERSION` file (single source of truth)
- `bin/zshenv-install version` command
- `install.sh` bootstrap wrapper for GitHub one-line installs
- `/etc/shells` entry added automatically for `chsh` compatibility
- SPDX license headers on all scripts
