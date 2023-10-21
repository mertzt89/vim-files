local M = {}

function M.ts_ensure_installed(ensure)
	return {
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, ensure)
			else
				opts.ensure_installed = ensure
			end
		end,
	}
end

return M
