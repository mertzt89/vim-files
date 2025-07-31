------------------------------------------------------------
-- Lua language support
------------------------------------------------------------

------------------------------------------------------------
-- LSP
------------------------------------------------------------
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- -- Autocmd to start lsp if a '.nvim.lua' file is opened
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = { ".nvim.lua" },
--   callback = function()
--     require("mason")
--     vim.lsp.start({
--       name = "lua_ls",
--       cmd = { "lua-language-server" },
--       workspace_folders = { { name = "config", uri = vim.uri_from_fname(vim.fn.stdpath("config")) } },
--     })
--   end,
-- })
--
vim.lsp.config("lua_ls", {
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
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
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable("lua_ls")

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "lua-language-server" },
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
