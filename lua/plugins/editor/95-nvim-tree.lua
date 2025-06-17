------------------------------------------------------------
-- Plugin: Nvim Tree
------------------------------------------------------------

return {
  "kyazdani42/nvim-tree.lua",
  name = "nvim-tree",
  opts = {},
  keys = {
    { "<leader>e", "<cmd>NvimTreeFindFile<cr>" },
    { "<leader>E", "<cmd>NvimTreeToggle<cr>" },
  },
}
