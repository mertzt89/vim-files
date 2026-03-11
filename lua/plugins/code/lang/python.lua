vim.lsp.config("ruff", {})
vim.lsp.config("ty", {})

vim.lsp.enable("ruff")
vim.lsp.enable("ty")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.treesitter.start()
  end,
})

return {
  -- Mason: Install ruff and ty
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "ruff", "ty" },
    },
  },

  -- Treesitter: JSON support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },
}
