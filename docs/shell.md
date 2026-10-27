# Shell

Plain zsh, no framework. Config: [`zsh/.zshrc`](../zsh/.zshrc) — read it top to bottom, it's short.

## Startup files

| File | Runs for | Contains |
|---|---|---|
| `~/.zshenv` | every zsh, incl. scripts | `EDITOR`, XDG dirs. Keep tiny. |
| `~/.zprofile` | login shells | `brew shellenv` |
| `~/.zshrc` | interactive shells | everything else |
| `~/.zshrc.local` | interactive, last | **secrets & machine-specific config — not in git** |

## Plugins (antidote)

Listed in [`zsh/.zsh_plugins.txt`](../zsh/.zsh_plugins.txt). antidote compiles them into `~/.zsh_plugins.zsh` automatically when the list changes.

| Plugin | What you get |
|---|---|
| powerlevel10k | the prompt |
| fzf-tab | **Tab** opens a fuzzy picker for any completion (files, git branches, flags…). Type to filter, Enter to accept. `cd <Tab>` previews dir contents. |
| zsh-autosuggestions | grey suggestion from history as you type. **→** (or Ctrl+E) accepts it, **Alt+→** accepts one word. |
| zsh-syntax-highlighting | commands turn green if valid, red if not — before you hit Enter |

- Add a plugin: add `user/repo` to `.zsh_plugins.txt`, open a new shell.
- Update all: `antidote update`

## Prompt (powerlevel10k)

Left: directory, git status. Right (only when relevant): exit code on failure, duration if > 3s, background jobs, direnv, venv, terraform workspace, AWS profile.

- **Transient prompt** is on: once you run a command, its prompt collapses to `❯` so scrollback stays clean.
- Git status symbols: `⇡1` ahead, `⇣1` behind, `!2` modified, `+1` staged, `?3` untracked, `*1` stash.
- Reconfigure from scratch: `p10k configure` (overwrites `~/.p10k.zsh` → re-apply edits). Small tweaks: edit `zsh/.p10k.zsh` directly — search for `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`.
- p10k is in "limited support" upstream but feature-complete and the fastest prompt available. If it ever breaks, Starship is the fallback.

## New everyday commands

### `cd` is now zoxide

`cd` still works exactly as before with paths. **New:** give it part of a name and it jumps to the most-used matching directory you've visited.

```sh
cd dotfiles        # → ~/dotfiles from anywhere
cd fora back       # → ~/Foragist/foragist-backend (multiple words narrow it)
cdi                # interactive fzf picker over all remembered dirs
cd -               # previous dir, as before
zoxide query -l    # list what it remembers, ranked
```

It learns as you go — first visit a dir normally, after that the shortcut works.

**Dot expansion:** each `.` you type after `..` adds another level as you type: `cd ...` turns into `cd ../..`, `cd ....` into `cd ../../..`. It only fires when `..` starts a word, so `git diff a...b` is left alone.

### `ls` is now eza

```sh
ls                 # icons, dirs first, hidden files included
ll                 # long listing + git status column, hidden files included
la                 # same as ll (kept for muscle memory)
lt                 # tree, 2 levels, respects .gitignore
command ls         # the original macOS ls, if a script/habit needs it
```

### `bat` — cat with highlighting (alongside `cat`)

`cat` is unchanged. Use `bat` when you want to *read* a file:

```sh
bat src/app.py             # syntax highlighting, line numbers, git change markers, pager
bat -p file                # plain (no line numbers/decorations)
bat -l json < response.txt # force a language
```

### fzf key bindings

| Key | Does |
|---|---|
| **Ctrl+R** | fuzzy search shell history (replaces the default reverse search) |
| **Ctrl+T** | fuzzy-pick a file and paste its path onto the command line |
| **Alt+C** | fuzzy-pick a directory and `cd` into it (needs iTerm Option = Esc+) |
| `**<Tab>` | e.g. `vim **<Tab>` — fuzzy file completion |

fzf uses `fd` under the hood, so it respects `.gitignore` and shows dotfiles.

### Line editing: vi mode

The command line is in **vi mode**. You start in insert mode; the prompt shows `❯` in insert and `❮` in normal mode.

| Key | Mode | Does |
|---|---|---|
| Esc | insert | normal mode (no delay) — then `h`/`l`, `w`/`b`/`e`, `0`/`$`, `x`, `dw`, `ciw`, `u`… |
| `v` | normal | open the command line in nvim; save + quit runs it |
| Option+←/→ | both | jump a word back / forward |
| Ctrl+A / Ctrl+E | insert | start / end of line (Ctrl+E also accepts an autosuggestion) |
| Ctrl+W / Ctrl+U / Ctrl+K | insert | delete word back / to line start / to line end |

Option+←/→ needs iTerm's Option key set to Esc+ (see [macos.md](macos.md)); the Ghostty config already sends the right codes.

### History

- **↑ / ↓** search history by what you've already typed (`git ↑` → last git command).
- History is shared live across all tmux panes. 50k entries.
- Start a command with a space to keep it out of history (useful for commands containing secrets).

## What changed from the old Prezto setup

- Prezto removed; its useful bits (history opts, auto_cd, ↑-prefix search, completion) are now inline in `.zshrc`.
- No more `eval "$(ssh-agent -s)"` per shell — macOS's built-in agent + keychain handles keys.
- No more global `VIRTUAL_ENV=.venv` (it lied to tools about an active venv).
- pyenv / `~/.deno/env` replaced by one `mise activate` line.
