-- Bootstrap lazy.nvim (package manager) and utilities
require("util.bootstrap")

-- Load settings
require("settings")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
