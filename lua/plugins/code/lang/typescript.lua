return {
	-- Treesitter
	require("util.spec").ts_ensure_installed({
		"css",
		"javascript",
		"json",
		"tsx",
		"typescript",
	}),

	-- LSP
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				tsserver = {
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
			},
		},
	},
}
