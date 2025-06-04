-- Bootstrap mini.deps (package manager)
require("util.bootstrap")

local auto = require("util.deps").auto

local group = vim.api.nvim_create_augroup("user", { clear = true })

-- Add support for using 'q' to close help and man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = group,
  callback = function()
    vim.print("hello!")
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { silent = true, buffer = true })
  end,
})

vim.o.exrc = true

-- Space as leader key
vim.g.mapleader = " "

-- Early initialization
auto("early")

auto("editor")
auto("code")
