local Plugin = { "nvim-lualine/lualine.nvim" }

Plugin.event = "VeryLazy"

-- See :help lualine.txt
Plugin.opts = {
	options = {
		theme = "tokyonight",
		icons_enabled = true,
		component_separators = "|",
		section_separators = "",
		disabled_filetypes = {
			statusline = { "NvimTree" },
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
}

function Plugin.init()
	vim.opt.showmode = false
end

-- Force this layer of config to load first
Plugin.priiority = 100

return Plugin
