------------------------------------------------------------
-- Lua language support
------------------------------------------------------------

------------------------------------------------------------
-- LSP
------------------------------------------------------------
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        library = {
          -- Make the server aware of Neovim runtime files
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

return {
  -- Mason: Install lua_ls
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" },
    },
  },

  -- Treesitter: Lua/Luadoc support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = {
      "lua",
      "luadoc",
    },
  } },
}
