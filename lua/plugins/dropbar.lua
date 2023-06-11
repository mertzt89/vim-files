local Plugin = { "Bekaboo/dropbar.nvim" }
local map = require("utils").map

local user_icons = require("user.icons").lspkind
local padded_icons = map(user_icons, function(icon)
  return icon .. " "
end)

Plugin.enabled = vim.fn.has "nvim-0.10.0" == 1

Plugin.opts = {
  icons = { kinds = { symbols = padded_icons } },
  menu = {
    keymaps = {
      ["q"] = function()
        local menu = require("dropbar.api").get_current_dropbar_menu()
        if not menu then
          return
        end
        menu:close()
      end,
    },
  },
}

local function pick_last_component()
  local dbapi = require "dropbar.api"
  local dbar = dbapi.get_current_dropbar()
  dbapi.pick(#dbar.components)
end

function Plugin.init()
  vim.keymap.set("n", "<leader>j", pick_last_component)
  vim.keymap.set("n", "<leader>J", require("dropbar.api").pick)
end

return Plugin
