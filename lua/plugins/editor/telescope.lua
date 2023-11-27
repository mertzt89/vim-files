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
	{
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
					"<cmd>Telescope egrepify<cr>",
					{ desc = "Live Grep (--no-ignore-vcs)" },
				},

				-- LSP
				{ "<leader>ss", builtins.lsp_document_symbols, { desc = "Goto Symbol" } },
				{ "<leader>sS", builtins.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" } },
			}
		end,
		opts = function()
			local egrep_actions = require("telescope._extensions.egrepify.actions")
			return {
				defaults = {
					mappings = {
						i = {
							-- toggle prefixes, prefixes is default
							["<C-z>"] = egrep_actions.toggle_prefixes,
							-- toggle AND, AND is default, AND matches tokens and any chars in between
							["<C-a>"] = egrep_actions.toggle_and,
							-- toggle permutations, permutations of tokens is opt-in
							["<C-r>"] = egrep_actions.toggle_permutations,
						},
					},
				},
				extensions = {
					egrepify = {
						-- intersect tokens in prompt ala "str1.*str2" that ONLY matches
						-- if str1 and str2 are consecutively in line with anything in between (wildcard)
						AND = true, -- default
						permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
						lnum = true, -- default, not required
						lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
						col = false, -- default, not required
						col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
						title = true, -- default, not required, show filename as title rather than inline
						filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
						-- suffix = long line, see screenshot
						-- EXAMPLE ON HOW TO ADD PREFIX!
						prefixes = {
							["%"] = {
								flag = "no-ignore",
							},
							["@"] = {
								flag = "hidden",
							},
							["!"] = {
								-- #$REMAINDER
								-- # is caught prefix
								-- `input` becomes $REMAINDER
								-- in the above example #lua,md -> input: lua,md
								flag = "glob",
								cb = function(input)
									return string.format([[!*.{%s}]], input)
								end,
							},
							["#"] = {
								-- #$REMAINDER
								-- # is caught prefix
								-- `input` becomes $REMAINDER
								-- in the above example #lua,md -> input: lua,md
								flag = "glob",
								cb = function(input)
									return string.format([[*.{%s}]], input)
								end,
							},
							-- filter for (partial) folder names
							-- example prompt: >conf $MY_PROMPT
							-- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
							-- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
							[">"] = {
								flag = "glob",
								cb = function(input)
									return string.format([[**/{%s}*/**]], input)
								end,
							},
							-- filter for (partial) file names
							-- example prompt: &egrep $MY_PROMPT
							-- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
							-- i.e. rg --glob="*egrep*" -- $MY_PROMPT
							["&"] = {
								flag = "glob",
								cb = function(input)
									return string.format([[*{%s}*]], input)
								end,
							},
						},
					},
				},
			}
		end,
		-- init = function()
		-- 	-- See :help telescope.builtin
		-- end,
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("egrepify")
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"fdschmidt93/telescope-egrepify.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
}
