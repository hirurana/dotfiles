return {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_preserve_zoom = 1
    end,
    config = function()
        local opts = { noremap = true, silent = true }
        local function set_nav_maps()
            vim.keymap.set({ "n", "t" }, "<C-h>",  "<cmd>TmuxNavigateLeft<CR>",     opts)
            vim.keymap.set({ "n", "t" }, "<C-j>",  "<cmd>TmuxNavigateDown<CR>",     opts)
            vim.keymap.set({ "n", "t" }, "<C-k>",  "<cmd>TmuxNavigateUp<CR>",       opts)
            vim.keymap.set({ "n", "t" }, "<C-l>",  "<cmd>TmuxNavigateRight<CR>",    opts)
            vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", opts)
        end

        -- Set immediately (covers eager-loaded plugins and non-tmux use).
        set_nav_maps()

        -- Re-assert after VeryLazy so lazy plugins (toggleterm etc.) can't win.
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = set_nav_maps,
        })
    end,
}
