return {
  -- Treesitter
  require("util.spec").ts_ensure_installed({ "php" }),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("php") == 1 then
        vim.tbl_extend("force", opts, {
          servers = {
            phpactor = {},
          },
        })
      end
    end,
  },
}
