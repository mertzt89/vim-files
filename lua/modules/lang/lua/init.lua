--- Lua module
local module = {}

--- Returns plugins required for this module
-- function module.register_plugins(use) end

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.lua_ls, {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return module
