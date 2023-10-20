local Plugin = { "neovim/nvim-lspconfig" }
local user = {}

Plugin.dependencies = {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "williamboman/mason-lspconfig.nvim" },
}

Plugin.cmd = { "LspInfo", "LspInstall", "LspUnInstall" }

Plugin.event = { "BufReadPre", "BufNewFile" }

function Plugin.init()
	local sign = function(opts)
		-- See :help sign_define()
		vim.fn.sign_define(opts.name, {
			texthl = opts.name,
			text = opts.text,
			numhl = "",
		})
	end

	sign({ name = "DiagnosticSignError", text = "✘" })
	sign({ name = "DiagnosticSignWarn", text = "▲" })
	sign({ name = "DiagnosticSignHint", text = "⚑" })
	sign({ name = "DiagnosticSignInfo", text = "»" })

	-- See :help vim.diagnostic.config()
	vim.diagnostic.config({
		virtual_text = true,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

function Plugin.config()
	-- See :help lspconfig-global-defaults
	local lspconfig = require("lspconfig")
	local lsp_defaults = lspconfig.util.default_config

	lsp_defaults.capabilities =
		vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	local group = vim.api.nvim_create_augroup("lsp_cmds", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		desc = "LSP actions",
		callback = user.on_attach,
	})

	-- See :help mason-lspconfig-settings
	require("mason-lspconfig").setup({
		ensure_installed = {
			"eslint",
			"tsserver",
			"html",
			"cssls",
			"lua_ls",
			"clangd",
		},
		handlers = {
			-- See :help mason-lspconfig-dynamic-server-setup
			function(server)
				-- See :help lspconfig-setup
				lspconfig[server].setup({})
			end,
			["tsserver"] = function()
				lspconfig.tsserver.setup({
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				})
			end,
			["lua_ls"] = function()
				require("plugins.lsp.lua_ls")
			end,
			["clangd"] = function()
				require("plugins.lsp.clangd")
			end,
		},
	})
end

-- stylua: ignore
local lsp_keys = {
	{ "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
	{ "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition",  },
	{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
	{ "gi", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
	{ "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
	{ "K", vim.lsp.buf.hover, desc = "Hover" },
	{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
  { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Open Float" },
	{ "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev. Diagnostic" },
	{ "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next. Diagnostic" },
	{ "<leader>cf", vim.lsp.buf.format, desc = "Code Format", mode = { "n", "v" } },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", mode = { "n", "v" } },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
	{ "<leader>cA",
		function()
			vim.lsp.buf.code_action({
				context = {
					only = {
						"source",
					},
					diagnostics = {},
				},
			})
		end,
		desc = "Source Action"
	},
}

function user.on_attach()
	local bufmap = function(mode, lhs, rhs)
		local opts = { buffer = true }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	for _i, binding in ipairs(lsp_keys) do
		bufmap("n", binding[1], binding[2])
	end
end

return Plugin
