return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			{ desc = "Oil" },
		},
	},
}
