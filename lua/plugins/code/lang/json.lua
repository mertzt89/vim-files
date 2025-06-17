-- Autocommand to configure JSON LSP client with Schemastore schemas
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json" },
  callback = function()
    vim.lsp.config("jsonls", {
      on_init = function(client, _) ---@param client vim.lsp.Client
        client.settings.json["schemas"] = client.settings.json.schemas or {}
        vim.list_extend(client.settings.json.schemas, require("schemastore").json.schemas())
      end,
      settings = {
        json = {
          format = {
            enable = true,
          },
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
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
