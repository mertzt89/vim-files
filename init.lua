-- Bootstrap lazy.nvim (package manager) and utilities
require("util.bootstrap")

-- Load settings
require("settings")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },

  ui = {
    custom_keys = {
      -- Open lazygit log for a plugin
      ["gL"] = {
        function(plugin)
          Snacks.terminal.open({ "lazygit", "log" }, {
            cwd = plugin.dir,
          })
        end,
        desc = "Open lazygit log",
      },

      -- Inspect a plugin
      ["gi"] = {
        function(plugin)
          Snacks.notify(vim.inspect(plugin), {
            title = "Inspect " .. plugin.name,
            ft = "lua",
          })
        end,
        desc = "Inspect Plugin",
      },

      -- Open plugin directory in terminal
      ["gt"] = {
        function(plugin)
          local lazy_win = require("lazy.view").view.win

          Snacks.terminal.open(nil, {
            cwd = plugin.dir,
            start_insert = false,
          })

          if lazy_win and vim.api.nvim_win_is_valid(lazy_win) then
            vim.notify("Settting window to " .. lazy_win, vim.log.levels.INFO, {
              title = "Inspect Plugin",
            })
            vim.api.nvim_set_current_win(lazy_win)
          end
        end,
        desc = "Open terminal in plugin dir",
      },
    },
  },
})
