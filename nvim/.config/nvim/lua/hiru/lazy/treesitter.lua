return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- nvim-treesitter "main" rewrite: setup() only takes install_dir.
            -- ensure_installed/highlight/indent/etc. are no longer config keys —
            -- parsers are installed explicitly, and highlighting must be started
            -- per-buffer via vim.treesitter.start() (see :h treesitter-highlight).
            local ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua",
                "jsdoc", "bash", "terraform", "hcl",
                -- Python / AI / Data
                "python", "toml",
                -- AWS / Infrastructure
                "yaml", "json", "dockerfile",
                -- Docs
                "markdown", "markdown_inline",
            }

            require("nvim-treesitter").install(ensure_installed)

            local max_filesize = 100 * 1024 -- 100 KB

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    if ev.match == "html" then
                        return
                    end

                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 100KB, treesitter disabled for performance",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return
                    end

                    if not pcall(vim.treesitter.start) then
                        return
                    end

                    if ev.match == "markdown" then
                        -- layer legacy regex highlighting on top, same as the old
                        -- additional_vim_regex_highlighting = { "markdown" }
                        vim.bo[ev.buf].syntax = "on"
                    end
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = false,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = "outer",
                mode = "cursor",
                separator = nil,
                zindex = 20,
                on_attach = nil,
            })
        end,
    },
}
