-- Space as leader key
vim.g.mapleader = " "

-- Window Navigation
vim.keymap.set({"n", "x", "o"}, "<C-h>", "<C-w>h")
vim.keymap.set({"n", "x", "o"}, "<C-j>", "<C-w>j")
vim.keymap.set({"n", "x", "o"}, "<C-k>", "<C-w>k")
vim.keymap.set({"n", "x", "o"}, "<C-l>", "<C-w>l")

-- Commands
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>")
vim.keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>")

-- Toggles
vim.keymap.set("n", "<leader>uf", ":set foldenable!<CR>", {silent=true}) -- Toggle Folding
vim.keymap.set("n", "<leader>un", ":set relativenumber!<CR>", {silent=true}) -- Toggle Relative Number
