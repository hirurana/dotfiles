return {
    "nvim-neotest/neotest",
    keys = {
        "<leader>tr", "<leader>tv", "<leader>ts", "<leader>td",
        "<leader>to", "<leader>ta", "<leader>tl",
    },
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    runner = "pytest",
                    python = function()
                        -- Prefer active virtualenv; fall back to system python
                        return os.getenv("VIRTUAL_ENV") and (os.getenv("VIRTUAL_ENV") .. "/bin/python") or "python3"
                    end,
                }),
            },
        })

        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run()
        end, { desc = "Test: Run nearest" })

        vim.keymap.set("n", "<leader>tv", function()
            require("neotest").summary.toggle()
        end, { desc = "Test: Toggle summary" })

        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({ suite = true })
        end, { desc = "Test: Run suite" })

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({ strategy = "dap" })
        end, { desc = "Test: Debug nearest" })

        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open({ enter = true })
        end, { desc = "Test: Open output" })

        vim.keymap.set("n", "<leader>ta", function()
            require("neotest").run.run(vim.fn.getcwd())
        end, { desc = "Test: Run all in cwd" })

        vim.keymap.set("n", "<leader>tl", function()
            require("neotest").run.run_last()
        end, { desc = "Test: Re-run last" })
    end
}
