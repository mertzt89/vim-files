-- init.lua
-- Init for Style

local autocmd = require'lib.autocmd'
local log = require'lib.log'
local plugman = require'lib.plugman'

local module = {}

function module.register_plugins()
    -- Packer can manage itself as an optional plugin
    plugman.use({'wbthomason/packer.nvim', opt = true})

    -- Gruvbox colorscheme
    plugman.use({'morhetz/gruvbox'})

    -- Airline
    plugman.use({'bling/vim-airline', config = function()
        vim.g.airline_theme = 'dark'
        vim.g.airline_powerline_fonts = 1
    end})

    -- Hightlight word under cursor
    plugman.use({'RRethy/vim-illuminate', config = function()
        vim.g.Illuminate_delay = 75
    end})
end

-- The startup window doesn't seem to pick up on vim.o changes >.<
local function set_default_win_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.wo[name] = value
  end)
end

function module.init()
	vim.api.nvim_command("syntax on")

    -- Line numbers
    set_default_win_opt("number", true)

    -- Visibile whitespace
    set_default_win_opt("list", true)
    set_default_win_opt("listchars", "tab:>-,space:·")

    -- No soft wrapping
    set_default_win_opt("wrap", false)

    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.gruvbox_contrast_light = 'hard'

    -- Use Gruvbox if its installed, if not fallback to elflord
    if not pcall(vim.api.nvim_command, "colorscheme gruvbox") then
        vim.api.nvim_command("colorscheme elflord")
    end
end

return module
