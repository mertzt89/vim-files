local M = {}

function M.setup(lsp_setup)
  lsp_setup {
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
    },
  }
end

return M
