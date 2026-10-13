# CLAUDE.md

Hiru's macOS dotfiles. Public repo — treat everything here as world-readable.

## Layout

- Each top-level dir except `docs/` and `.githooks/` is a **GNU Stow package** whose contents mirror `$HOME` (e.g. `zsh/.zshrc` → `~/.zshrc`, `nvim/.config/nvim/` → `~/.config/nvim`). The package list is `PACKAGES` in `install.sh`.
- Files in `$HOME` are symlinks into this repo — edit here, not via copies.
- `Brewfile` = all CLI tools and apps. Language runtimes are **not** in Brewfile; they're in `mise/.config/mise/config.toml`.
- `install.sh` must stay idempotent and must back up (never delete) any real file before stowing over it.
- The Neovim config has its own `nvim/.config/nvim/CLAUDE.md` and `README.md`.

## Rules

- **Docs stay in sync.** Any change that adds/removes a tool, keybinding, alias or package must update the matching `docs/*.md`, `cheatsheet.md` if it changes a habit, and `README.md` if it affects install or layout.
- **No secrets.** Tokens, keys, account IDs, work-specific env vars go in `~/.zshrc.local` (untracked) or a project `.envrc`, never in this repo. A gitleaks pre-commit hook enforces this.
- **Shell speed matters.** Don't add anything to `.zshrc` that forks a process on every prompt or adds noticeable startup time; prefer antidote plugins and cached `eval`s. Check with `time zsh -i -c exit` (≈0.12s baseline).
- Prompt is powerlevel10k (chosen over Starship for latency). Edit `zsh/.p10k.zsh` directly; don't regenerate it with `p10k configure` without re-applying the trimmed segment list and transient prompt.
- New runtime/global tools: python/node/go/deno via mise; Python CLIs via `uv tool install` (and add to `install.sh`).
- Hiru commits and pushes their own changes — don't commit or push unless asked.
