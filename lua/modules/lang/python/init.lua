--- Python module
local module = {}

--- Returns plugins required for this module
function module.register_plugins(use) end

--- Configures vim and plugins for this module
function module.init()
  local lsp = require("modules.lsp")
  local lspconfig = require("lspconfig")

  lsp.register_server(lspconfig.pylsp, {})
end

return module
