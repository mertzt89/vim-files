local find_files_command = {
	"rg",
	"--color",
	"never",
	"--files",
}

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = { "Telescope" },
	init = function()
		local builtins = require("telescope.builtin")
		-- See :help telescope.builtin
		vim.keymap.set("n", "<leader>?", function()
			builtins["oldfiles"]()
		end, { desc = "Recent Files" })
		vim.keymap.set("n", "<leader><space>", function()
			builtins["buffers"]()
		end, { desc = "Buffers" })

		-- Find Files
		vim.keymap.set("n", "<leader>ff", function() -- Don't repect .gitignore
			local find_command = find_files_command
			vim.list_extend(find_command, { "--no-ignore-vcs" })
			builtins["find_files"]({ find_command = find_command })
		end, { desc = "Find Files (--no-ignore-vcs)" })
		vim.keymap.set("n", "<leader>fF", function() -- Respect .gitignore
			builtins["find_files"]()
		end, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fa", function() -- ALL incuding ignored
			builtins["find_files"]({ hidden = true, no_ignore = true, find_command = find_files_command })
		end, { desc = "Find Files (ALL)" })

		-- Grep
		vim.keymap.set("n", "<leader>fg", function() -- Dont respect .gitignore
			builtins["live_grep"]({ additional_args = "--no-ignore-vcs" })
		end, { desc = "Live Grep (--no-ignore-vcs)" })
		vim.keymap.set("n", "<leader>fG", function() -- Respect .gitignore
			builtins["live_grep"]()
		end, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fd", function()
			builtins["diagnostics"]()
		end, { desc = "Diagnostics" })
		vim.keymap.set("n", "<leader>fs", function()
			builtins["current_buffer_fuzzy_find"]()
		end, { desc = "Find in Buffer" })
	end,
	config = function()
		require("telescope").load_extension("fzf")
	end,
}
