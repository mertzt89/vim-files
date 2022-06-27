--- Language server protocol support, courtesy of Neovim
local keybind = require("lib.keybind")
local edit_mode = keybind.mode
local plug = require("lib.plug")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use)
  use({"neovim/nvim-lspconfig"})
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-cmdline'}
    },
    config = function()
      -- Setup nvim-cmp.
      local cmp = require 'cmp'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.
        }, {{name = 'buffer'}})
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
        }, {{name = 'buffer'}})
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{name = 'buffer'}}
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
      })

    end
  })

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require('null-ls').setup({
        sources = {
          -- require('null-ls').builtins.formatting.lua_format
        }
      })
    end
  }

  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      local navic = require('nvim-navic')
      local config = require('tokyonight.config')
      local colors = require('tokyonight.colors').setup(config)

      vim.api.nvim_set_hl(0, "NavicIconsFile", {fg = colors.blue})
      vim.api.nvim_set_hl(0, "NavicSeparator", {fg = colors.comment})
      vim.api.nvim_set_hl(0, "NavicText", {fg = colors.fg})
      vim.api.nvim_set_hl(0, "NavicIconsCommon", {fg = colors.blue})
      vim.api.nvim_set_hl(0, "NavicIconsModule", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsNamespace", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsPackage", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsClass", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsMethod", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsProperty", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsField", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsConstructor",
                          {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsEnum", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsInterface", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsFunction", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsVariable", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsConstant", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsString", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsNumber", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsBoolean", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsArray", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsObject", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsKey", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsNull", {link = "NavicIconsCommon"})
      vim.api
        .nvim_set_hl(0, "NavicIconsEnumMember", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsStruct", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsEvent", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsOperator", {link = "NavicIconsCommon"})
      vim.api.nvim_set_hl(0, "NavicIconsTypeParameter",
                          {link = "NavicIconsCommon"})

      navic.setup {highlight = true}
    end
  }

  use {
    'ray-x/lsp_signature.nvim',
    config = function() require("lsp_signature").setup() end
  }

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("trouble").setup {} end
  })

  use({
    "folke/lsp-trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("trouble").setup {} end
  })
end

local function user_stop_all_clients()
  local clients = vim.lsp.get_active_clients()

  if #clients > 0 then
    vim.lsp.stop_client(clients)
    for _, v in pairs(clients) do print("Stopped LSP client " .. v.name) end
  else
    print("No LSP clients are running")
  end
end

local function user_attach_client()
  local filetype = vim.bo[0].filetype

  local server = module.filetype_servers[filetype]
  if server ~= nil then
    print("Attaching LSP client " .. server.name .. " to buffer")
    server.manager.try_add()
  else
    print("No LSP client registered for filetype " .. filetype)
  end
end

--- Get the LSP status line part
function module.status_line_part()
  local clients = vim.lsp.buf_get_clients()
  local client_names = {}
  for _, v in pairs(clients) do table.insert(client_names, v.name) end

  if #client_names > 0 then
    local sections = {"LSP:", table.concat(client_names, ", ")}

    -- local error_count = vim.lsp.diagnostic.get_count("Error")
    -- if error_count ~= nil and error_count > 0 then
    --  table.insert(sections, "E: " .. error_count)
    -- end

    -- local warn_count = vim.lsp.diagnostic.get_count("Warning")
    -- if error_count ~= nil and warn_count > 0 then
    --  table.insert(sections, "W: " .. warn_count)
    -- end

    -- local info_count = vim.lsp.diagnostic.get_count("Information")
    -- if error_count ~= nil and info_count > 0 then
    --  table.insert(sections, "I: " .. info_count)
    -- end

    -- local hint_count = vim.lsp.diagnostic.get_count("Hint")
    -- if error_count ~= nil and hint_count > 0 then
    --  table.insert(sections, "H: " .. hint_count)
    -- end

    return table.concat(sections, " ")
  else
    return ""
  end
end

--- Configures vim and plugins for this module
function module.init()
  -- TODO: Fix this?
  if plug.has_plugin("snippets.nvim") then
    vim.g.completion_enable_snippet = "snippets.nvim"
  end

  -- Bind leader keys
  keybind.set_group_name("<leader>l", "LSP")
  keybind.bind_function(edit_mode.NORMAL, "<leader>ls", user_stop_all_clients,
                        nil, "Stop all LSP clients")
  keybind.bind_function(edit_mode.NORMAL, "<leader>la", user_attach_client, nil,
                        "Attach LSP client to buffer")

  vim.o.completeopt = "menuone,noinsert,noselect"
end

local bind_lsp_keys = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = {noremap = true, silent = true, buffer = bufnr}
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
                 bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations,
                 bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>D',
                 require('telescope.builtin').lsp_type_definitions, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f',
                 function() vim.lsp.buf.format({async = true}) end, bufopts)

  -- Default maps for workspace manipulation
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
  --    bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
end

--- Maps filetypes to their server definitions
--
-- <br>
-- Eg: `["rust"] = nvim_lsp.rls`
--
-- <br>
-- See `nvim_lsp` for what a server definition looks like
module.filetype_servers = {}

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

    if (caller_on_attach ~= nil) then caller_on_attach(client, bufnr) end
  end

  config.on_attach = on_attach
  config = vim.tbl_extend("keep", config, server.document_config.default_config)
  config.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

  server.setup(config)

  for _, v in pairs(config.filetypes) do
    module.filetype_servers[v] = {server = server, on_attach = caller_on_attach}
  end
end

return module
