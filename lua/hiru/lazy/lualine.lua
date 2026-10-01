return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- Show active Python virtualenv name in statusline
        local function python_venv()
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
            if venv and vim.bo.filetype == "python" then
                return "(" .. vim.fn.fnamemodify(venv, ":t") .. ")"
            end
            return ""
        end

        require("lualine").setup({
            options = {
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "lazy" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    { "branch", fmt = function(str) return #str > 20 and str:sub(1, 20) .. "…" or str end },
                    { "diff", symbols = { added = " ", modified = " ", removed = " " } },
                    { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
                },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { python_venv, "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "location" },
            },
        })
    end,
}
