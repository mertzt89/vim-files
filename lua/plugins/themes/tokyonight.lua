return {
  "folke/tokyonight.nvim",
  opts = {
    on_highlights = function(hl, c)
      -- Instead of showing the current indent scope with blue,
      -- use a slightly brightened version IndentBlanklineChar
      hl.MiniIndentscopeSymbol = {
        fg = require("tokyonight.util").lighten(hl.IndentBlanklineChar.fg, 0.8),
      }
    end,

    -- Default to "night" i.e. `:colorscheme tokyonight-night`
    style = "night",
  },
}
