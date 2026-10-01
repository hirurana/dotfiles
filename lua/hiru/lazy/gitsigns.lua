return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "│" },
                change       = { text = "│" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
                untracked    = { text = "┆" },
            },
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> — <summary>",

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Hunk navigation
                map("n", "]h", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next hunk" })

                map("n", "[h", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Prev hunk" })

                -- Hunk actions
                map("n", "<leader>Gs", gs.stage_hunk, { desc = "Git: Stage hunk" })
                map("n", "<leader>Gr", gs.reset_hunk, { desc = "Git: Reset hunk" })
                map("v", "<leader>Gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: Stage hunk (visual)" })
                map("v", "<leader>Gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: Reset hunk (visual)" })
                map("n", "<leader>GS", gs.stage_buffer, { desc = "Git: Stage buffer" })
                map("n", "<leader>Gu", gs.undo_stage_hunk, { desc = "Git: Undo stage hunk" })
                map("n", "<leader>Gp", gs.preview_hunk, { desc = "Git: Preview hunk" })
                map("n", "<leader>Gb", gs.toggle_current_line_blame, { desc = "Git: Toggle line blame" })
                map("n", "<leader>Gd", gs.diffthis, { desc = "Git: Diff this" })
                map("n", "<leader>GD", function() gs.diffthis("~") end, { desc = "Git: Diff this ~" })
            end,
        })
    end,
}
