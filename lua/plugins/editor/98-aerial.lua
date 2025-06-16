return {
  "stevearc/aerial.nvim",
  opts = {},
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "AerialToggle" },
  keys = {
    { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Toggle outline" },
  },
}
