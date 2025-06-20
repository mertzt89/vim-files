-- Autocommand to configure JSON LSP client with Schemastore schemas
vim.lsp.config("yamlls", {
  before_init = function(_, new_config)
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = {},
    },
  },
})

vim.lsp.enable("yamlls")

return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- Mason: Install yamlls
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "yaml-language-server" },
    },
  },

  -- Treesitter: YAML support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = { "yaml" },
  } },
}
