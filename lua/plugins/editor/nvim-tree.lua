local Plugin = { "kyazdani42/nvim-tree.lua" }

Plugin.name = "nvim-tree"

Plugin.cmd = { "NvimTreeToggle", "NvimTreeFindFile" }

-- Use defualt config
Plugin.config = true

function Plugin.init()
	vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFile<cr>")
	vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeToggle<cr>")
end

return Plugin
