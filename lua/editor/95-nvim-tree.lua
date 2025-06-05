local add = MiniDeps.add

add({
  source = "kyazdani42/nvim-tree.lua",
  name = "nvim-tree",
})

require("nvim-tree").setup()

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeToggle<cr>")
