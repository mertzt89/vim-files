-- Fix "%" in svelte files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "svelte",
  callback = function()
    vim.b.match_words =
      [[<!--:-->,<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/!][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\([^/!][^ \t>]*\)>,(:),{:},\[:\],<:>,\/\*:\*\/,#\s*if\%(n\=def\)\=:#\s*else\>:#\s*elif\>:#\s*endif\>]]
  end,
})

require("util").lsp_on_attach(function(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.js", "*.ts" },
    callback = function(ctx)
      if client.name == "svelte" then
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
      end
    end,
  })
end)

return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        svelte = {
          cmd = { "svelteserver", "--stdio", "--experimental-modules" },
          settings = {
            svelte = {
              defaultScriptLanguage = "ts",
            },
          },
        },
      },
    },
  },

  -- Treesitter
  require("util.spec").ts_ensure_installed({ "svelte" }),
}
