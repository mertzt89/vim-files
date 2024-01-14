-- Treat `*.postcss` and `*.pcss` as ft=css
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.postcss", "*.pcss" },
  callback = function()
    vim.bo.ft = "css"
  end,
})

return {
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background", -- or 'foreground' or 'first_column'
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
}
