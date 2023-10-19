-- Space as leader key
vim.g.mapleader = " "

-- Window Navigation
vim.keymap.set({"n", "x", "o"}, "<C-h>", "<C-w>h")
vim.keymap.set({"n", "x", "o"}, "<C-j>", "<C-w>j")
vim.keymap.set({"n", "x", "o"}, "<C-k>", "<C-w>k")
vim.keymap.set({"n", "x", "o"}, "<C-l>", "<C-w>l")

-- Commands
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>bq", "<cmd>bdelete<cr>")
vim.keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>")
