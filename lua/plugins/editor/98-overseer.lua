-- Custom lualine component (that supports lazy loading)
--
-- The included overseer compenent for lualine is not friendly with lazy loading,
-- this is more or less the same implementation, but with lazy loading taken in
-- to consideration
local component = require("lualine.component"):extend()
local utils = require("lualine.utils.utils")

function component:init(options)
  self.super.init(self, options)
  self.highlight_groups = {}
  self.symbols = {}
  self._overseer_loaded = false
end

function component:overseer_loaded()
  local constants = require("overseer.constants")
  local STATUS = constants.STATUS
  local default_icons = {
    [STATUS.FAILURE] = "󰅚 ",
    [STATUS.CANCELED] = " ",
    [STATUS.SUCCESS] = "󰄴 ",
    [STATUS.RUNNING] = "󰑮 ",
  }
  self.symbols = default_icons
  self._overseer_loaded = true
end

function component:update_colors()
  if not self._overseer_loaded and Util.module.is_loaded("overseer.nvim") then
    component.overseer_loaded(self)
  end

  if not self._overseer_loaded then
    return
  end

  local constants = require("overseer.constants")
  local STATUS = constants.STATUS

  self.highlight_groups = {}
  for _, status in ipairs(STATUS.values) do
    local hl = string.format("Overseer%s", status)
    local color = Util.color.fg(hl)
    self.highlight_groups[status] = self:create_hl(color, status)
  end
end

function component:update_status()
  if not self._overseer_loaded and Util.module.is_loaded("overseer.nvim") then
    component.overseer_loaded(self)
    component.update_colors(self)
  end

  if not self._overseer_loaded then
    return
  end

  local util = require("overseer.util")
  local task_list = require("overseer.task_list")
  local constants = require("overseer.constants")
  local STATUS = constants.STATUS

  local tasks = task_list.list_tasks(self.options)
  local tasks_by_status = util.tbl_group_by(tasks, "status")
  local pieces = {}

  if self.options.label then
    table.insert(pieces, self.options.label)
  end

  for _, status in ipairs(STATUS.values) do
    local status_tasks = tasks_by_status[status]
    if self.symbols[status] and status_tasks then
      local hl_start = self:format_hl(self.highlight_groups[status])
      table.insert(pieces, string.format("%s%s%s", hl_start, self.symbols[status], #status_tasks))
    end
  end
  if #pieces > 0 then
    return table.concat(pieces, " ")
  end
end

return {
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "bottom",
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["q"] = "<cmd>OverseerClose<CR>",
        },
      },
    },
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    keys = {
      {
        "<leader><CR>",
        "<cmd>OverseerRun<CR>",
        desc = "Run Task",
      },
      { "<leader>oo", "<cmd>OverseerToggle<CR>", desc = "Toggle Overseer Panel" },
      { "<leader>oa", "<cmd>OverseerQuickAction<CR>", desc = "Quick Action" },
      { "<leader>of", "<cmd>OverseerQuickAction open float<CR>", desc = "Open Float" },
      { "<leader>ol", "<cmd>OverseerRestartLast<CR>", desc = "Restart Last Task" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task Builder" },
    },
    init = function()
      Util.module.on_load("overseer.nvim", function()
        vim.api.nvim_create_user_command("OverseerRestartLast", function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end, {})
      end)
    end,
  },

  -- Add Overseer component to lualine config
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        component,
      })
    end,
  },
}
