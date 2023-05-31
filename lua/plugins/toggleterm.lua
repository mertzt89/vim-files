local Plugin = { "akinsho/toggleterm.nvim" }

Plugin.name = "toggleterm"

Plugin.keys = { "<C-\\>" }

-- See :help toggleterm-roadmap
Plugin.opts = {
  open_mapping = "<C-\\>",
  direction = "horizontal",
  shade_terminals = true,
}

return Plugin
