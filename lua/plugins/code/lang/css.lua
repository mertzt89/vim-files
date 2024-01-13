-- Treat `*.postcss` and `*.pcss` as ft=css
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.postcss", "*.pcss" },
  callback = function()
    vim.bo.ft = "css"
  end,
})

return {}
