local M = {}

vim.api.nvim_set_hl(0, "WinBarTS", {link = "StatusLine"})
vim.api.nvim_set_hl(0, "WinBarTSSep", {link = "Directory"})

local treesitter_context = require"modules.lang.treesitter".context

function M.eval()
  local columns = vim.api.nvim_get_option("columns")
  local context = treesitter_context(columns, "%#WinBarTSSep#  %#WinBarTS#")
  context = context or ""
  return "%#WinBarTSSep#" .. "  " .. "%#WinBarTS#" .. context .. "%*"
end
return M
