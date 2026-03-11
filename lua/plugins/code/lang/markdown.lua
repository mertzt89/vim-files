------------------------------------------------------------
-- Markdown language support
------------------------------------------------------------

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
---
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.treesitter.start()
  end,
})

---@module "lazy"
---@type LazySpec
return {
  -- Treesitter: Markdown support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
      },
    },
  },

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
