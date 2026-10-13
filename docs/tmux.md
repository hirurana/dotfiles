# tmux

Config: [`tmux/.tmux.conf`](../tmux/.tmux.conf). Reload: `prefix r`.

## Workflow

Every project is a tmux session with four fixed windows:

| # | Window | Runs |
|---|---|---|
| 1 | editor | `nvim .` |
| 2 | term | shell |
| 3 | claude | `claude` |
| 4 | lazygit | `lazygit` |

**Alt+f** (from the shell or inside tmux) opens the project picker (`~/.local/bin/tmux-project`): fuzzy-pick a folder in `~/Code` and it creates or switches to that session. `tmux-restore` / `prefix R` recreates any window you closed.

Override the projects folder with `CODE_DIR=~/elsewhere` in `~/.zshrc.local`.

## Keys

| Key | Does |
|---|---|
| **Ctrl+Space** | prefix |
| **Shift+← / Shift+→** | previous / next window |
| prefix **1–4** | jump to window |
| prefix **d** | detach |
| prefix **s** | session list |
| prefix **R** | restore missing project windows |
| prefix **r** | reload config |
| **Alt+f** | project picker popup |
| Ctrl+h/j/k/l | move between nvim splits (vim-tmux-navigator is installed in nvim, but its tmux-side bindings aren't in `.tmux.conf` yet, so it won't cross into tmux panes) |

Mouse is on; scrollback is 50k lines.
