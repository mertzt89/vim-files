return {
	"echasnovski/mini.files",
	keys = {
		{
			"<leader>fm",
			function()
				require("mini.files").open()
			end,
			desc = "Mini Files",
		},
	},
	opts = {},
	version = false,
}
