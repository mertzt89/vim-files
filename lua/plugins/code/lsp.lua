local Plugin = { "neovim/nvim-lspconfig" }
local user = {}
local thisPath = ...
local _keys = nil

local function get_keys()
  if _keys then
    return _keys
  end

  local fzf = function(command, opts)
    return function()
      require("fzf-lua")[command](opts)
    end
  end

  _keys = {
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    {
      "gd",
      fzf("lsp_definitions", { jump_to_single_result = true }),
      desc = "Goto Definition",
    },
    { "gr", fzf("lsp_references", { jump_to_single_result = true }), desc = "References" },
    { "gD", fzf("lsp_declarations", { jump_to_single_result = true }), desc = "Goto Declaration" },
    { "gi", fzf("lsp_implementations", { jump_to_single_result = true }), desc = "Goto Implementation" },
    { "gI", fzf("lsp_incoming_calls", { jump_to_single_result = true }), desc = "Incoming Calls" },
    { "gy", fzf("lsp_typedefs", { jump_to_single_result = true }), desc = "Goto T[y]pe Definition" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
    { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Open Float" },
    { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev. Diagnostic" },
    { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next. Diagnostic" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", mode = { "n", "v" } },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action",
    },
  }

  return _keys
end

local function has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = require("util").lsp_get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

local function resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = get_keys()
  local opts = require("util").opts("nvim-lspconfig")
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

local function on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

Plugin.dependencies = {
  { "folke/neoconf.nvim" },
  { "folke/neodev.nvim", opts = {} },
  { "hrsh7th/cmp-nvim-lsp" },
  { "williamboman/mason-lspconfig.nvim" },
}

Plugin.cmd = { "LspInfo", "LspInstall", "LspUnInstall" }

Plugin.event = { "LazyFile" }

function Plugin.init()
  local sign = function(opts)
    -- See :help sign_define()
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end

  sign({ name = "DiagnosticSignError", text = "✘" })
  sign({ name = "DiagnosticSignWarn", text = "▲" })
  sign({ name = "DiagnosticSignHint", text = "⚑" })
  sign({ name = "DiagnosticSignInfo", text = "»" })

  -- See :help vim.diagnostic.config()
  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

function Plugin.config(_, opts)
  -- Load neoconf
  if require("lazy.core.config").spec.plugins["neoconf.nvim"] ~= nil then
    local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
  end

  -- See :help lspconfig-global-defaults
  local lspconfig = require("lspconfig")
  local lsp_defaults = lspconfig.util.default_config

  lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

  require("util").lsp_on_attach(on_attach)

  -- Gather configured servers to install
  local ensure_installed = {} ---@type string[]
  for server, server_opts in pairs(opts.servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      ensure_installed[#ensure_installed + 1] = server
    end
  end

  -- See :help mason-lspconfig-settings
  require("mason-lspconfig").setup({
    ensure_installed = ensure_installed,
    handlers = {
      -- See :help mason-lspconfig-dynamic-server-setup
      function(server)
        local server_opts = opts.servers[server] or {}

        server_opts.capabilities =
          vim.tbl_deep_extend("force", {}, lsp_defaults.capabilities, server_opts.capabilities or {})

        if opts.setup and opts.setup[server] then
          opts.setup[server](server, server_opts)
          return
        else
          -- See :help lspconfig-setup
          lspconfig[server].setup(server_opts)
        end
      end,
    },
  })
end

return Plugin
