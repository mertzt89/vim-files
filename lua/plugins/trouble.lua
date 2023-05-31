local Plugin = { "folke/trouble.nvim" }

Plugin.cmd = { "Trouble", "TroubleToggle" }
Plugin.dependencies = { "folke/lsp-trouble.nvim" }
Plugin.opts = {
  auto_open = false,
  auto_close = true,
}

return Plugin
