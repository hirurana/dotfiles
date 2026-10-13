# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

The config loads in this order:
1. `init.lua` — sets mouse/clipboard globals, then delegates to `lua/hiru/`
2. `lua/hiru/init.lua` — requires `remap`, `set`, `lazy_init`; registers autocmds and LSP keymaps via `LspAttach`; registers custom filetypes (`tf`, `tfvars`, `hcl`)
3. `lua/hiru/lazy_init.lua` — bootstraps lazy.nvim (self-cloning on first run), then loads all specs from `lua/hiru/lazy/`
4. `lua/hiru/lazy/*.lua` — each file is a standalone lazy.nvim plugin spec returned as a table

**Plugin specs** in `lua/hiru/lazy/` are auto-discovered via `spec = "hiru.lazy"`. Adding a new file there is all that's needed to register a plugin.

**LSP** uses Neovim 0.11+ native API (`vim.lsp.config` / `vim.lsp.enable`) — the old `require('lspconfig').server.setup()` pattern is gone. All server config lives in `lua/hiru/lazy/lsp.lua`. LSP keymaps are in the `LspAttach` autocmd in `lua/hiru/init.lua`, not inside the lsp plugin spec.

**Formatting** is handled exclusively by conform.nvim (see `lua/hiru/lazy/conform.lua`) on `BufWritePre`. `basedpyright`'s formatting capability is explicitly disabled so ruff via conform is the sole Python formatter. Line length is 88 (ruff-compatible); colour column is set to 88 in `set.lua`.

**Terraform** uses OpenTofu (`tofu`), not `terraform`. `terraformls` is configured with a dynamic path lookup for the `tofu` binary, with an Apple Silicon Homebrew fallback (`/opt/homebrew/bin/tofu`).

## Key conventions

- Leader key is `<Space>` (set in `remap.lua`).
- Trailing whitespace is stripped on every `BufWritePre`.
- `R("module.name")` (global in `init.lua`) hot-reloads a module via plenary during development.
- Custom filetypes `terraform`, `terraform-vars`, `hcl` are registered explicitly — treesitter and LSP depend on these mappings.

## Managing plugins

`:Lazy sync` — install/update/clean.  
`:Mason` — manage LSP servers, formatters, debug adapters.  
`:checkhealth` — verify everything is wired up correctly.

After adding a new server: add it to both `ensure_installed` and `vim.lsp.enable({...})` in `lua/hiru/lazy/lsp.lua`, then run `:Mason` + `:Lazy sync`.
