local M = {}

--- Lists server names that are configured in <config>/lsp
function M.list()
  local lsp_path = vim.fn.stdpath("config") .. "/lsp"
  local names = vim.fn.readdir(lsp_path, [[v:val =~ '\.lua$']])
  local servers = {}
  for _, name in ipairs(names) do
    if name:sub(-4) == ".lua" then
      local server_name = name:sub(1, -5)
      table.insert(servers, server_name)
    end
  end
  return servers
end

function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client:supports_method(opts.method, opts.bufnr)
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
