-- lua/hiru/lazy/lsp_signature.lua
return {
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_signature").setup({
        floating_window = true,
        hint_enable = false, -- inline hints can get noisy
        handler_opts = { border = "rounded" },
        always_trigger = false,
      })
    end,
  },
}
