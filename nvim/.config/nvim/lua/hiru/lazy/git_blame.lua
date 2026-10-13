return {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    config = function()
        require("gitblame").setup({
            enabled = false,
            message_template = " <author> • <date> • <summary>",
            date_format = "%Y-%m-%d",
            virtual_text_column = nil,
            highlight_group = "Comment",
            display_virtual_text = true,
            ignored_filetypes = { "fugitive", "help", "NvimTree", "oil" },
        })

        local map = vim.keymap.set
        map("n", "<leader>gB", "<cmd>GitBlameToggle<CR>",        { desc = "Git Blame: Toggle" })
        map("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<CR>", { desc = "Git Blame: Open commit URL" })
        map("n", "<leader>gy", "<cmd>GitBlameCopySHA<CR>",       { desc = "Git Blame: Copy SHA" })
        map("n", "<leader>gY", "<cmd>GitBlameCopyCommitURL<CR>", { desc = "Git Blame: Copy commit URL" })
    end,
}
