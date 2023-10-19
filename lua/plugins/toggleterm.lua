local Plugin = { "akinsho/toggleterm.nvim" }

Plugin.name = "toggleterm"

Plugin.keys = { "<C-_>" }

-- See :help toggleterm-roadmap
Plugin.opts = {
	open_mapping = "<C-_>",
	direction = "horizontal",
	shade_terminals = true,
}

return Plugin
