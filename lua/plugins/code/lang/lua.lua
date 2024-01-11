local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
  -- Install Stylua via Mason
  require("util.spec").mason_ensure_installed("stylua"),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        lua_ls = {
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
        },
      },
    },
  },
}
