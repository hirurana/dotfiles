-- ~/.config/nvim/lua/plugins/lazy/comment.lua
return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  config = function()
    require("Comment").setup()
    local api = require("Comment.api")

    vim.keymap.set("n", "<C-_>", api.toggle.linewise.current,
      { noremap = true, silent = true, desc = "Toggle line comment" })

    vim.keymap.set("v", "<C-_>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { noremap = true, silent = true, desc = "Toggle line comment (visual)" })
  end,
}

