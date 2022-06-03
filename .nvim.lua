local util = require'lib.util'
local autocmd = require'lib.autocmd'
vim.api.nvim_create_augroup("CfgReloadGroup", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost *.lua",
  {
    group = "CfgReloadGroup",
    callback = function(args)
        vim.cmd("source "..util.join_paths(vim.fn.stdpath('config'),'init.lua'))
        require'packer'.compile()
      end
  })

local function on_filetype_lua()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
end

autocmd.bind_filetype("lua", on_filetype_lua)
