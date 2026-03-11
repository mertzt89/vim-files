------------------------------------------------------------
-- Rust language support
------------------------------------------------------------

vim.lsp.enable("taplo")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "toml" },
  callback = function()
    vim.treesitter.start()
  end,
})

return {
  -- Mason: Install rust-analyzer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "rust-analyzer", "taplo" },
    },
  },

  -- Treesitter: Rust/Toml support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "rust", "toml" },
    },
  },

  -- Rustacean
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
