--- Python module
local module = {}

--- Returns plugins required for this module
function module.register_plugins(use) end

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.pylsp, {
        settings = {
            pylsp = {
                configurationSources = { "flake8" },
                plugins = {
                    autopep8 = {
                        enabled = false
                    },
                    black = {
                        enabled = true
                    },
                    flake8 = {
                        enabled = true
                    },
                    pycodestyle = {
                        enabled = false
                    },
                    yapf = {
                        enabled = false
                    }
                }
            }
        }
    })
end

return module
