return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Load immediately so it can replace netrw on startup (e.g. `nvim .`)
    lazy = false,
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            -- Reload when files change outside nvim (e.g. mkdir in the term window).
            -- Skipped while the oil buffer has unsaved edits.
            watch_for_changes = true,
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == ".git" or name == ".DS_Store"
                end,
            },
            float = {
                padding = 2,
                max_width = 90,
                max_height = 0,
                border = "rounded",
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-j>"] = false,
                ["<C-k>"] = false,
                ["<C-l>"] = false,
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-r>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
        })

        -- Replace <leader>pv (was vim.cmd.Ex) with oil
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)" })
        vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open file explorer" })
        vim.keymap.set("n", "<leader>pV", function()
            require("oil").open_float()
        end, { desc = "Open file explorer (float)" })
    end,
}
