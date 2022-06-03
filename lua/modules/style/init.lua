-- init.lua
-- Init for Style
local module = {}

function module.register_plugins(use)
  -- Tokyo Night colorscheme
  use({
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'night'
      if not pcall(vim.api.nvim_command, "colorscheme tokyonight") then
        vim.api.nvim_command("colorscheme elflord")
      end
    end
  })

  -- Lualine
  use {
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
  use({
    'RRethy/vim-illuminate',
    config = function() vim.g.Illuminate_delay = 75 end
  })

  -- Todo Comments (highlight todo/hack/note/etc.)
  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require'todo-comments'.setup {} end
  })
end

function module.init()
  vim.api.nvim_command("syntax on")

  -- Line numbers
  vim.wo.number = true

  -- Visibile whitespace
  vim.o.listchars = "tab:>-,space:·"
  vim.o.list = true

  -- No soft wrapping
  vim.o.wrap = false
end

return module
