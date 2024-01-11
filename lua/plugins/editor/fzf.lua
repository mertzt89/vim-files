-- Custom find files command handling
local find_files_command = function(extra_args, opts)
	extra_args = extra_args or {}
	opts = opts or {}

	local cmd = vim.list_extend({ "rg", "--color", "never", "--files" }, extra_args)
	opts = vim.tbl_deep_extend("keep", opts, { cmd = table.concat(cmd, " ") })

	return function()
		local b = require("fzf-lua")
		b.files(opts)
	end
end

-- Different "find files" commands to be bound
local find_files = {
	default = find_files_command(),
	no_ignore_vcs = find_files_command({ "--no-ignore-vcs" }),
	all = find_files_command({ "-uu" }),
}

return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = function()
			local fzf = require("fzf-lua")
			return {
				-- Buffer
				{ "<leader><space>", fzf.buffers, { desc = "Buffers" } },
				{ "<leader>sb", fzf.blines, desc = "Find in Buffer" },
				{ "<leader>fs", fzf.blines, { desc = "Find in Buffer" } },

				-- Commands
				{ "<leader>sa", fzf.autocmds, desc = "Auto Commands" },
				{ "<leader>sC", fzf.commands, desc = "Commands" },
				{ "<leader>sc", fzf.command_history, desc = "Command History" },

				-- Diagnostics
				{ "<leader>sD", fzf.diagnostics_workspace, desc = "Workspace diagnostics" },
				{ "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" } },

				-- Find Files
				{ "<leader>?", fzf.oldfiles, { desc = "Recent Files" } },
				{
					"<leader>ff",
					find_files.no_ignore_vcs,
					{ desc = "Find Files (--no-ignore-vcs)" },
				},
				{ "<leader>fF", find_files.default, { desc = "Find Files" } },
				{ "<leader>fa", find_files.all, { desc = "Find Files (ALL)" } },

				-- Grep
				{
					"<leader>fg",
					"<cmd>Telescope egrepify<cr>",
					{ desc = "Live Grep (--no-ignore-vcs)" },
				},

				-- LSP
				{ "<leader>ss", fzf.lsp_document_symbols, { desc = "Goto Symbol" } },
				{ "<leader>sS", fzf.lsp_workspace_symbols, { desc = "Goto Symbol (Workspace)" } },
			}
		end,
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},
}
