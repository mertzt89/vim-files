-- init.lua
-- Init for Style
local autocmd = require 'lib.autocmd'
local log = require 'lib.log'
local plug = require 'lib.plug'

local module = {}

function module.register_plugins()
  -- Tokyo Night colorscheme
  plug.use({
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'night'
      if not pcall(vim.api.nvim_command, "colorscheme tokyonight") then
        vim.api.nvim_command("colorscheme elflord")
      end
    end
  })

  -- Lualine
  plug.use {
    'hoob3rt/lualine.nvim',
    config = function()
      require'lualine'.setup {
        options = {theme = 'tokyonight'},
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {'filename'},
          lualine_x = {
            {require'modules.lsp'.status_line_part}, 'encoding', 'fileformat',
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        }
      }
    end
  }

  -- Hightlight word under cursor
  plug.use({
    'RRethy/vim-illuminate',
    config = function() vim.g.Illuminate_delay = 75 end
  })

  -- Tresitter
  plug.use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = {"comment"}, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {"comment"} -- list of language that will be disabled
        }
      }
    end,
    run = ':TSUpdate'
  })

  -- Todo Comments (highlight todo/hack/note/etc.)
  plug.use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require'todo-comments'.setup {} end
  })
end

-- The startup window doesn't seem to pick up on vim.o changes >.<
local function set_default_win_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function() vim.wo[name] = value end)
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
end

return module
