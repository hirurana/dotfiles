return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        config = function()
            require("trouble").setup({
                modes = {
                    diagnostics = {
                        auto_close = false,
                        auto_preview = true,
                    },
                },
            })

            vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble: workspace diagnostics" })
            vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Trouble: buffer diagnostics" })
            vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "Trouble: quickfix list" })
            vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<CR>", { desc = "Trouble: location list" })

            vim.keymap.set("n", "[t", function()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    vim.diagnostic.goto_prev()
                end
            end, { desc = "Trouble/diagnostic prev" })

            vim.keymap.set("n", "]t", function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    vim.diagnostic.goto_next()
                end
            end, { desc = "Trouble/diagnostic next" })
        end
    },
}
