local Plugin = { "kyazdani42/nvim-tree.lua" }

Plugin.name = "nvim-tree"

Plugin.cmd = { "NvimTreeToggle" }

-- Use defualt config
Plugin.config = true

function Plugin.init()
	vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
end

return Plugin
