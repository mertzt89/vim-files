return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "onsails/lspkind.nvim",
  },
  opts = {
    icons = vim.tbl_map(function(value)
      return value .. " "
    end, require("lspkind").symbol_map),
    lsp = { auto_attach = true },
  },
  keys = {
    { "<leader>;", "<cmd>Navbuddy<cr>", { desc = "Navbuddy" } },
  },
}
