-- Autocommand to configure JSON LSP client with Schemastore schemas
vim.lsp.config("jsonls", {
  before_init = function(_, new_config)
    new_config.settings.json.schemas =
      vim.tbl_deep_extend("force", new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
})

return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- Mason: Install jsonls
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "jsonls" },
    },
  },

  -- Treesitter: JSON support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = { "json", "json5", "jsonc" },
  } },
}
