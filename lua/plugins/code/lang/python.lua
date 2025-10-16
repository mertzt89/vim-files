vim.lsp.config("ruff", {})
vim.lsp.config("ty", {})

vim.lsp.enable("ruff")
vim.lsp.enable("ty")

return {
  -- Mason: Install ruff and ty
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "ruff", "ty" },
    },
  },

  -- Treesitter: JSON support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = { "python" },
  } },
}
