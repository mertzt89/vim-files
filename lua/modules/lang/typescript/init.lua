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

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.tsserver, {
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    if require("lib.project").config.lsp.format_on_save then
                        vim.lsp.buf.format({ async = false })
                    end
                end,
            })
        end,
    })

    lsp.register_server(lspconfig.svelte, {
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    if require("lib.project").config.lsp.format_on_save then
                        vim.lsp.buf.format({ async = false })
                    end
                end,
            })
        end,
    })
end

return module
