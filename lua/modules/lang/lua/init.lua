--- Lua module
local autocmd = require("lib.autocmd")

local module = {}

local function on_filetype_lua()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
end

--- Returns plugins required for this module
function module.register_plugins() end

--- Configures vim and plugins for this module
function module.init()
  local lsp = require("modules.lsp")
  local lspconfig = require("lspconfig")

  -- TODO: Make this configurable per-project
  -- lsp.register_server(
  --  lspconfig.sumneko_lua,
  --  {
  --    settings = {
  --      Lua = {
  --        diagnostics = {
  --          globals = {
  --            "vim",
  --          },
  --        },
  --      },
  --    },
  --  }
  -- )

  -- autocmd.bind_filetype("lua", on_filetype_lua)
end

return module

