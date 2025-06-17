-- Autocommand to configure JSON LSP client with Schemastore schemas
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml" },
  callback = function()
    vim.lsp.config("yamlls", {
      on_init = function(client, _) ---@param client vim.lsp.Client
        client.settings.yaml["schemas"] = client.settings.yaml.schemas or {}
        vim.list_extend(client.settings.yaml.schemas, require("schemastore").yaml.schemas())
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
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    })
  end,
})

return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- Mason: Install yamlls
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "yamlls" },
    },
  },

  -- Treesitter: YAML support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = { "yaml" },
  } },
}
