# zshenv — ZSH Environment Installer

Automated, non-interactive installer for ZSH + Oh My Zsh + Atuin on Ubuntu/Debian systems. Multi-user capable, idempotent, with backup and rollback.

The root `VERSION` file is the single source of truth; `CHANGELOG.md` tracks SemVer changes.

## Features

- Fully non-interactive installation — safe for automation, CI, Docker
- Multi-user: `--user alice,bob` or `--all` for all UID >= 1000 users
- Idempotent: safe to re-run, skips already-installed components
- Oh My Zsh with `fino-time` theme
- Pre-installed plugins: `zsh-autosuggestions` + `zsh-syntax-highlighting`
- Atuin for shell history sync and fuzzy search
- Auto-update enabled (every 13 days)
- Case-insensitive completion, arrow-key tab navigation
- Backup of existing `.zshrc` on every run
- Auto-generated rollback script

---

## Install

Run on each Ubuntu/Debian host as `root`.

**Quick install from GitHub:**

```bash
bash -c 'set -euo pipefail; tmp="$(mktemp -d)"; trap "rm -rf \"$tmp\"" EXIT; curl -fsSL https://github.com/ruhanirabin/zshenv/archive/refs/heads/main.tar.gz | tar -xz -C "$tmp" --strip-components=1; cd "$tmp"; chmod +x install.sh; ./install.sh'
```

**For a specific user:**

```bash
bash -c 'set -euo pipefail; tmp="$(mktemp -d)"; trap "rm -rf \"$tmp\"" EXIT; curl -fsSL https://github.com/ruhanirabin/zshenv/archive/refs/heads/main.tar.gz | tar -xz -C "$tmp" --strip-components=1; cd "$tmp"; chmod +x install.sh; ./install.sh --user alice'
```

**From a local checkout:**

```bash
chmod +x install.sh
./install.sh
```

**Dry run (preview only):**

```bash
./install.sh --dry-run
```

---

## Usage

```bash
# Install for current user (or $SUDO_USER when run via sudo)
sudo ./install.sh

# Install for specific user(s)
sudo ./install.sh --user alice
sudo ./install.sh --user alice,bob

# Install for all non-system users (UID >= 1000)
sudo ./install.sh --all

# Preview without making changes
sudo ./install.sh --dry-run

# Repair Atuin: full cleanup + reinstall (fixes delays/corruption)
sudo ./install.sh --repair-atuin
sudo ./install.sh --repair-atuin --user alice

# Show version
./bin/zshenv-install version
```

---

## What Gets Installed

| Component | Details |
|-----------|---------|
| ZSH | Package: `zsh` (via apt) |
| Default shell | `chsh` to `/usr/bin/zsh` (added to `/etc/shells`) |
| Oh My Zsh | Non-interactive install (`RUNZSH=no CHSH=no --unattended`) |
| Theme | `jonathan` (default) or `fino-time` (selectable at install) |
| Plugins | `git`, `common-aliases`, `zsh-autosuggestions`, `zsh-syntax-highlighting` |
| Atuin | Non-interactive install (`--non-interactive`) |
| .zshrc | Full config with theme, plugins, completion, aliases, Atuin init |

---

## .zshrc Configuration

The installer writes a complete `.zshrc` with these settings:

```bash
ZSH_THEME="jonathan"      # or fino-time (selectable at install)
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git common-aliases zsh-autosuggestions zsh-syntax-highlighting)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
```

Plus Atuin init and personal aliases (`zshconfig`, `ohmyzsh`).

---

## Resource Usage Reporting

The installer includes a commented-out `REPORTTIME` + `TIMEFMT` section in `.zshrc`.
When uncommented, Zsh automatically prints resource usage for any command that runs
longer than the specified threshold:

```bash
# Uncomment these lines in ~/.zshrc to enable:
REPORTTIME=5
TIMEFMT='%J  %U user, %S system, %P cpu, %M maxmem, %*E total'
```

**Example output** (when `sleep 6` runs with `REPORTTIME=5`):

