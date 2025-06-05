local add = MiniDeps.add

add({ source = "neovim/nvim-lspconfig" })

add({
  source = "williamboman/mason-lspconfig.nvim",
  depends = { "williamboman/mason.nvim" },
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = require("util.mason").get_ensure(),
})

require("util.lsp").on_attach(function(_, _)

  require("util.keys").map({
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
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
  })
end)
