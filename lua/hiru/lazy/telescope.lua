return {
    "nvim-telescope/telescope.nvim",

    cmd = "Telescope",
    keys = {
        "<leader>pf", "<C-p>", "<leader>pr", "<leader>pb",
        "<leader>pl", "<leader>ps", "<leader>pws", "<leader>pWs",
        "<leader>pd", "<leader>vh",
    },

    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55 },
                },
                file_ignore_patterns = {
                    ".git/", ".cache/", "%.o", "%.a", "%.out", "%.class",
                    "%.pdf", "%.mkv", "%.mp4", "%.zip", "node_modules/",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        telescope.load_extension("fzf")

        local cwd = vim.g.initial_cwd or vim.fn.getcwd()

        -- Files
        vim.keymap.set("n", "<leader>pf", function()
            builtin.find_files({ cwd = cwd })
        end, { desc = "Find files" })
        vim.keymap.set("n", "<C-p>", function()
            builtin.git_files({ cwd = cwd, use_git_root = false })
        end, { desc = "Git files" })
        vim.keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Open buffers" })

        -- Search
        vim.keymap.set("n", "<leader>pl", function()
            builtin.live_grep({ cwd = cwd })
        end, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ cwd = cwd, search = vim.fn.input("Grep > ") })
        end, { desc = "Grep string" })
        vim.keymap.set("n", "<leader>pws", function()
            builtin.grep_string({ cwd = cwd, search = vim.fn.expand("<cword>") })
        end, { desc = "Grep word under cursor" })
        vim.keymap.set("n", "<leader>pWs", function()
            builtin.grep_string({ cwd = cwd, search = vim.fn.expand("<cWORD>") })
        end, { desc = "Grep WORD under cursor" })

        -- Diagnostics / LSP
        vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "Workspace diagnostics" })
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Help tags" })
    end
}
