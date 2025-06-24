------------------------------------------------------------
-- Markdown language support
------------------------------------------------------------

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
---@module "lazy"
---@type LazySpec
return {
  -- Treesitter: Markdown support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = {
      "markdown",
    },
  } },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = "RenderMarkdown",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
