local util = require 'lib.util'
vim.api.nvim_create_augroup("CfgReloadGroup", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  group = "CfgReloadGroup",
  callback = function(args)
    vim.cmd("source " .. util.join_paths(vim.fn.stdpath('config'), 'init.lua'))
    require'packer'.compile()
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"lua"},
  callback = function()
    vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
    vim.api.nvim_buf_set_option(0, "tabstop", 2)
    vim.api.nvim_buf_set_option(0, "softtabstop", 4)
  end
})
