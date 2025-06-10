------------------------------------------------------------
-- Language Server Protocol (LSP) Plugins
------------------------------------------------------------
return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", lazy = true },
    lazy = true,
  },
}
