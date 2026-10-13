# Hotkeys & windows

## skhd — app hotkeys

Config: [`skhd/.config/skhd/skhdrc`](../skhd/.config/skhd/skhdrc). **Cmd+Ctrl+number** focuses the app, launching it if it isn't running, and switches to its Space.

| Key | App |
|---|---|
| Cmd+Ctrl+1 | iTerm |
| Cmd+Ctrl+2 | Google Chrome |
| Cmd+Ctrl+3 | Spotify |
| Cmd+Ctrl+4 | Notion |
| Cmd+Ctrl+5 | Slack |
| Cmd+Ctrl+6 | Cursor |
| Cmd+Ctrl+7 | Linear |
| Cmd+Ctrl+8 | Microsoft Teams |

- Add/change: edit `skhdrc` → `skhd --reload`. The name after `open -a` is the app's name in /Applications without `.app`.
- Service: `skhd --start-service` / `--restart-service` / `--stop-service`.
- **Not working?** It needs Accessibility permission (System Settings → Privacy & Security → Accessibility). After a `brew upgrade skhd` you may need to remove and re-add it there.
- Logs: `/tmp/skhd_$USER.err.log`

Note: `open -a` brings the *app* forward, so with several Chrome windows you get the last-used one.

**Previously:** these used yabai + jq to query windows. yabai was dropped — it only did that lookup, needed SIP disabled to switch Spaces, and didn't launch closed apps.

## Rectangle — window snapping

Installed via Brewfile; settings are in its own preferences (not in this repo). Defaults:

| Key | Action |
|---|---|
| Ctrl+Opt+← / → | left / right half |
| Ctrl+Opt+Enter | maximise |
| Ctrl+Opt+D / F / G | left / centre / right third |
| Ctrl+Opt+Cmd+← / → | move to previous / next display |

## Later: AeroSpace

If I start tiling apps side by side a lot, try [AeroSpace](https://github.com/nikitabobko/AeroSpace) — i3-style tiling + virtual workspaces, no SIP changes, TOML config. It would replace skhd + Rectangle.
