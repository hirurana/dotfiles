require("hiru.remap")
require("hiru.set")
require("hiru.lazy_init")

local augroup = vim.api.nvim_create_augroup
local HiruGroup = augroup('Hiru', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

-- Register filetypes not built into Neovim's runtime
vim.filetype.add({
    extension = {
        tf      = "terraform",
        tfvars  = "terraform-vars",
        tfstate = "json",
        hcl     = "hcl",
    },
})


autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = HiruGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- YAML: 2-space indents (the global default in set.lua is 4)
autocmd("FileType", {
    group = HiruGroup,
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

autocmd("FocusGained", {
    group = HiruGroup,
    callback = function()
        vim.cmd("checktime")
    end,
})


autocmd('LspAttach', {
    group = HiruGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

