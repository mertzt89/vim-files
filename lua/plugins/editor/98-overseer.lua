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
      require("util.module").on_load("overseer.nvim", function()
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
      table.insert(opts.sections.lualine_x, { "overseer", cond = function() return require("util.module").is_loaded("overseer.nvim") ~= nil end })
    end,
  },
}
