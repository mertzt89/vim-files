local M = {}

function M.setup(lsp_setup)
  lsp_setup { capabilities = { offsetEncoding = "utf-8" } }
end

return M
