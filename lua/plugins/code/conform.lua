local defaults = {
  formatters = {
    ["clang-format"] = {
      command = "clang-format",
    },
  },
}

require("neoconf.plugins").register({
  name = "Conform",
  on_schema = function(schema)
    schema:import("conform", defaults)
  end,
})

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
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- ["yaml"] = { "prettier" },

        -- stylua
        ["lua"] = { "stylua" },
      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Code Format",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local config = require("neoconf").get("conform", defaults)
      vim.print(config)
      opts = vim.tbl_extend("force", opts, config)

      require("conform").setup(opts)
    end,
  },

  require("util.spec").mason_ensure_installed("clang-format"),
  require("util.spec").mason_ensure_installed("prettier"),
  require("util.spec").mason_ensure_installed("stylua"),
}
