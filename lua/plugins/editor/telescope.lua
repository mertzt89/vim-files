-- Custom find files command handling
local find_files_command = function(extra_args, opts)
	extra_args = extra_args or {}
	opts = opts or {}

	local cmd = vim.list_extend({ "rg", "--color", "never", "--files" }, extra_args)
	opts = vim.tbl_deep_extend("keep", opts, { find_command = cmd })

	return function()
		local b = require("telescope.builtin")
		b.find_files(opts)
	end
end

-- Different "find files" commands to be bound
local find_files = {
	default = find_files_command(),
	no_ignore_vcs = find_files_command({ "--no-ignore-vcs" }),
	all = find_files_command({}, { hidden = true, no_ignore = true }),
}

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = { "Telescope" },
	keys = function()
		local builtins = require("telescope.builtin")
		return {
			-- Buffer
			{ "<leader><space>", builtins.buffers, { desc = "Buffers" } },
			{ "<leader>sb", builtins.current_buffer_fuzzy_find, desc = "Find in Buffer" },
			{ "<leader>fs", builtins.current_buffer_fuzzy_find, { desc = "Find in Buffer" } },

			-- Commands
			{ "<leader>sa", builtins.autocommands, desc = "Auto Commands" },
			{ "<leader>sC", builtins.commands, desc = "Commands" },
			{ "<leader>sc", builtins.command_history, desc = "Command History" },

			-- Diagnostics
			{ "<leader>fd", builtins.diagnostics, { desc = "Diagnostics" } },
			{ "<leader>sD", builtins.diagnostics, desc = "Workspace diagnostics" },
			{
				"<leader>sd",
				function()
					builtins.diagnostics({ bufnr = 0 })
				end,
				desc = "Document diagnostics",
			},

			-- Find Files
			{ "<leader>?", builtins.oldfiles, { desc = "Recent Files" } },
			{ "<leader>ff", find_files.no_ignore_vcs, { desc = "Find Files (--no-ignore-vcs)" } },
			{ "<leader>fF", find_files.default, { desc = "Find Files" } },
			{ "<leader>fa", find_files.all, { desc = "Find Files (ALL)" } },

			-- Grep
			{
				"<leader>fg",
				function() -- Dont respect .gitignore
					builtins.live_grep({ additional_args = "--no-ignore-vcs" })
				end,
				{ desc = "Live Grep (--no-ignore-vcs)" },
			},
			{ "<leader>fG", builtins.live_grep, { desc = "Live Grep" } }, -- Respect .gitignore

			-- LSP
			{ "<leader>ss", builtins.lsp_document_symbols, { desc = "Goto Symbol" } },
			{ "<leader>sS", builtins.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" } },
		}
	end,
	init = function()
		-- See :help telescope.builtin
	end,
	config = function()
		require("telescope").load_extension("fzf")
	end,
}