```
sleep 6  0.00 user, 0.00 system, 0% cpu, 1152 maxmem, 6.003 total
```

**Format specifiers:**

| Spec | Meaning |
|------|---------|
| `%J` | command name + arguments |
| `%U` | user CPU time (seconds) |
| `%S` | system/kernel CPU time (seconds) |
| `%P` | CPU percentage used |
| `%M` | maximum resident set size (KB) |
| `%*E` | wall clock elapsed time (seconds) |

**Use cases:**
- `REPORTTIME=0` — report every command
- `REPORTTIME=5` — only report commands taking > 5s (recommended)
- Debug slow pipelines, spot memory hogs, profile build steps

---

## Backup & Rollback

Every run creates:

- **Backup:** `/root/.zshenv-backups/<timestamp>/<user>_zshrc_<timestamp>.bak`
- **Rollback script:** `/root/.zshenv-backups/<timestamp>/rollback.sh`

To undo all changes:

```bash
sudo bash /root/.zshenv-backups/<timestamp>/rollback.sh
```

The rollback script:
- Restores the original default shell
- Restores the backed-up `.zshrc`
- OMZ/Atuin removal lines are commented out (safe by default — uncomment to fully remove)

---

## Validation

After installation, the script verifies:

- `.zshrc` exists and passes `zsh -n` syntax check
- `.oh-my-zsh` directory exists
- Both plugins are cloned
- Atuin binary is present
- Default shell is set to zsh

---

## Dependency Order

The installer runs steps in this exact order:

1. **Distro check** — Ubuntu/Debian compatibility
2. **Install ZSH** — `apt-get install -y zsh`
3. **Set default shell** — add to `/etc/shells`, then `chsh`
4. **Install Oh My Zsh** — must come before plugins (defines `$ZSH_CUSTOM`)
5. **Clone plugins** — into `$ZSH_CUSTOM/plugins/`
6. **Write .zshrc** — with all configuration
7. **Install Atuin** — with `--non-interactive`
8. **Validate** — syntax, dirs, shell
9. **Generate rollback** — backup + rollback script

---

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success (all users processed) |
| `1` | One or more users failed |

---

## Troubleshooting

**"Unknown option" error**

Check available options: `./install.sh --help`

**ZSH not becoming default shell**

```bash
grep zsh /etc/shells         # zsh must be listed
getent passwd <user> | cut -d: -f7   # should show /usr/bin/zsh
```

**Oh My Zsh install fails**

Ensure `git` and `curl` are installed:
```bash
apt-get install -y git curl
```

**Atuin not found after install**

```bash
ls -la ~/.atuin/bin/atuin
~/.atuin/bin/atuin --version
```

**Atuin causing 2-4s command delay or history not recording**

Full nuclear repair (backs up data first, then clean reinstall):

```bash
sudo ./install.sh --repair-atuin
sudo ./install.sh --repair-atuin --user alice
```

Manual rollback of a specific repair backup:

```bash
ls /root/.zshenv-backups/<timestamp>/<user>_atuin_<timestamp>/
cp -a /root/.zshenv-backups/<timestamp>/<user>_atuin_<timestamp>/.atuin ~/.atuin
```

**Plugins not loading**

```bash
ls ~/.oh-my-zsh/custom/plugins/
# Should show: zsh-autosuggestions  zsh-syntax-highlighting
```

**Syntax errors in .zshrc**

```bash
zsh -n ~/.zshrc
# Fix any reported errors manually
```

---

## File Layout

| File | Purpose |
|------|---------|
| `bin/zshenv-install` | Main installer script |
| `install.sh` | Bootstrap wrapper (validates, then runs main script) |
| `VERSION` | Single source of truth for version (SemVer) |
| `CHANGELOG.md` | Version history |
| `README.md` | This file |
| `config/zshrc.example` | Template for custom .zshrc additions |
| `AGENTS.md` | AI agent instructions |
| `LICENSE` | MIT License |
| `REUSE.toml` | SPDX license annotations |

---

## License

MIT License. See [LICENSE](LICENSE) for details.
