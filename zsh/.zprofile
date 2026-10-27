# Login shells only. Put Homebrew on PATH before anything else needs it.
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise shims, so node/python are found by things that don't run an interactive shell
# (e.g. nvim started directly by tmux-project). `mise activate` in .zshrc still wins.
export PATH="$HOME/.local/share/mise/shims:$PATH"
