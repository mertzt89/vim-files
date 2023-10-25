local M = {}

function M.ts_ensure_installed(ensure)
	return {
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}

			for _, e in pairs(ensure) do
				if not require("util").list_contains(opts.ensure_installed, e) then
					table.insert(opts.ensure_installed, e)
				end
			end
		end,
	}
end

function M.mason_ensure_installed(ensure)
	return {
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(ensure) == "string" then
				ensure = { ensure }
			end
			opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, ensure)
		end,
	}
end

return M
