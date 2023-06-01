local Plugin = { "neovim/nvim-lspconfig" }
local user = {}

Plugin.dependencies = {
  { "hrsh7th/cmp-nvim-lsp" },
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  { "jose-elias-alvarez/null-ls.nvim" },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "LspInstall", "LspUnInstall" },
    config = function()
      user.setup_null_ls()
      user.setup_mason()
    end,
  },
}

Plugin.cmd = "LspInfo"

Plugin.event = { "BufReadPre", "BufNewFile" }

function Plugin.init()
  local sign = function(opts)
    -- See :help sign_define()
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end

  sign { name = "DiagnosticSignError", text = "✘" }
  sign { name = "DiagnosticSignWarn", text = "▲" }
  sign { name = "DiagnosticSignHint", text = "⚑" }
  sign { name = "DiagnosticSignInfo", text = "»" }

  -- See :help vim.diagnostic.config()
  vim.diagnostic.config {
    virtual_text = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

function Plugin.config()
  local group = vim.api.nvim_create_augroup("lsp_cmds", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "LSP actions",
    callback = user.on_attach,
  })

  -- See :help mason-lspconfig-dynamic-server-setup
  require("mason-lspconfig").setup_handlers {
    function(server)
      -- See :help lspconfig-setup
      user.setup_lsp(server, {})
    end,
    ["tsserver"] = function()
      user.setup_lsp("tsserver", {
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      })
    end,
    ["lua_ls"] = function()
      require("plugins.lsp.lua_ls").setup(function(config)
        user.setup_lsp("lua_ls", config)
      end)
    end,
  }
end

function user.setup_lsp(server, config)
  local lspconfig = require "lspconfig"
  local lsp_defaults = lspconfig.util.default_config

  lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

  local merged = vim.tbl_deep_extend("force", lsp_defaults, config)
  lspconfig[server].setup(merged)
end

function user.setup_mason()
  -- See :help mason-settings
  require("mason").setup {
    ui = { border = "rounded" },
    ensure_installed = {
      "stylua",
      "clang-format",
    },
  }

  -- See :help mason-lspconfig-settings
  require("mason-lspconfig").setup {
    ensure_installed = {
      "eslint",
      "tsserver",
      "html",
      "cssls",
      "lua_ls",
      "clangd",
      "pylsp",
    },
  }
end

function user.setup_null_ls()
  local b = require("null-ls").builtins
  local sources = {
    -- webdev stuff
    b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

    -- Lua
    b.formatting.stylua,

    -- cpp
    b.formatting.clang_format,

    -- YAML
    b.diagnostics.yamllint,

    -- Python
    b.formatting.black,
  }

  require("null-ls").setup {
    debug = true,
    sources = sources,
  }
end

function user.on_attach(args)
  local bufnr = args.buf
  local bufmap = function(mode, lhs, rhs, desc)
    local opts = { buffer = true, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Format on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
  })

  -- You can search each function in the help page.
  -- For example :help vim.lsp.buf.hover()

  bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP Hover")
  bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP Definition")
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP Declaration")
  bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "LSP Implementation")
  bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "LSP Type Definition")
  bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "LSP References")
  bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP Signature")
  bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP Rename")
  bufmap({ "n", "x" }, "<leader>bf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "LSP Format")
  bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "LSP Diag. Float")
  bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "LSP Diag. Previous")
  bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", "LSP Diag. Next")

  bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP Code Action")
  bufmap("x", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP Code Action")

  -- if using Neovim v0.8 uncomment this
  -- bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
end

return Plugin
