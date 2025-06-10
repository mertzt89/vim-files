------------------------------------------------------------
-- Generic LSP settings
------------------------------------------------------------

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
    source = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function(_)
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = require("util.mason").get_ensure(),
    })

    require("util.lsp").on_attach(function(_, _)
      require("util.keys").map({
        { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        {
          "K",
          function()
            vim.lsp.buf.hover({ border = "rounded" })
          end,
          desc = "Hover",
        },
        {
          "gK",
          function()
            vim.lsp.buf.signature_help({ border = "rounded" })
          end,
          desc = "Signature Help",
        },
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
      })
    end)
  end,
})
