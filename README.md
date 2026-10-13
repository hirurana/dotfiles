# dotfiles

My whole macOS dev environment: zsh + powerlevel10k, tmux, Neovim, mise/uv, skhd. One clone, one command.

```sh
git clone https://github.com/hirurana/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is idempotent — re-run it any time (e.g. after editing the `Brewfile`). It:

1. Installs Xcode CLT and Homebrew if missing
2. `brew bundle` — every CLI tool + iTerm2, Rectangle, Claude Code ([Brewfile](Brewfile))
3. Installs the MesloLGS NF font that p10k needs
4. Backs up any existing real file to `~/dotfiles-backup-<timestamp>/`, then `stow`s each package into `$HOME`
5. Creates an empty `~/.zshrc.local` for secrets
6. `mise install` (python, node, go, deno, aws-cdk) and `uv tool install poetry`
7. Starts the skhd service and enables the gitleaks pre-commit hook

## After install

Things a script can't (or shouldn't) do — full detail in [docs/macos.md](docs/macos.md):

- [ ] **skhd → Accessibility:** System Settings → Privacy & Security → Accessibility → enable `skhd`. Hotkeys do nothing until you do.
- [ ] **Rectangle → Accessibility:** same place, on first launch.
- [ ] **iTerm2 font:** Settings → Profiles → Text → Font → `MesloLGS NF`.
- [ ] **GitHub CLI:** `gh auth login`
- [ ] **Git identity & config:** see [docs/tools.md#git](docs/tools.md#git)
- [ ] **SSH key:** copy `~/.ssh` from the old machine or `ssh-keygen -t ed25519`, then `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
- [ ] **Secrets:** put tokens / work env vars in `~/.zshrc.local`

## Layout

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`:

| Package | Links to | What |
|---|---|---|
| `zsh/` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.p10k.zsh`, `~/.zsh_plugins.txt` | Shell — [docs/shell.md](docs/shell.md) |
| `nvim/` | `~/.config/nvim` | Neovim — [its own README](nvim/.config/nvim/README.md) |
| `tmux/` | `~/.tmux.conf` | tmux — [docs/tmux.md](docs/tmux.md) |
| `bin/` | `~/.local/bin/tmux-project` | Project picker script |
| `mise/` | `~/.config/mise/config.toml` | Global runtime versions — [docs/tools.md](docs/tools.md) |
| `skhd/` | `~/.config/skhd/skhdrc` | App hotkeys — [docs/hotkeys.md](docs/hotkeys.md) |
| `git/` | `~/.config/git/ignore` | Global gitignore (git config itself: TODO) |

Not packages: `Brewfile`, `install.sh`, `docs/`, `.githooks/`.

Because files are symlinked, editing `~/.tmux.conf` edits the file in this repo — just commit.

## Docs

- [cheatsheet.md](cheatsheet.md) — one page of what-replaces-what and the keys I forget
- [docs/shell.md](docs/shell.md) — zsh, p10k, plugins, `cd`/`ls`/`bat`/fzf
- [docs/tools.md](docs/tools.md) — mise, uv, poetry, git/delta/gh, lazygit
- [docs/tmux.md](docs/tmux.md) — tmux keys and the project workflow
- [docs/hotkeys.md](docs/hotkeys.md) — skhd app hotkeys, Rectangle
- [docs/macos.md](docs/macos.md) — manual macOS settings
- [docs/maintenance.md](docs/maintenance.md) — adding tools, updating, secrets, rebuilding a machine
