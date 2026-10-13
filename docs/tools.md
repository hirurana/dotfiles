# Tools

## mise — runtime versions (python, node, go, deno)

Replaces pyenv, nvm, Homebrew node/go and the deno installer. Global defaults live in [`mise/.config/mise/config.toml`](../mise/.config/mise/config.toml).

```sh
mise ls                      # what's installed / active here
mise use python@3.12         # pin for THIS project (writes ./mise.toml)
mise use -g node@24          # change the global default (edits the dotfiles config)
mise install                 # install whatever this dir's config asks for
mise which python            # full path to the active interpreter
mise upgrade                 # bump tools within their pinned ranges
mise use -g npm:some-cli     # install a global npm CLI (that's how aws-cdk is installed)
```

- mise also honours existing `.python-version`, `.nvmrc` and `.node-version` files.
- Versions switch automatically when you `cd` — no shims, no `pyenv shell`.

## uv — Python packages, venvs, tools

```sh
uv venv                      # create .venv (uses mise's python)
uv pip install -r requirements.txt
uv init / uv add httpx / uv sync / uv run pytest   # project workflow
uv tool install ruff         # global CLI tool in its own venv (like pipx)
uv tool list / uv tool upgrade --all
uvx ruff check .             # run a tool once without installing
```

## Poetry / pdm

- Poetry is installed via `uv tool install poetry` (no longer inside a pyenv Python).
- pdm comes from Homebrew.
- `POETRY_VIRTUALENVS_IN_PROJECT=true` is set, so venvs are `./.venv`.

Rebuilding a project's venv on a mise python:

```sh
cd ~/Foragist/foragist-backend
mise install                                  # installs the version from .python-version
rm -rf .venv
poetry env use "$(mise which python)"
poetry install
```

## Git

**TODO:** I'm setting up my git config myself. When I do, put it in `git/.config/git/config` (stow picks it up). Common choices from the gap analysis:

```ini
[core]   pager = delta
[interactive] diffFilter = delta --color-only
[delta]  navigate = true
[merge]  conflictStyle = zdiff3
[diff]   algorithm = histogram
[rerere] enabled = true
[fetch]  prune = true
[rebase] autoSquash = true
[branch] sort = -committerdate
[commit] verbose = true
[gpg]    format = ssh          # sign commits with the SSH key
```

The global ignore file is already in place: [`git/.config/git/ignore`](../git/.config/git/ignore).

### delta
Installed; becomes the diff viewer once `core.pager = delta` is set. `n`/`N` jump between files in a diff. lazygit can use it too (`git.paging.pager` in lazygit config).

### gh
```sh
gh auth login                # once per machine
gh pr create / gh pr checkout 123 / gh pr view --web
gh repo clone owner/name
gh run watch                 # follow CI
```

## Search & files

| Tool | Use |
|---|---|
| `rg pattern` | grep, but fast and .gitignore-aware. `rg -t py foo`, `rg -l foo` (files only) |
| `fd name` | find, but sane. `fd -e lua`, `fd -H .env` (include hidden) |
| `jq` | `aws ... \| jq '.Items[].id'` |
| `bat` | see [shell.md](shell.md#bat--cat-with-highlighting-alongside-cat) |

Telescope in Neovim uses `rg` and `fd` automatically.

## direnv

Put `export FOO=bar` (or `layout python`) in a project's `.envrc`, then `direnv allow`. Vars load on `cd` in, unload on `cd` out. p10k shows a direnv icon when active.

## lazygit

Lives in tmux window 4. `?` shows all keys. Space = stage, `c` = commit, `P` = push, `p` = pull, `[`/`]` switch tabs.
