return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                -- Python: ruff_format for style, ruff_fix for lint auto-fixes
                -- black is superseded by ruff; do not add it here
                python = { "ruff_format", "ruff_fix" },
                -- Terraform / HCL
                terraform = { "terraform_fmt" },
                ["terraform-vars"] = { "terraform_fmt" },
                hcl = { "terraform_fmt" },
                -- Web
                javascript = { "prettier" },
                typescript = { "prettier" },
                yaml = { "prettier" },
                json = { "prettier" },
                -- Systems
                c = { "clang_format" },
                cpp = { "clang_format" },
                go = { "gofmt" },
                -- Other
                lua = { "stylua" },
                elixir = { "mix" },
                sh = { "shfmt" },
            },
            formatters = {
                -- Use OpenTofu instead of Terraform CLI for formatting.
                -- Resolve via shell so /opt/homebrew/bin is found even if not in nvim's PATH.
                terraform_fmt = {
                    command = (function()
                        local p = vim.fn.trim(vim.fn.system("which tofu 2>/dev/null"))
                        return p ~= "" and p or "/opt/homebrew/bin/tofu"
                    end)(),
                    args = { "fmt", "-" },
                    stdin = true,
                },
                clang_format = {
                    prepend_args = { "-style=file", "-fallback-style=LLVM" },
                },
                shfmt = {
                    prepend_args = { "-i", "4" },
                },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            require("conform").format({ async = true })
        end, { desc = "Format buffer" })
    end,
}
