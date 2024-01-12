return {
  require("util.spec").ts_ensure_installed({ "prisma" }),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        prismals = {},
      },
    },
  },
}
