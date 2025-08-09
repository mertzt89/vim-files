-- Fix "%" in svelte files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "svelte",
  callback = function()
    vim.b.match_words =
    [[<!--:-->,<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/!][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\([^/!][^ \t>]*\)>,(:),{:},\[:\],<:>,\/\*:\*\/,#\s*if\%(n\=def\)\=:#\s*else\>:#\s*elif\>:#\s*endif\>]]
  end,
})

vim.lsp.config("svelte", {
  settings = {
    svelte = {
      cmd = { "svelteserver", "--stdio", "--experimental-modules" },
      defaultScriptLanguage = "ts",
    },
  },
})

-- Autocommand to configure JSON LSP client with Schemastore schemas
Util.lsp.on_attach(function(client, bufnr)
  if client.name == "svelte" then
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        if client.name == "svelte" then
          client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
        end
      end,
    })
  end
end)

vim.lsp.enable("svelte")

return {
  -- Mason: Install svelte
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "svelte-language-server" },
    },
  },

  -- Treesitter: Svelte support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "svelte" },
    }
  },
}
