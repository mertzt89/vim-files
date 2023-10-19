local Plugin = { "lukas-reineke/indent-blankline.nvim" }

Plugin.name = "indent_blankline"

Plugin.main = "ibl"

Plugin.event = { "BufReadPost", "BufNewFile" }

-- See :help ibl.setup()
Plugin.opts = {
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = { enabled = false },
	exclude = {
		filetypes = {
			"help",
			"NvimTree",
			"lazy",
			"mason",
		},
	},
}

return Plugin
