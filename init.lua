-- Bootstrap lazy.nvim (package manager) and utilities
require("util.bootstrap")

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.exrc = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

local group = vim.api.nvim_create_augroup("user", { clear = true })

-- Add support for using 'q' to close help and man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = group,
  callback = function()
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { silent = true, buffer = true })
  end,
})
