--- Typescript module
local module = {}

--- Returns plugins required for this module
function module.register_plugins(use)
    use({
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    })
end

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
    }
    vim.lsp.buf.execute_command(params)
end

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.jsonls)
    lsp.register_server(lspconfig.svelte)
    lsp.register_server(lspconfig.tsserver, {
        commands = {
            OrganizeImports = {
                organize_imports,
                description = "Organize Imports",
            },
        },
    })
end

return module
