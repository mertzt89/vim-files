-- init.lua
-- Init for Style

local autocmd = require'lib.autocmd'
local log = require'lib.log'
local plugman = require'lib.plugman'

local module = {}

function module.register_plugins()
    -- Tokyo Night colorscheme
    plugman.use({'folke/tokyonight.nvim', config = function()
        vim.g.tokyonight_style = 'night'
        if not pcall(vim.api.nvim_command, "colorscheme tokyonight") then
            vim.api.nvim_command("colorscheme elflord")
        end
      end})

    -- Lualine
  plugman.use { 'hoob3rt/lualine.nvim', config = function()
	  require'lualine'.setup{
		options = {
			theme = 'tokyonight',
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch'},
            lualine_c = {'filename'},
            lualine_x = {{require'modules.lsp'.status_line_part}, 'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        }
	}
  end}

    -- Hightlight word under cursor
    plugman.use({'RRethy/vim-illuminate', config = function()
        vim.g.Illuminate_delay = 75
    end})

    -- Tresitter
    plugman.use({'nvim-treesitter/nvim-treesitter', config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ignore_install = {"comment"}, -- List of parsers to ignore installing
            highlight = {
                enable = true,              -- false will disable the whole extension
                disable = {"comment"},  -- list of language that will be disabled
            },
        }
    end, run = ':TSUpdate'})

    ---- Todo Comments (highlight todo/hack/note/etc.)
    plugman.use({'folke/todo-comments.nvim',
            requires = 'nvim-lua/plenary.nvim',
            config = function()
                require'todo-comments'.setup{}
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

    --autocmd.bind_colorscheme(function()
    --    vim.cmd("highlight LspDiagnosticsDefaultError ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none")
    --    vim.cmd("highlight LspDiagnosticsDefaultWarning ctermfg=167 ctermbg=none guifg=#CCA666 guibg=none")
    --    vim.cmd("highlight LspDiagnosticsDefaultInformation ctermfg=167 ctermbg=none guifg=#66A9CC guibg=none")
    --    vim.cmd("highlight LspDiagnosticsDefaultHint ctermfg=167 ctermbg=none guifg=#85CC66 guibg=none")
    --end)
end

return module
