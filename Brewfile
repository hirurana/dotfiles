# Brewfile — `brew bundle --file=~/dotfiles/Brewfile`
# Language runtimes (node, python, go, deno) are NOT here — mise manages them (see mise/.config/mise/config.toml).

tap "koekeishiya/formulae"                 # skhd (install.sh runs `brew trust` on it)

# ---- Shell ----
brew "antidote"        # zsh plugin manager
brew "stow"            # symlinks this repo into $HOME
brew "zoxide"          # smarter cd
brew "eza"             # better ls
brew "bat"             # cat with syntax highlighting
brew "fd"              # fast find (used by fzf + telescope)
brew "fzf"             # fuzzy finder
brew "ripgrep"         # fast grep
brew "jq"              # JSON on the command line
brew "direnv"          # per-directory env vars

# ---- Dev ----
brew "neovim"
brew "tmux"
brew "git"
brew "git-delta"       # nicer git diffs (wire up in git config)
brew "gh"              # GitHub CLI
brew "lazygit"
brew "mise"            # runtime version manager
brew "uv"              # Python packages, venvs, tools
brew "pdm"
brew "pnpm"
brew "gitleaks"        # secret scanner (pre-commit hook in this repo)

# ---- Cloud / work ----
brew "awscli"
brew "chamber"
brew "stripe-cli"

# ---- Window management ----
brew "koekeishiya/formulae/skhd"

# ---- Apps ----
cask "iterm2"
cask "rectangle"
cask "claude-code"
cask "aws-vault-binary"
