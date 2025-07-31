_G.Util = require("util")

-- Bootstrap lazy.nvim (package manager) and utilities
Util.bootstrap()

-- Set up utilities
Util.setup()

-- Load settings
require("settings")

local dev_path = vim.fs.joinpath(vim.env.HOME, "nvim-dev")

---@type LazyConfig
local lazy_config = {
  dev = { path = dev_path },
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  ui = {
    custom_keys = {
      ["gD"] = {
        function(plugin)
          vim.fn.jobstart({
            "git",
            "clone",
            plugin.url,
            vim.fs.joinpath(vim.env.HOME, "nvim-dev", plugin.name),
          }, {
            on_exit = function()
              vim.notify("Cloned " .. plugin.name .. " to dev directory", vim.log.levels.INFO, {
                title = "Plugin Cloned",
              })
            end,
          })
        end,
        desc = "Clone in to dev",
      },
      -- Open lazygit log for a plugin
      ["gL"] = {
        function(plugin)
          ---@module "snacks"
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
      ["gtt"] = {
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
      ["gtT"] = {
        function(plugin)
          Util.tmux.open(nil, { cwd = plugin.dir })
        end,
        desc = "Open TMUX in plugin dir",
      },
      ["gth"] = {
        function(plugin)
          Util.tmux.open(nil, { cwd = plugin.dir, mode = "hsplit" })
        end,
        desc = "Open TMUX in plugin dir (hsplit)",
      },
      ["gtv"] = {
        function(plugin)
          Util.tmux.open(nil, { cwd = plugin.dir, mode = "vsplit" })
        end,
        desc = "Open TMUX in plugin dir (vsplit)",
      },
    },
  },
}

-- Setup lazy.nvim
require("lazy").setup(lazy_config)
