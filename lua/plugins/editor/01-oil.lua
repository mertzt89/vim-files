------------------------------------------------------------
-- Plugin: Oil
------------------------------------------------------------

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      { desc = "Oil", silent = true },
    },
  },
  opts = {},
}
