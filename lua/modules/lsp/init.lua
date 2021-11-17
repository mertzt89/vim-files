--- Language server protocol support, courtesy of Neovim
local keybind = require("lib.keybind")
local edit_mode = keybind.mode
local autocmd = require("lib.autocmd")
local plug = require("lib.plug")

local module = {}

--- Returns plugins required for this module
function module.register_plugins()
  plug.use({"neovim/nvim-lspconfig"})
  plug.use({
    "hrsh7th/nvim-compe",
    config = function()
      require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          nvim_lua = true,
          vsnip = true
        }
      }
    end
  })
  plug.use({
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

    local error_count = vim.lsp.diagnostic.get_count("Error")
    if error_count ~= nil and error_count > 0 then
      table.insert(sections, "E: " .. error_count)
    end

    local warn_count = vim.lsp.diagnostic.get_count("Warning")
    if error_count ~= nil and warn_count > 0 then
      table.insert(sections, "W: " .. warn_count)
    end

    local info_count = vim.lsp.diagnostic.get_count("Information")
    if error_count ~= nil and info_count > 0 then
      table.insert(sections, "I: " .. info_count)
    end

    local hint_count = vim.lsp.diagnostic.get_count("Hint")
    if error_count ~= nil and hint_count > 0 then
      table.insert(sections, "H: " .. hint_count)
    end

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

  -- Tabbing
-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
--_G.tab_complete = function()
--  if vim.fn.pumvisible() == 1 then
--    return t "<C-n>"
--  elseif vim.fn.call("vsnip#available", {1}) == 1 then
--    return t "<Plug>(vsnip-expand-or-jump)"
--  elseif check_back_space() then
--    return t "<Tab>"
--  else
--    return vim.fn['compe#complete']()
--  end
--end
--_G.s_tab_complete = function()
--  if vim.fn.pumvisible() == 1 then
--    return t "<C-p>"
--  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
--    return t "<Plug>(vsnip-jump-prev)"
--  else
--    -- If <S-Tab> is not working in your terminal, change it to <C-h>
--    return t "<S-Tab>"
--  end
--end
--  keybind.bind_command(edit_mode.INSERT, "<tab>", "v:lua.tab_complete()", { noremap = true, expr = true })
--  keybind.bind_command(edit_mode.INSERT, "<S-tab>", "v:lua.s_tab_complete()", { noremap = true, expr = true })

  vim.o.completeopt = "menuone,noinsert,noselect"

  -- Jumping to places
  autocmd.bind_filetype("*", function()
    local server = module.filetype_servers[vim.bo.ft]
    if server ~= nil then
      keybind.buf_bind_command(edit_mode.NORMAL, "gd",
                               ":lua vim.lsp.buf.declaration()<CR>",
                               {noremap = true})
      keybind.buf_bind_command(edit_mode.NORMAL, "gD",
                                ":lua require'telescope.builtin'.lsp_implementations{}<CR>", {noremap = true},
                               {noremap = true})
      keybind.buf_bind_command(edit_mode.NORMAL, "<C-]>",
                                ":lua require'telescope.builtin'.lsp_definitions{}<CR>", {noremap = true},
                               {noremap = true})
      keybind.buf_bind_command(edit_mode.NORMAL, "K",
                               ":lua vim.lsp.buf.hover()<CR>", {noremap = true})
    end
  end)

  keybind.bind_command(edit_mode.NORMAL, "<leader>lr",
                       ":lua require'telescope.builtin'.lsp_references{}<CR>", {noremap = true},
                       "Find references")
  keybind.bind_command(edit_mode.NORMAL, "<leader>lR",
                       ":lua vim.lsp.buf.rename()<CR>", {noremap = true},
                       "Rename")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ld",
                       ":lua require'telescope.builtin'.lsp_document_symbols{}<CR>", {noremap = true},
                       {noremap = true}, "Document symbol list")

  -- Show docs when the cursor is held over something
  -- autocmd.bind_cursor_hold(function()
  -- vim.cmd("lua vim.lsp.buf.hover()")
  -- end)
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
  -- config.on_attach = completion.on_attach
  config = vim.tbl_extend("keep", config, server.document_config.default_config)

  server.setup(config)

  for _, v in pairs(config.filetypes) do module.filetype_servers[v] = server end
end

return module

