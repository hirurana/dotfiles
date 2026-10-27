# Cheatsheet

`bat ~/dotfiles/cheatsheet.md`

## What replaced what

| Old | New | Notes |
|---|---|---|
| `cd ~/Foragist/foragist-backend` | `cd backend` | zoxide — partial names jump to frequent dirs. `cdi` = picker |
| `ls` | `ls` / `ll` / `la` / `lt` | eza — always shows hidden files; icons, git column, tree. `command ls` for the original |
| `cat file` | `bat file` | when *reading*; `cat` unchanged for pipes |
| Ctrl+R reverse search | **Ctrl+R** fzf | fuzzy; Ctrl+T = file path, Alt+C = cd |
| Tab completion list | **Tab** fzf-tab | fuzzy picker for every completion |
| `find . -name x` | `fd x` | |
| `grep -r x` | `rg x` | |
| pyenv / nvm / brew node | `mise use python@3.12` | per-project; `mise ls`, `mise which python` |
| `pip install` / pipx | `uv pip install` / `uv tool install` | `uvx tool` to run once |
| `git diff` | `git diff` (via delta, once git config is set) | `n`/`N` next/prev file |
| GitHub web | `gh pr create`, `gh pr checkout 12` | |
| yabai + jq hotkeys | `open -a` in skhd | same keys, launches closed apps |
| Prezto | plain zsh + antidote | `antidote update` |

## Keys I forget

| Key | Where | Does |
|---|---|---|
| Alt+f | anywhere | tmux project picker |
| Ctrl+Space | tmux | prefix |
| Shift+←/→ | tmux | prev/next window |
| prefix R | tmux | restore missing windows |
| prefix \| / - | tmux | split side by side / stacked |
| prefix [ | tmux | scroll mode (hjkl, v…y copies) |
| Cmd+/ | nvim | toggle comment (line or highlighted block) |
| Cmd+Opt+1…8 | macOS | iTerm, Chrome, Spotify, Notion, Slack, Cursor, Linear, Teams |
| Ctrl+Opt+←/→/Enter | macOS | Rectangle half / half / max |
| → | shell | accept autosuggestion |
| ↑ | shell | history search by typed prefix |
| `␣cmd` | shell | leading space = not saved to history |
| `cd ...` | shell | auto-expands to `cd ../..` as you type (each extra `.` = one more level) |

## Where things live

| Thing | File |
|---|---|
| shell | `~/dotfiles/zsh/.zshrc` |
| secrets / machine-only | `~/.zshrc.local` (not in git) |
| prompt | `~/dotfiles/zsh/.p10k.zsh` |
| zsh plugins | `~/dotfiles/zsh/.zsh_plugins.txt` |
| runtimes | `~/dotfiles/mise/.config/mise/config.toml` |
| tools/apps | `~/dotfiles/Brewfile` |
| hotkeys | `~/dotfiles/skhd/.config/skhd/skhdrc` |
| nvim keymaps | `~/dotfiles/nvim/.config/nvim/README.md` |
