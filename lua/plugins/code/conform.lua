return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
