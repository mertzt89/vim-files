------------------------------------------------------------
-- Colorscheme configuration (Tokyonight)
------------------------------------------------------------

return {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    style = "night",
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
