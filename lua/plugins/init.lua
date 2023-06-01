local Plugins = {
  { "tpope/vim-fugitive" },
  { "wellle/targets.vim" },
  { "tpope/vim-repeat" },
  { "kyazdani42/nvim-web-devicons", lazy = true },
  { "numToStr/Comment.nvim", config = true, event = "VeryLazy" },
  { "mg979/vim-visual-multi", lazy = false },

  -- Themes
  { "joshdick/onedark.vim" },
  { "tanvirtin/monokai.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
}

return Plugins
