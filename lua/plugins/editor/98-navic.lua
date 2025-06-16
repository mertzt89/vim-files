return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig", "onsails/lspkind.nvim" },
  ---@module "nvim-navic"
  ---@type Options
  opts = {
    separator = " ",
    highlight = true,
    depth_limit = 5,
    icons = vim.tbl_map(function(value)
      return value .. " "
    end, require("lspkind").symbol_map),
    lazy_update_context = true,
    lsp = { auto_attach = true },
  },
  init = function()
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
}
