local M = {}
local default_opts = { trim_whitespace = true, lsp = { format_on_save = true, clangd = { extra_args = {} } } }

function M.defaults()
  return vim.deepcopy(default_opts)
end

M.config = M.defaults()

function M.configure(opts)
  M.config = vim.tbl_deep_extend("force", M.defaults(), opts)
end

return M
