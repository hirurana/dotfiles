#!/usr/bin/env bash
# install.sh — set up a Mac from this repo. Safe to re-run.
#   git clone https://github.com/hirurana/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PACKAGES=(zsh nvim tmux bin skhd git mise ghostty)
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

step() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }

# ---- Xcode Command Line Tools (git, compilers) ----
if ! xcode-select -p >/dev/null 2>&1; then
  step "Installing Xcode Command Line Tools — re-run this script when it finishes"
  xcode-select --install
  exit 0
fi

# ---- Homebrew ----
if ! command -v brew >/dev/null 2>&1; then
  step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

step "brew bundle"
brew tap asmvik/formulae >/dev/null
brew trust --tap asmvik/formulae   # third-party tap for skhd; Homebrew requires explicit trust
brew bundle --file="$DOTFILES/Brewfile" || echo "!! brew bundle had failures (see above) — fix them and re-run; continuing with the rest"

# ---- Font: MesloLGS NF (the patched Nerd Font powerlevel10k expects) ----
step "MesloLGS NF font"
FONT_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
for style in "Regular" "Bold" "Italic" "Bold Italic"; do
  f="MesloLGS NF $style.ttf"
  [[ -f "$HOME/Library/Fonts/$f" ]] || curl -fsSL -o "$HOME/Library/Fonts/$f" "$FONT_URL/${f// /%20}"
done

# ---- Symlinks via stow (back up any real file that would be replaced) ----
step "Linking dotfiles"
for pkg in "${PACKAGES[@]}"; do
  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES/$pkg/"}"
    target="$HOME/$rel"
    [[ -e "$target" || -L "$target" ]] || continue
    # Already resolves into this repo (a stow link, or inside a stow-linked dir) — leave it.
    resolved="$(realpath "$target" 2>/dev/null || true)"
    [[ "$resolved" == "$DOTFILES"/* ]] && continue
    mkdir -p "$BACKUP/$(dirname "$rel")"
    mv "$target" "$BACKUP/$rel"
    echo "  backed up ~/$rel -> $BACKUP/$rel"
  done < <(find "$DOTFILES/$pkg" -type f -print0)
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
done

# Machine-local overrides — never committed
[[ -f "$HOME/.zshrc.local" ]] || cat > "$HOME/.zshrc.local" <<'EOF'
# ~/.zshrc.local — secrets and machine-specific config. NOT in git.
# export AWS_PROFILE=...
EOF

# ---- Runtimes & Python tools ----
step "mise install (node, python, go, deno)"
mise install

step "uv tools"
uv tool install poetry 2>/dev/null || uv tool upgrade poetry

# ---- Claude Code: native installer (→ ~/.local/bin/claude, self-updating) — not via brew ----
step "Claude Code"
[[ -x "$HOME/.local/bin/claude" ]] || curl -fsSL https://claude.ai/install.sh | bash

# ---- Services ----
step "skhd service"
skhd --start-service 2>/dev/null || skhd --restart-service

# ---- Repo hooks: gitleaks blocks commits containing secrets ----
git -C "$DOTFILES" config core.hooksPath .githooks

cat <<EOF

Done. Open a new terminal (or run: exec zsh).
Manual steps still needed — see $DOTFILES/README.md#after-install and docs/macos.md:
  - Grant skhd Accessibility access (System Settings → Privacy & Security → Accessibility)
  - gh auth login
  - claude (log in)
EOF
