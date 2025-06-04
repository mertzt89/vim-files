local add = MiniDeps.add

add({source = "neovim/nvim-lspconfig"})

add({
  source = "williamboman/mason-lspconfig.nvim",
  depends = { "williamboman/mason.nvim" },
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = require("util.mason").get_ensure(),
})
