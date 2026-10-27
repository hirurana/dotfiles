# macOS — manual settings

Not scripted on purpose (personal, and `defaults` keys break between macOS versions). Do these once per machine.

## Required

- [ ] **skhd Accessibility** — System Settings → Privacy & Security → Accessibility → `+` → `/opt/homebrew/bin/skhd` (or enable it if listed). Then `skhd --restart-service`.
- [ ] **Rectangle Accessibility** — prompted on first launch; same pane.
- [ ] **iTerm2 font** — Settings → Profiles → Text → Font: `MesloLGS NF`, 13pt. Without it the prompt shows boxes instead of icons.
- [ ] **Keep "switch to a Space with open windows" on** — System Settings → Desktop & Dock → Mission Control → *"When switching to an application, switch to a Space with open windows for the application"*. The skhd hotkeys rely on it.

## Recommended for a keyboard-driven workflow

- [ ] **Key repeat** — System Settings → Keyboard: *Key repeat rate* → Fast (far right), *Delay until repeat* → Short (far right). Makes holding `j`/`k` in Neovim usable.
- [ ] **Caps Lock → Control** — System Settings → Keyboard → Keyboard Shortcuts… → Modifier Keys → Caps Lock: Control. Your tmux prefix (Ctrl+Space) and Ctrl+h/j/k/l get much easier. (Do it per keyboard — external keyboards are listed separately in that dropdown.)
- [ ] **iTerm2 Option as Meta** — Settings → Profiles → Keys → General → *Left Option key*: `Esc+`. Makes Alt+C (fzf) and Alt+←/→ (word jumps) work. Alt+f works either way.
- [ ] **iTerm2 Cmd+/ → comment** — Settings → Keys → Key Bindings → **+** → Keyboard Shortcut `⌘/`, Action *Send Hex Code*, `0x1f`. iTerm passes Ctrl+/ to Neovim, which toggles comments. Or from a shell: `defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x2f-0x100000" '{ Action = 11; Text = "0x1f"; }'`, then restart iTerm.
- [ ] **iTerm2 unlimited scrollback** — off; tmux keeps 50k lines.
- [ ] **Dock** — autohide on, remove apps you launch with hotkeys anyway.
- [ ] **Finder** — Settings → Advanced → *Show all filename extensions*; View → Show Path Bar; `Cmd+Shift+.` toggles hidden files.

## Switching to Ghostty

iTerm2 is the current terminal. A Ghostty config is ready in [`ghostty/.config/ghostty/config`](../ghostty/.config/ghostty/config) and already covers the iTerm items above (MesloLGS NF font, Option as Alt, Cmd+/ → Ctrl+/), plus a gruvbox theme to match Neovim and ssh terminfo handling. tmux already enables truecolor for `xterm-ghostty`. To switch:

1. `Brewfile`: replace `cask "iterm2"` with `cask "ghostty"`.
2. `install.sh`: add `ghostty` to `PACKAGES`, and change the closing "iTerm2 font" reminder.
3. `skhd/.config/skhd/skhdrc`: `open -a "iTerm"` → `open -a "Ghostty"`, then `skhd --restart-service`.
4. Run `~/dotfiles/install.sh` (installs Ghostty and links the config). Check the config with `ghostty +validate-config`.
5. Update the iTerm mentions: README (Brewfile line, After install font item), this file's iTerm items, [`cheatsheet.md`](../cheatsheet.md), [`hotkeys.md`](hotkeys.md), [`shell.md`](shell.md) (Alt+C note), the comment in `tmux/.tmux.conf` and the Neovim README / `remap.lua` comments.
6. Optionally remove iTerm2: `brew uninstall --cask iterm2`.

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
