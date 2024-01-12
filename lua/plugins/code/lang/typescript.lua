return {
  -- Treesitter
  require("util.spec").ts_ensure_installed({
    "css",
    "javascript",
    "json",
    "tsx",
    "typescript",
  }),

  -- LSP - tsserver
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },

  -- LSP - eslint
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      servers = {
        ---@type lspconfig.options.eslint
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },
}
