local Plugin = { "kyazdani42/nvim-tree.lua" }

Plugin.name = "nvim-tree"

Plugin.cmd = { "NvimTreeToggle", "NvimTreeFocus" }

Plugin.opts = {}

function Plugin.init()
  vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")
end

return Plugin
