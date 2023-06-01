local M = {}

local function on_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp_cmds",
  desc = "LSP actions",
  callback = on_attach,
})

function M.setup(lsp_setup)
  local lspconfig = require "lspconfig"

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")

  table.insert(runtime_path, "lua/?/init.lua")
  local capabilities = {
    textDocument = {
      documentFormattingProvider = false,
      documentRangeFormattingProvider = false,
    },
  }

  lsp_setup {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          library = {
            -- Make the server aware of Neovim runtime files
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.stdpath "config" .. "/lua",
          },
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

return M
