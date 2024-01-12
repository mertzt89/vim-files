return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- prettier
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        handlebs = { "prettier" },
        svelte = { "prettier" },
        -- ["yaml"] = { "prettier" },

        -- stylua
        ["lua"] = { "stylua" },
      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
  },

  require("util.spec").mason_ensure_installed("prettier"),
  require("util.spec").mason_ensure_installed("stylua"),
}
