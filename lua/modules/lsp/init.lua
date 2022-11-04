--- Language server protocol support, courtesy of Neovim
local plug = require("lib.plug")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use)
    use({ "neovim/nvim-lspconfig" })
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
        },
        config = function()
            -- Setup nvim-cmp.
            local cmp = require("cmp")
            local types = require("cmp.types")

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-k>"] = {
                        i = cmp.mapping.select_prev_item({
                            behavior = types.cmp.SelectBehavior.Insert,
                        }),
                    },
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" }, -- For vsnip users.
                }, { { name = "buffer" } }),
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
                }, { { name = "buffer" } }),
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            })
        end,
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup({
                sources = {
                    -- require('null-ls').builtins.formatting.lua_format
                },
            })
        end,
    })

    use({
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig",
        config = function()
            local navic = require("nvim-navic")
            local config = require("tokyonight.config")
            local colors = require("tokyonight.colors").setup(config)

            vim.api.nvim_set_hl(0, "NavicIconsFile", { fg = colors.blue })
            vim.api.nvim_set_hl(0, "NavicSeparator", { fg = colors.comment })
            vim.api.nvim_set_hl(0, "NavicText", { fg = colors.fg })
            vim.api.nvim_set_hl(0, "NavicIconsCommon", { fg = colors.blue })
            vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsField", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsString", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "NavicIconsCommon" })
            vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "NavicIconsCommon" })

            navic.setup({ highlight = true })
        end,
    })

    use({
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup()
        end,
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                auto_open = true,
                auto_close = true,
            })
        end,
    })

    use({
        "folke/lsp-trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({})
        end,
    })

    use({
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })

    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true,
            })
        end,
    }
end

--- Configures vim and plugins for this module
function module.init()
    -- TODO: Fix this?
    if plug.has_plugin("snippets.nvim") then
        vim.g.completion_enable_snippet = "snippets.nvim"
    end

    vim.o.completeopt = "menuone,noinsert,noselect"
end

local bind_lsp_keys = function(client, bufnr)
    local wk = require("which-key")
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.register({
        ["ga"] = { vim.lsp.buf.code_action, "Code Action", buffer = bufnr },
        ["gD"] = { vim.lsp.buf.declaration, "Goto Declaration", buffer = bufnr },
        ["gd"] = {
            require("telescope.builtin").lsp_definitions,
            "Definitions",
            buffer = bufnr,
        },
        ["K"] = { vim.lsp.buf.hover, "Hover", buffer = bufnr },
        ["gk"] = { vim.diagnostic.open_float, "Diagnotic Info", buffer = bufnr },
        ["gK"] = {
            require("telescope.builtin").diagnostics,
            "Diagnostics",
            buffer = bufnr,
        },
        ["gi"] = {
            require("telescope.builtin").lsp_implementations,
            "Implementations",
            buffer = bufnr,
        },
        ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature", buffer = bufnr },
        ["<space>D"] = {
            require("telescope.builtin").lsp_type_definitions,
            "Typedefs",
            buffer = bufnr,
        },
        ["<space>rn"] = { vim.lsp.buf.rename, "Rename", buffer = bufnr },
        ["gr"] = {
            require("telescope.builtin").lsp_references,
            "References",
            buffer = bufnr,
        },
        ["<space>f"] = {
            function()
                vim.lsp.buf.format({ async = true })
            end,
            "Format Buffer",
            buffer = bufnr,
        },
    })
end

function module.current_buf_attached()
    return (next(vim.lsp.buf_get_clients(0)) ~= nil)
end

--- Register an LSP server
--
-- @param server An LSP server definition (in the format expected by `nvim_lsp`)
-- @param config The config for the server (in the format expected by `nvim_lsp`)
function module.register_server(server, config)
    -- local completion = require("completion") -- From completion-nvim

    config = config or {}
    local caller_on_attach = config.on_attach

    local on_attach = function(client, bufnr)
        local navic = require("nvim-navic")

        bind_lsp_keys(client, bufnr)
        navic.attach(client, bufnr)

        if caller_on_attach ~= nil then
            caller_on_attach(client, bufnr)
        end
    end

    config.on_attach = on_attach
    config = vim.tbl_extend("keep", config, server.document_config.default_config)
    config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    server.setup(config)
end

return module
