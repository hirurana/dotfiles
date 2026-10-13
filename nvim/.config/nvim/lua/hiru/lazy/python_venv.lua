return {
  {
    "tnfru/nvim-venv-detector",
    event = "VimEnter",
    config = function()
      require("venv_detector").setup({
        auto_activate_venv = true,
        auto_restart_lsp = true,
        -- It already knows how to find .venv / venv / Poetry / uv envs by default.
      })
    end,
  },
}

