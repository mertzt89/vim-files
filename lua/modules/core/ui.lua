--
-- ui.lua
--
local module = {}

function module.register_plugins(use)
  use {
    'feline-nvim/feline.nvim',
    requires = 'lewis6991/gitsigns.nvim',
    config = function()
      -- Initialize the components tables
      local components = {active = {}, inactive = {}}
      local bar_components = {active = {}, inactive = {}}

      local navic = require('nvim-navic')
      vim.o.termguicolors = true

      table.insert(bar_components.active, {})

      local lsp_fg = function()
        if require('modules.lsp').current_buf_attached() then
          return "green"
        else
          return "red"
        end
      end

      local lsp_icon = function()
        if require('modules.lsp').current_buf_attached() then
          return "歷"
        else
          return "轢"
        end
      end

      components.active[1] = {
        {provider = '▊ ', hl = {fg = 'skyblue'}}, {
          provider = 'vi_mode',
          hl = function()
            local vi_mode_utils = require('feline.providers.vi_mode')
            return {
              name = vi_mode_utils.get_mode_highlight_name(),
              fg = vi_mode_utils.get_mode_color(),
              style = 'bold'
            }
          end
        }, {
          provider = lsp_icon,
          right_sep = '',
          hl = function() return {fg = lsp_fg(), bg = 'bg'} end
        }, {
          provider = 'file_info',
          hl = {fg = 'white', bg = 'oceanblue', style = 'bold'},
          left_sep = {
            'slant_left_2', {str = ' ', hl = {bg = 'oceanblue', fg = 'NONE'}}
          },
          right_sep = {
            {str = ' ', hl = {bg = 'oceanblue', fg = 'NONE'}}, 'slant_right_2',
            ' '
          }
        }, {
          provider = 'position',
          right_sep = {
            ' ', {str = 'slant_left_2_thin', hl = {fg = 'fg', bg = 'bg'}}
          }
        }, {provider = 'diagnostic_errors', hl = {fg = 'red'}},
        {provider = 'diagnostic_warnings', hl = {fg = 'yellow'}},
        {provider = 'diagnostic_hints', hl = {fg = 'cyan'}},
        {provider = 'diagnostic_info', hl = {fg = 'skyblue'}}
      }

      components.active[2] = require('feline.default_components').statusline
                               .icons.active[2]

      table.insert(bar_components.active[1], {
        provider = function() return navic.get_location() end,
        enabled = function() return navic.is_available() end
      })

      require('feline').winbar.setup({components = bar_components})
      require('feline').setup({components = components})
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {'stevearc/dressing.nvim'}
end

function module.init() end

return module
