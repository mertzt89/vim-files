local add = MiniDeps.add

add({
  source = "stevearc/conform.nvim",
})

require("conform").setup({
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
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format()
end, { desc = "Code Format" })
