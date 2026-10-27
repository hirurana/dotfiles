vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Save / quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })

-- Recenter after moving through the page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Delete to void register (don't clobber clipboard)
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to void" })

-- Keep paste register when pasting over selection
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without clobbering" })


-- Toggle comments with Ctrl+/ (the Ghostty config sends this for Cmd+/). Uses Neovim's
-- built-in gc/gcc, which picks the comment marker per language via treesitter.
-- Terminals send Ctrl+/ as <C-_>; <C-/> covers terminals that report it as-is.
for _, key in ipairs({ "<C-_>", "<C-/>" }) do
    vim.keymap.set("n", key, "gcc", { remap = true, desc = "Toggle line comment" })
    vim.keymap.set("x", key, "gc", { remap = true, desc = "Toggle comment on selection" })
end
