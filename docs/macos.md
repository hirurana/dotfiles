# macOS — manual settings

Not scripted on purpose (personal, and `defaults` keys break between macOS versions). Do these once per machine.

## Required

- [ ] **skhd Accessibility** — System Settings → Privacy & Security → Accessibility → `+` → `/opt/homebrew/bin/skhd` (or enable it if listed). Then `skhd --restart-service`.
- [ ] **Rectangle Accessibility** — prompted on first launch; same pane.
- [ ] **Keep "switch to a Space with open windows" on** — System Settings → Desktop & Dock → Mission Control → *"When switching to an application, switch to a Space with open windows for the application"*. The skhd hotkeys rely on it.

## Recommended for a keyboard-driven workflow

- [ ] **Key repeat** — System Settings → Keyboard: *Key repeat rate* → Fast (far right), *Delay until repeat* → Short (far right). Makes holding `j`/`k` in Neovim usable.
- [ ] **Caps Lock → Control** — System Settings → Keyboard → Keyboard Shortcuts… → Modifier Keys → Caps Lock: Control. Your tmux prefix (Ctrl+Space) and Ctrl+h/j/k/l get much easier. (Do it per keyboard — external keyboards are listed separately in that dropdown.)
- [ ] **Dock** — autohide on, remove apps you launch with hotkeys anyway.
- [ ] **Finder** — Settings → Advanced → *Show all filename extensions*; View → Show Path Bar; `Cmd+Shift+.` toggles hidden files.

## Ghostty

Nothing to click: every terminal setting lives in [`ghostty/.config/ghostty/config`](../ghostty/.config/ghostty/config) (stowed to `~/.config/ghostty/config`). It reproduces the old iTerm2 setup:

| iTerm2 setting | Ghostty config |
|---|---|
| Font MesloLGS NF 13pt | `font-family`, `font-size` |
| Left Option = Esc+, right Option = normal | `macos-option-as-alt = left` |
| Key binding ⌘/ → hex `0x1f` (Neovim comment toggle) | `keybind = super+slash=text:\x1f` |
| Option+←/→ word jumps | `keybind = alt+left/right=csi:…` |
| No confirm on close, non-blinking cursor, bright bold | `confirm-close-surface`, `cursor-style-blink`, `bold-is-bright` |
| New tabs open in the current directory | Ghostty default |

Extras over iTerm: Cmd+←/→ jump to line start/end, Cmd+Backspace deletes to line start, gruvbox theme to match Neovim, and ssh copies Ghostty's terminfo to remote hosts. tmux enables truecolor for `xterm-ghostty`.

Edit the file and press **Cmd+Shift+,** to reload. `ghostty +validate-config` catches typos; `ghostty +list-keybinds` shows every binding.

**Coming from iTerm on an existing Mac:** run `~/dotfiles/install.sh` (installs Ghostty and links the config), then `brew uninstall --cask iterm2` once you're happy.

## Same thing, from the terminal

Equivalent `defaults` commands, if you prefer. Log out/in (or `killall Dock Finder`) after.

```sh
# Key repeat (lower = faster). UI minimum is 2 / 15.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
# Disable press-and-hold accent popup so holding a key repeats
defaults write -g ApplePressAndHoldEnabled -bool false

# Dock autohide, no delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# Finder: extensions, path bar, hidden files
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Screenshots to a folder instead of the Desktop
mkdir -p ~/Screenshots && defaults write com.apple.screencapture location ~/Screenshots

killall Dock Finder SystemUIServer
```

Caps Lock remapping has no reliable `defaults` key — use the System Settings UI.
