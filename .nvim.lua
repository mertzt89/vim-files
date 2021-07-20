local autocmd = require'lib.autocmd'
autocmd.bind("BufWritePost *.lua", require'packer'.compile())

local function on_filetype_lua()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
end

autocmd.bind_filetype("lua", on_filetype_lua)
