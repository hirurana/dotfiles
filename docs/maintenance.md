# Maintenance

## Add a CLI tool / app

1. Add `brew "name"` (or `cask "name"`) to the [`Brewfile`](../Brewfile) with a short comment.
2. `brew bundle --file=~/dotfiles/Brewfile`
3. If it has config: create a stow package (see below).
4. Document it in the relevant `docs/*.md` and, if it changes a habit, in [`cheatsheet.md`](../cheatsheet.md).

Runtimes (python/node/go/deno) go in mise, not the Brewfile. Global npm/Python CLIs: `mise use -g npm:<pkg>` / `uv tool install <pkg>` — add uv tools to `install.sh` so a new machine gets them.

## Add a config file (new stow package)

```sh
mkdir -p ~/dotfiles/foo/.config/foo
mv ~/.config/foo/config.toml ~/dotfiles/foo/.config/foo/
# add "foo" to PACKAGES in install.sh, then:
stow --dir ~/dotfiles --target ~ foo
```

The folder structure inside a package mirrors `$HOME` exactly.

Unlink a package: `stow -D --dir ~/dotfiles --target ~ foo`.

## Update everything

```sh
brew update && brew upgrade      # CLI tools + apps
mise upgrade                     # runtimes
uv tool upgrade --all            # poetry etc.
antidote update                  # zsh plugins
claude update                    # Claude Code (also auto-updates)
nvim → :Lazy sync, :MasonUpdate  # editor plugins
```

Commit `nvim/.config/nvim/lazy-lock.json` after `:Lazy sync` so other machines get the same plugin versions.

## Secrets

- **Never** put tokens, keys, or work-specific config in tracked files — this repo is **public**.
- They go in `~/.zshrc.local` (sourced last by `.zshrc`, not in git). For per-project env vars use a gitignored `.envrc` (direnv).
- A **gitleaks pre-commit hook** (`.githooks/pre-commit`, enabled by `install.sh` via `core.hooksPath`) blocks commits containing secrets. If it's a false positive: `git commit --no-verify` — only when you're sure.
- Manual scan of the whole history: `gitleaks git ~/dotfiles`.

## New machine

```sh
git clone https://github.com/hirurana/dotfiles.git ~/dotfiles   # HTTPS: no SSH key needed yet
~/dotfiles/install.sh
```

Then work through [README → After install](../README.md#after-install). Copy `~/.ssh`, `~/.aws` and `~/.zshrc.local` from the old machine (securely) — they're intentionally not in the repo.

## Backups

`install.sh` moves any existing file it would replace to `~/dotfiles-backup-<timestamp>/`. Delete those once you're happy.
