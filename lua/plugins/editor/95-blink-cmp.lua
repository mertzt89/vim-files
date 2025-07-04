local DISABLED_FTS = {}

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- optional: provides snippets for the snippet source
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      { "onsails/lspkind.nvim" },
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = "enter" },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = require("lspkind").symbol_map,
      },

      snippets = {
        preset = "luasnip",
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- Disable completion for specific filetypes
      enabled = function()
        return not vim.tbl_contains(DISABLED_FTS, vim.bo.filetype)
      end,

      -- Disable completion for cmdline mode
      cmdline = {
        enabled = false,
      },

      -- experimental signature help support
      signature = { enabled = true },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
      "sources.providers",
    },
  },
}
