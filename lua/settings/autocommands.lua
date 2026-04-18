local group = vim.api.nvim_create_augroup("user", { clear = true })

-- Add support for using 'q' to close help and man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = group,
  callback = function()
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { silent = true, buffer = true })
  end,
})

-- Check if files have changed when the focus is regained
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
  group = group,
})

-- Check if files have changed when entering the buffer
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  group = group,
})
