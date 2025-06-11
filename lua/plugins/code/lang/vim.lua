------------------------------------------------------------
-- Vim language support
------------------------------------------------------------

return {
  -- Treesitter: Vim/Vimdoc support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
      },
    },
  },
}
