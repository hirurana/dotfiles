# Hotkeys & windows

## skhd — app hotkeys

Config: [`skhd/.config/skhd/skhdrc`](../skhd/.config/skhd/skhdrc). **Cmd+Opt+number** focuses the app, launching it if it isn't running, and switches to its Space.

| Key | App |
|---|---|
| Cmd+Opt+1 | iTerm |
| Cmd+Opt+2 | Google Chrome |
| Cmd+Opt+3 | Spotify |
| Cmd+Opt+4 | Notion |
| Cmd+Opt+5 | Slack |
| Cmd+Opt+6 | Cursor |
| Cmd+Opt+7 | Linear |
| Cmd+Opt+8 | Microsoft Teams |

- Add/change: edit `skhdrc` → `skhd --reload`. The name after `open -a` is the app's name in /Applications without `.app`.
- Service: `skhd --start-service` / `--restart-service` / `--stop-service`.
- **Not working?** It needs Accessibility permission (System Settings → Privacy & Security → Accessibility → `/opt/homebrew/bin/skhd`). Without it skhd logs `must be run with accessibility access! abort..` and exits; after granting, run `skhd --restart-service`. After a `brew upgrade skhd` you may need to remove and re-add it there.
- Logs: `/tmp/skhd_$USER.err.log`
- Cmd+Opt+1…3 overrides "Heading 1–3" in Notion / Google Docs (skhd grabs the key globally).

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
