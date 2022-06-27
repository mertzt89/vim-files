--- Typescript module
local module = {}

--- Returns plugins required for this module
function module.register_plugins(use)
  use {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end
  }
end

--- Configures vim and plugins for this module
function module.init()
  local lsp = require("modules.lsp")
  local lspconfig = require("lspconfig")

  lsp.register_server(lspconfig.tsserver, {})
end

return module
