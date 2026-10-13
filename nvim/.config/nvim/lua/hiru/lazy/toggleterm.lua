return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-\>]],
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 3,
            },
        })

        -- Lazygit integration
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = { border = "curved" },
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>",
                    { noremap = true, silent = true })
            end,
        })

        vim.keymap.set("n", "<leader>lg", function() lazygit:toggle() end,
            { desc = "Toggle lazygit" })
        vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",
            { desc = "Terminal: float" })
        vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>",
            { desc = "Terminal: horizontal split" })
        vim.keymap.set("n", "<leader>tv2", "<cmd>ToggleTerm direction=vertical<CR>",
            { desc = "Terminal: vertical split" })

        -- In terminal mode, use <C-\><C-n> to go back to normal mode (built-in)
        -- or map a simpler escape:
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Window left from terminal" })
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Window down from terminal" })
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Window up from terminal" })
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Window right from terminal" })
    end,
}
