return {
	-- Generally used languges that Treesitter should install
	require("util.spec").ts_ensure_installed({
		"json",
		"lua",
		"vim",
		"vimdoc",
		"markdown",
	}),
}
