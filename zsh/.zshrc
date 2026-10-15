# ~/.zshrc — interactive shell config. Managed in ~/dotfiles (zsh package).
# Machine-specific settings and secrets go in ~/.zshrc.local (never committed).

# direnv must export before instant prompt so its output doesn't break it.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Powerlevel10k instant prompt. Anything that needs console input goes above this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- PATH ----
typeset -U path
path=("$HOME/.local/bin" "${HOMEBREW_PREFIX:-/opt/homebrew}/bin" $path)

# ---- Options ----
setopt nonomatch                 # pass unmatched globs through (e.g. pip install foo[bar])
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent
setopt interactive_comments
bindkey -e                       # emacs-style line editing

# ---- History ----
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history share_history hist_ignore_all_dups hist_ignore_space \
       hist_reduce_blanks hist_verify

# Up/Down search history by what's already typed (replaces Prezto history-substring-search)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ---- Completion ----
# Rebuild the completion dump at most once a day; otherwise load it as-is (-C).
fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" $fpath)
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
if [[ -n $_zcompdump(N.mh+24) || ! -s $_zcompdump ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' menu no                           # fzf-tab draws the menu
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# ---- Plugins (antidote) ----
source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote/antidote.zsh"
antidote load "$HOME/.zsh_plugins.txt"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ---- Tools ----
eval "$(mise activate zsh)"                 # node / python / go / deno versions
eval "$(direnv hook zsh)"                   # per-directory .envrc
eval "$(zoxide init zsh --cmd cd)"          # `cd foo` jumps to the best match for "foo"
source <(fzf --zsh)                         # Ctrl+R history, Ctrl+T files, Alt+C dirs

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

export POETRY_VIRTUALENVS_IN_PROJECT=true

# ---- Aliases ----
alias ls='eza -a --group-directories-first'
alias ll='eza -la --git --group-directories-first'
alias la='eza -la --git --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'
alias k='kubectl'

# ---- tmux project picker ----
alias tmux-restore='tmux-project --restore'   # rebuild missing editor/term/claude/lazygit windows
# Outside tmux, run it as a real command line: `tmux attach` fails silently inside a
# zle widget. Leading space keeps it out of history (hist_ignore_space).
_tmux_project_widget() {
  if [[ -n $TMUX ]]; then
    zle -I; tmux-project < /dev/tty; zle reset-prompt
  else
    BUFFER=" tmux-project"; zle accept-line
  fi
}
zle -N _tmux_project_widget
bindkey '\ef' _tmux_project_widget   # Alt+f (Option as Esc+)
bindkey 'ƒ'   _tmux_project_widget   # Alt+f (Option as Normal)

# ---- Local overrides (secrets, work config) ----
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/hirurana/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
