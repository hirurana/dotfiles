# Neovim Config — Reference Manual

> Senior Python / AWS / Terraform engineer setup.
> Leader key: `<Space>`

---

## Table of Contents

- [Plugin Manager](#plugin-manager)
- [File Navigation](#file-navigation)
- [LSP & Completions](#lsp--completions)
- [Formatting & Linting](#formatting--linting)
- [Debugging (DAP)](#debugging-dap)
- [Testing (Neotest)](#testing-neotest)
- [Git](#git)
- [Search (Telescope)](#search-telescope)
- [Snippets (LuaSnip)](#snippets-luasnip)
- [Terminal (ToggleTerm)](#terminal-toggleterm)
- [Diagnostics (Trouble)](#diagnostics-trouble)
- [Editor Utilities](#editor-utilities)
- [Language Support](#language-support)
- [Statusline](#statusline)
- [All Keymaps at a Glance](#all-keymaps-at-a-glance)

---

## Plugin Manager

**lazy.nvim** — `:Lazy` to open the UI.

| Command | Action |
|---|---|
| `:Lazy sync` | Install / update / clean all plugins |
| `:Lazy update` | Update plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy health` | Run health checks |

After config changes, run `:Lazy sync` then `:Mason` to install new servers/tools.

---

## File Navigation

### Oil.nvim (`-` / `<leader>pv`)

Oil lets you edit the filesystem like a buffer. Navigate directories, rename/delete/create files with normal vim motions then `:w` to apply. It reloads by itself when files change outside nvim (e.g. `mkdir` in the term window), except while you have unsaved oil edits.

| Key | Action |
|---|---|
| `-` | Open parent directory |
| `<leader>pv` | Open file explorer (oil) |
| `<leader>pV` | Open file explorer in float |
| `<CR>` | Open file / enter directory |
| `<C-v>` | Open in vertical split |
| `<C-s>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview file |
| `<C-c>` | Close oil |
| `<C-r>` | Refresh |
| `-` | Go to parent directory |
| `g.` | Toggle hidden files |
| `g?` | Show help |

### Harpoon 2 (`<leader>h`)

Pin frequently used files for instant jumping.

| Key | Action |
|---|---|
| `<leader>a` | Add file to harpoon |
| `<leader>A` | Prepend file to harpoon |
| `<leader>h` | Toggle harpoon menu |
| `<leader>1–5` | Jump to harpoon file 1–5 |

### Undotree (`<leader>u`)

| Key | Action |
|---|---|
| `<leader>u` | Toggle undo history tree |

---

## LSP & Completions

**Servers installed via Mason** (`:Mason` to manage):

| Language | Server | Notes |
|---|---|---|
| Python | `basedpyright` | Type checking (standard mode), completions |
| Python | `ruff` | Linting diagnostics + auto-fix |
| Terraform / HCL | `terraformls` | Completions, formatting |
| YAML | `yamlls` | Schema validation (Kubernetes, Kustomize, CloudFormation, GitHub Actions, Docker Compose) |
| JSON | `jsonls` | Schema validation via schemastore |
| Lua | `lua_ls` | Config editing |
| Bash | `bashls` | Shell scripts |
| CSS / Tailwind | `tailwindcss` | |

### LSP Keymaps (active when LSP attaches)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>vrn` | Rename symbol |
| `<leader>vca` | Code actions |
| `<leader>vrr` | References |
| `<leader>vws` | Workspace symbols |
| `<leader>vd` | Show line diagnostics (float) |
| `<leader>ee` | Show line diagnostics (float) |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<C-h>` (insert) | Signature help |

### Completion (nvim-cmp)

| Key | Action |
|---|---|
| `<C-n>` | Next completion item |
| `<C-p>` | Previous completion item |
| `<Tab>` | Next item |
| `<S-Tab>` | Previous item |
| `<Enter>` | Confirm selection |
| `<C-Space>` | Trigger completion |

**Sources**: LSP → LuaSnip → buffer → path

---

## Formatting & Linting

**conform.nvim** — formats on save automatically.

| Language | Formatter |
|---|---|
| Python | `ruff_format` (style) + `ruff_fix` (lint auto-fix) |
| Terraform / HCL | `terraform_fmt` |
| YAML | `prettier` (2-space indent) |
| JSON | `prettier` |
| JavaScript / TypeScript | `prettier` |
| Lua | `stylua` |
| C / C++ | `clang-format` (LLVM fallback) |
| Shell | `shfmt` (4-space indent) |
| Elixir | `mix` |

> **Python note**: `black` is intentionally omitted — `ruff_format` is a full drop-in replacement and is ~100× faster.

> **Auto-install**: `mason-tool-installer.nvim` ensures `stylua`, `prettier`, and `shfmt` are installed on startup — formatting silently no-ops for a filetype if its formatter binary is missing, so this closes that gap automatically.

| Key | Action |
|---|---|
| `<leader>f` | Format current buffer (async) |

---

## Debugging (DAP)

**nvim-dap** + **nvim-dap-ui** + **nvim-dap-python**

### Debug Adapters (installed via Mason)

| Language | Adapter |
|---|---|
| Python | `debugpy` |

### Python Debug Configurations

On `<F8>` in a Python file:
- **Python: File** — run the current file
- **Python: Module** — run as module (`python -m ...`)
- **Python: Pytest (current file)** — debug pytest on current file

Auto-detects virtualenv from `$VIRTUAL_ENV`.

### DAP Keymaps

| Key | Action |
|---|---|
| `<F8>` | Continue / start |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Set conditional breakpoint |

### DAP UI Panels

| Key | Panel |
|---|---|
| `<leader>dr` | REPL |
| `<leader>ds` | Call stack |
| `<leader>dS` | Scopes (variables) |
| `<leader>dw` | Watches |
| `<leader>db` | Breakpoints |
| `<leader>dc` | Console (stdout/stderr) |

---

## Testing (Neotest)

**neotest** with a Python (pytest) adapter.

### Python

Pytest is auto-detected. Tests run inside the active virtualenv.

### Test Keymaps

| Key | Action |
|---|---|
| `<leader>tr` | Run nearest test |
| `<leader>ts` | Run full test suite |
| `<leader>ta` | Run all tests in cwd |
| `<leader>tl` | Re-run last test |
| `<leader>td` | Debug nearest test (uses DAP) |
| `<leader>to` | Open test output |
| `<leader>tv` | Toggle test summary panel |

---

## Git

### Fugitive (`<leader>g`)

| Key | Action |
|---|---|
| `<leader>gs` | Toggle git status (`:Git`) |
| `<leader>p` | Push (in fugitive buffer) |
| `<leader>P` | Pull --rebase (in fugitive buffer) |
| `<leader>t` | Push -u origin (in fugitive buffer) |
| `gu` | Diffget from //2 (left/ours) |
| `gh` | Diffget from //3 (right/theirs) |

### Gitsigns (`<leader>G` + `]h`/`[h`)

Per-line git indicators in the sign column. Inline blame toggled on demand.

| Key | Action |
|---|---|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>Gs` | Stage hunk |
| `<leader>Gr` | Reset hunk |
| `<leader>GS` | Stage entire buffer |
| `<leader>Gu` | Undo last stage |
| `<leader>Gp` | Preview hunk diff |
| `<leader>Gb` | Toggle inline blame |
| `<leader>Gd` | Diff this file vs HEAD |
| `<leader>GD` | Diff this file vs HEAD~ |

Visual mode: `<leader>Gs` / `<leader>Gr` operate on the selected line range.

### Lazygit (`<leader>lg`)

Full lazygit TUI inside a floating terminal.

| Key | Action |
|---|---|
| `<leader>lg` | Open lazygit |
| `q` | Close lazygit (in normal mode) |

---

## Search (Telescope)

**telescope.nvim** with **telescope-fzf-native** for native C fzf sorting.

### File Pickers

| Key | Action |
|---|---|
| `<leader>pf` | Find files (including hidden) |
| `<C-p>` | Git-tracked files only |
| `<leader>pr` | Recent files (oldfiles) |
| `<leader>pb` | Open buffers |

### Search Pickers

| Key | Action |
|---|---|
| `<leader>pl` | Live grep (interactive) |
| `<leader>ps` | Grep with manual input |
| `<leader>pws` | Grep word under cursor |
| `<leader>pWs` | Grep WORD under cursor |
| `<leader>pd` | Workspace diagnostics |
| `<leader>vh` | Help tags |

### Inside Telescope

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Navigate results |
| `<C-v>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-u>` / `<C-d>` | Scroll preview |
| `<Esc>` | Close |

---

## Snippets (LuaSnip)

Friendly-snippets loaded by default. Custom snippets can be added to `~/.config/nvim/snippets/`.

| Key | Mode | Action |
|---|---|---|
| `<C-j>` | insert/select | Expand snippet or jump to next node |
| `<C-k>` | insert/select | Jump to previous node |

---

## Terminal (ToggleTerm)

Floating terminal. All terminals persist between toggles.

| Key | Action |
|---|---|
| `<C-\>` | Toggle floating terminal |
| `<leader>tf` | Open float terminal |
| `<leader>th` | Open horizontal split terminal |
| `<leader>lg` | Open lazygit terminal |
| `<C-\><C-n>` | Exit terminal insert mode (built-in) |
| `<C-h/j/k/l>` | Navigate to adjacent window from terminal |

---

## Diagnostics (Trouble)

**trouble.nvim v3** — structured diagnostic panel.

| Key | Action |
|---|---|
| `<leader>tt` | Toggle workspace diagnostics |
| `<leader>tT` | Toggle buffer diagnostics |
| `<leader>tq` | Toggle quickfix list |
| `<leader>tL` | Toggle location list |
| `[t` / `]t` | Previous / next item (or falls back to `vim.diagnostic`) |

---

## Editor Utilities

### Zen Mode (`<leader>z`)

| Key | Action |
|---|---|
| `<leader>zz` | Zen mode (90 cols, with line numbers) |
| `<leader>zZ` | Zen mode (80 cols, no line numbers — writing mode) |

### Autopairs

Automatically closes `()`, `[]`, `{}`, `""`, `''`. Works with nvim-cmp.

### Commenting (built-in)

Neovim's native `gc` / `gcc` (no plugin). The marker comes from the language under the cursor (treesitter-aware `commentstring`).

| Key | Mode | Action |
|---|---|---|
| `<C-/>` / `Cmd+/` | normal / visual | Toggle line comment (current line, or every highlighted line) |
| `gcc` / `gc{motion}` | normal | Toggle comment on line / motion (e.g. `gcip` = paragraph) |
| `gc` | visual | Toggle comment on selection |

`Cmd+/` needs the iTerm2 key binding in [`docs/macos.md`](../../../docs/macos.md) (it sends Ctrl+/).

### Markdown Preview (peek.nvim)

| Command | Action |
|---|---|
| `:PeekOpen` | Open markdown preview in browser |
| `:PeekClose` | Close preview |

---

## Language Support

### Python

| Tool | Role |
|---|---|
| `basedpyright` | Type checking (standard), completions, go-to-def |
| `ruff` LSP | Linting diagnostics + auto-fix on save |
| `ruff_format` | Code formatting (replaces black) |
| `debugpy` | Breakpoint debugging via DAP |
| `neotest-python` | Pytest test runner integration |
| `nvim-venv-detector` | Auto-detects `.venv`, `venv`, Poetry, uv envs |

**Virtualenv**: Detected automatically on buffer open. LSP restarts when venv changes. Active venv shown in statusline.

### Terraform / HCL

| Tool | Role |
|---|---|
| `terraformls` | Completions, hover docs |
| `terraform_fmt` | Formatting on save |
| `yamlls` | CloudFormation schema validation |

### YAML (AWS)

`yamlls` auto-validates against:
- AWS CloudFormation schema (`cloudformation/*.yaml`, `*.cf.yaml`)
- GitHub Actions workflow schema (`.github/workflows/*.yml`)
- Docker Compose schema (`docker-compose*.yml`)
- Kustomize schema (`kustomization.yaml`)

### YAML (Kubernetes)

Any YAML file with a top-level `apiVersion:` and `kind:` is treated as a Kubernetes manifest, whatever its name (detected on open and on save). `yamlls` then validates it against the Kubernetes schema and gives completions and hover docs for fields. CRD kinds (cert-manager, Argo, …) are resolved from the [datree CRDs catalog](https://github.com/datreeio/CRDs-catalog). Helm templates (anything containing `{{`) and `kustomization.yaml` are skipped. The detection lives next to the `yamlls` config in `lua/hiru/lazy/lsp.lua`.

### JSON

`jsonls` with full **schemastore** catalog — auto-detects schema from filename (package.json, tsconfig.json, etc.).

---

## Statusline

**lualine.nvim** — global statusline across all windows.

```
[MODE] [branch] [diff] [diagnostics]   filename.py   (venv) python  80%  42:10
```

Sections:
- **Left**: mode, git branch, diff stats, LSP error/warn counts
- **Center**: file path (relative)
- **Right**: Python venv name (when in a .py file), encoding, filetype, progress, cursor position

---

## All Keymaps at a Glance

> Press `<Space>` and wait 500ms for **which-key** popup with group labels.

### General

| Key | Action |
|---|---|
| `<leader>w` | Save file |
| `<leader>pv` | File explorer (oil) |
| `-` | Open parent dir (oil) |
| `<leader>ee` | Show line diagnostics |
| `<C-u>` / `<C-d>` | Page up/down (re-centred) |
| `n` / `N` | Next/prev search (re-centred) |
| `<C-c>` (insert) | Escape to normal mode |
| `<C-h/j/k/l>` | Navigate splits |
| `J` / `K` (visual) | Move selected lines down/up |
| `<leader>D` | Delete to void (don't clobber clipboard) |
| `<leader>p` (visual) | Paste without clobbering yank register |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<leader>vrn` | Rename symbol |
| `<leader>vca` | Code actions |
| `<leader>vrr` | References |
| `<leader>vws` | Workspace symbols |
| `<leader>vd` | Line diagnostics |
| `[d` / `]d` | Prev / next diagnostic |

### Files / Telescope

| Key | Action |
|---|---|
| `<leader>pf` | Find files |
| `<C-p>` | Git files |
| `<leader>pr` | Recent files |
| `<leader>pb` | Open buffers |
| `<leader>pl` | Live grep |
| `<leader>ps` | Grep (prompt) |
| `<leader>pws` | Grep word |
| `<leader>pWs` | Grep WORD |
| `<leader>pd` | Diagnostics |
| `<leader>vh` | Help tags |

### Harpoon

| Key | Action |
|---|---|
| `<leader>a` | Add to harpoon |
| `<leader>h` | Harpoon menu |
| `<leader>1–5` | Jump to file 1–5 |

### Formatting

| Key | Action |
|---|---|
| `<leader>f` | Format buffer |

### Debug (DAP)

| Key | Action |
|---|---|
| `<F8>` | Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Breakpoint |
| `<leader>B` | Conditional breakpoint |
| `<leader>dr` | REPL panel |
| `<leader>ds` | Stack panel |
| `<leader>dS` | Scopes panel |
| `<leader>dw` | Watches panel |
| `<leader>db` | Breakpoints panel |
| `<leader>dc` | Console panel |

### Test (Neotest)

| Key | Action |
|---|---|
| `<leader>tr` | Run nearest test |
| `<leader>ts` | Run suite |
| `<leader>ta` | Run all in cwd |
| `<leader>tl` | Re-run last |
| `<leader>td` | Debug nearest |
| `<leader>to` | Open output |
| `<leader>tv` | Summary panel |

### Git (Fugitive)

| Key | Action |
|---|---|
| `<leader>gs` | Git status |
| `gu` / `gh` | Diffget (ours/theirs) |

### Git (Gitsigns)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>Gs` | Stage hunk |
| `<leader>Gr` | Reset hunk |
| `<leader>GS` | Stage buffer |
| `<leader>Gu` | Undo stage |
| `<leader>Gp` | Preview hunk |
| `<leader>Gb` | Toggle blame |
| `<leader>Gd` | Diff vs HEAD |
| `<leader>lg` | Lazygit |

### Terminal

| Key | Action |
|---|---|
| `<C-\>` | Toggle terminal |
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal terminal |

### Diagnostics / Trouble

| Key | Action |
|---|---|
| `<leader>tt` | Workspace diagnostics |
| `<leader>tT` | Buffer diagnostics |
| `<leader>tq` | Quickfix list |
| `[t` / `]t` | Navigate trouble items |

### Snippets

| Key | Action |
|---|---|
| `<C-j>` | Expand / jump forward |
| `<C-k>` | Jump backward |

### Zen Mode

| Key | Action |
|---|---|
| `<leader>zz` | Zen (90 cols, line numbers) |
| `<leader>zZ` | Zen (80 cols, no numbers) |

---

## First-Time Setup

```bash
# 1. Open nvim — lazy.nvim bootstraps automatically
nvim

# 2. Install / sync all plugins
:Lazy sync

# 3. Install LSP servers, formatters, debuggers
:Mason
# Ensure installed: debugpy, yamlls, jsonls, basedpyright, ruff, terraformls

# 4. Run health check
:checkhealth

# 5. (Optional) Authenticate Claude Code for AI assistance
# Claude Code runs as a separate CLI tool alongside nvim
```

## Mason — Managed Tools

| Category | Tools |
|---|---|
| LSP | basedpyright, ruff, terraformls, yamlls, jsonls, lua_ls, bashls, tailwindcss |
| Debug | debugpy (Python) |
| Lint / Format | ruff, stylua, prettier, shfmt (auto-installed via mason-tool-installer.nvim) |
