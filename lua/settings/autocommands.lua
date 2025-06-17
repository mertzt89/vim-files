local group = vim.api.nvim_create_augroup("user", { clear = true })

-- Add support for using 'q' to close help and man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = group,
  callback = function()
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { silent = true, buffer = true })
  end,
})
