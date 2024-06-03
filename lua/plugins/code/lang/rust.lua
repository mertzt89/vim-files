return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },

  -- Treesitter
  require("util.spec").ts_ensure_installed({ "ron", "rust", "toml" }),

  -- LSP
  { -- Rustacean perform LSP setup
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neoconf.nvim" },
    opts = {
      setup = {
        rust_analyzer = function(_, _)
          -- Do nothing, Rustacean performs LSP setup
        end,
      },
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
    },
  },
}
