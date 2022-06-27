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

      table.insert(components.active, {})
      table.insert(bar_components.active, {})

      table.insert(components.active[1], {
        provider = {name = 'vi_mode'},
        hl = function()
          return {
            name = require('feline.providers.vi_mode').get_mode_highlight_name(),
            fg = require('feline.providers.vi_mode').get_mode_color(),
            style = 'bold'
          }
        end
      })
      table.insert(components.active[1], {
        provider = {name = 'file_info', opts = {type = 'relative'}}
      })

      table.insert(bar_components.active[1], {
        provider = function() return navic.get_location() end,
        enabled = function() return navic.is_available() end
      })

      require('feline').winbar.setup({components = bar_components})
      require('feline').setup()
    end
  }
end

function module.init() end

return module
