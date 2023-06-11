local Plugin = { "simrat39/symbols-outline.nvim" }
local map = require("utils").map

local symbols = map(require("user.icons").lspkind, function(icon)
  return { icon = icon }
end)

Plugin.opts = {
  symbols = symbols,
}

Plugin.config = true
Plugin.keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } }

return Plugin
