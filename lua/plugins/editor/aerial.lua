return {
  "stevearc/aerial.nvim",
  lazy = true,
  opts = {},

  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "AerialToggle" },
  keys = {
    { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Toggle outline" },
  },
}
