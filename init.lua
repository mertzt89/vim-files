-- Bootstrap mini.deps (package manager)
require("util.bootstrap")

-- Space as leader key
vim.g.mapleader = " "

-- Early initialization
require("early")

require("editor")
require("code")
