-- Autocommand to enable spell checking for Git commits
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function()
    vim.o.spell = true
  end,
})

return {}
