return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")

        wk.setup({
            delay = 500,
            icons = { mappings = false },
            win = { border = "rounded" },
        })

        -- Register key group labels for discoverability
        wk.add({
            { "<leader>p",  group = "files / telescope" },
            { "<leader>v",  group = "lsp / view" },
            { "<leader>t",  group = "test / terminal" },
            { "<leader>d",  group = "debug" },
            { "<leader>g",  group = "git (fugitive)" },
            { "<leader>G",  group = "git (hunks)" },
            { "<leader>z",  group = "zen mode" },
            { "<leader>h",  group = "harpoon" },
            { "<leader>w",  desc  = "save file" },
            { "<leader>f",  desc  = "format buffer" },
            { "<leader>b",  desc  = "toggle breakpoint" },
            { "<leader>B",  desc  = "conditional breakpoint" },
            { "<leader>u",  desc  = "undotree" },
            { "<leader>lg", desc  = "lazygit" },
        })
    end,
}
