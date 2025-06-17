------------------------------------------------------------
-- Language Server Protocol (LSP) Plugins
------------------------------------------------------------
return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", config = true },
    opts = {
      ensure_installed = {},
    },
    opts_extend = { "ensure_installed" }
  },
}
