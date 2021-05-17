 --- Language server protocol support, courtesy of Neovim

local keybind = require("lib.keybind")
local edit_mode = keybind.mode
local autocmd = require("lib.autocmd")
local plugman = require("lib.plugman")

local module = {}

--- Returns plugins required for this module
function module.register_plugins()
  plugman.use({"neovim/nvim-lspconfig"})
  plugman.use({"hrsh7th/nvim-compe", config = function()
    require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = true;

        source = {
            path = true;
            buffer = true;
            calc = true;
            nvim_lsp = true;
            nvim_lua = true;
            vsnip = true;
        };
    }
  end})
  plugman.use({
    "folke/lsp-trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
      }
  end })
end

local function user_stop_all_clients()
  local clients = vim.lsp.get_active_clients()

  if #clients > 0 then
    vim.lsp.stop_client(clients)
    for _, v in pairs(clients) do
      print("Stopped LSP client " .. v.name)
    end
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

--- Get the LSP status line part for vim-airline
function module._get_airline_part()
  local clients = vim.lsp.buf_get_clients()
  local client_names = {}
  for _, v in pairs(clients) do
    table.insert(client_names, v.name)
  end

  if #client_names > 0 then
    local sections = { "LSP:", table.concat(client_names, ", ") }

    local error_count = vim.lsp.diagnostic.get_count("Error")
    if error_count ~= nil and error_count > 0 then table.insert(sections, "E: " .. error_count) end

    local warn_count = vim.lsp.diagnostic.get_count("Warning")
    if error_count ~= nil and warn_count > 0 then table.insert(sections, "W: " .. warn_count) end

    local info_count = vim.lsp.diagnostic.get_count("Information")
    if error_count ~= nil and info_count > 0 then table.insert(sections, "I: " .. info_count) end

    local hint_count = vim.lsp.diagnostic.get_count("Hint")
    if error_count ~= nil and hint_count > 0 then table.insert(sections, "H: " .. hint_count) end

    return table.concat(sections, " ")
  else
    return ""
  end
end

--- Configures vim and plugins for this module
function module.init()
  --vim.api.nvim_set_var("completion_enable_in_comment", 1)
  --vim.api.nvim_set_var("completion_trigger_on_delete", 1)

  -- TODO: Fix this?
  if plugman.has_plugin("snippets.nvim") then
    vim.g.completion_enable_snippet = "snippets.nvim"
  end

  -- Bind leader keys
  keybind.set_group_name("<leader>l", "LSP")
  keybind.bind_function(edit_mode.NORMAL, "<leader>ls", user_stop_all_clients, nil, "Stop all LSP clients")
  keybind.bind_function(edit_mode.NORMAL, "<leader>la", user_attach_client, nil, "Attach LSP client to buffer")

  -- Tabbing
  --keybind.bind_command(edit_mode.INSERT, "<tab>", "pumvisible() ? '<C-n>' : '<tab>'", { noremap = true, expr = true })
  --keybind.bind_command(edit_mode.INSERT, "<S-tab>", "pumvisible() ? '<C-p>' : '<S-tab>'", { noremap = true, expr = true })
--	imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
--			\ "\<Plug>(completion_confirm_completion)"  :
--			\ "\<c-e>\<CR>" : "\<CR>"

  --autocmd.bind_complete_done(function()
  --  if vim.fn.pumvisible() == 0 then
  --    vim.cmd("pclose")
  --  end
  --end)

  vim.o.completeopt = "menuone,noinsert,noselect"

  -- Jumping to places
  autocmd.bind_filetype("*", function()
    local server = module.filetype_servers[vim.bo.ft]
    if server ~= nil then
      keybind.buf_bind_command(edit_mode.NORMAL, "gd", ":lua vim.lsp.buf.declaration()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gD", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "<C-]>", ":lua vim.lsp.buf.definition()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })
      -- keybind.bind_command(edit_mode.NORMAL, "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
    end
  end)

  keybind.bind_command(edit_mode.NORMAL, "<leader>lr", ":lua vim.lsp.buf.references()<CR>", { noremap = true }, "Find references")
  keybind.bind_command(edit_mode.NORMAL, "<leader>lR", ":lua vim.lsp.buf.rename()<CR>", { noremap = true }, "Rename")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ld", ":lua vim.lsp.buf.document_symbol()<CR>", { noremap = true }, "Document symbol list")

  keybind.set_group_name("<leader>j", "Jump")
  keybind.bind_command(edit_mode.NORMAL, "<leader>jd", ":lua vim.lsp.buf.declaration()<CR>", { noremap = true }, "Jump to declaration")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ji", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true }, "Jump to implementation")
  keybind.bind_command(edit_mode.NORMAL, "<leader>jf", ":lua vim.lsp.buf.definition()<CR>", { noremap = true }, "Jump to definition")

  -- Show docs when the cursor is held over something
  -- autocmd.bind_cursor_hold(function()
    -- vim.cmd("lua vim.lsp.buf.hover()")
  -- end)

  -- Show in vim-airline the attached LSP client
  if plugman.has_plugin("vim-airline") then
    vim.api.nvim_exec(
      [[
      function! CLspGetAirlinePart()
        return luaeval("require('modules.lsp')._get_airline_part()")
      endfunction
      ]],
      false
      )
    vim.fn["airline#parts#define_function"]("c_lsp", "CLspGetAirlinePart")
    vim.fn["airline#parts#define_accent"]("c_lsp", "yellow")
    vim.g.airline_section_y = vim.fn["airline#section#create_right"]{"c_lsp", "ffenc"}
  end
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
  --local completion = require("completion") -- From completion-nvim

  config = config or {}
  --config.on_attach = completion.on_attach
  config = vim.tbl_extend("keep", config, server.document_config.default_config)

  server.setup(config)

  for _, v in pairs(config.filetypes) do
    module.filetype_servers[v] = server
  end
end

return module

