# Changelog

All notable changes follow Semantic Versioning.

## [0.5.4] - 2026-05-04

### Added
- Comprehensive aliases in .zshrc:
  - Navigation: `..`, `...`, `....`, `-` (cd to previous)
  - Directory: `md` (mkdir -p), `take` (mkdir + cd)
  - Listing: `l` (detailed all), `la` (all incl hidden), `ll` (detailed),
    `lsd` (dirs only), `lt` (newest 20), `ltree` (tree view)
  - Safe ops: `rm`, `cp`, `mv` with `-i` (confirm overwrite)
  - System: `mem` (free -h), `disk` (df -h --total), `myip` (public IP)
  - Search: `grep`, `egrep`, `fgrep` with `--color=auto`
  - Git extras: `glog` (graph log), `gstash` (stash list),
    `gunstage` (reset HEAD), `gclean` (dry-run clean)

## [0.5.3] - 2026-05-04

### Fixed
- Missing `export ZSH="$HOME/.oh-my-zsh"` in .zshrc template — caused
  `no such file or directory: /oh-my-zsh.sh` on fresh installs

## [0.5.2] - 2026-05-04

### Added
- Preflight dependency check for `git` and `curl`
- User prompt to install missing dependencies before proceeding
- Graceful abort if user declines to install required packages

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
