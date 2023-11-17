return {
	-- LSP
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				svelte = {},
			},
		},
	},

	-- Treesitter
	require("util.spec").ts_ensure_installed({ "svelte" }),
}
