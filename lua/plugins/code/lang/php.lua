return {
  -- Treesitter
  require("util.spec").ts_ensure_installed({ "php" }),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {},
      },
    },
  },
}
