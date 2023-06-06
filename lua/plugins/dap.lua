local mappings = {
  ["<leader><space>b"] = {
    function()
      require("dap").toggle_breakpoint()
    end,
    "Toggle Breakpoint",
  },
  ["<leader><space>c"] = {
    function()
      require("dap").continue()
    end,
    "Continue",
  },
  ["<leader><space>p"] = {
    function()
      require("dap").pause()
    end,
    "Pause",
  },
  ["<leader><space>C"] = {
    function()
      require("dap").run_to_cursor()
    end,
    "Run to Cursor",
  },
  ["<leader><space>n"] = {
    function()
      require("dap").step_over()
    end,
    "Step Over",
  },
  ["<leader><space>s"] = {
    function()
      require("dap").step_into()
    end,
    "Step Into",
  },
  ["<leader><space>f"] = {
    function()
      require("dap").step_out()
    end,
    "Step Out",
  },
  ["<leader><space>u"] = {
    function()
      require("dap").up()
    end,
    "Frame Up",
  },
  ["<leader><space>d"] = {
    function()
      require("dap").down()
    end,
    "Frame Down",
  },
  ["<leader><space>K"] = {
    function()
      require("dap.ui.widgets").hover()
    end,
    "Hover Info",
  },
  ["<leader><space>R"] = {
    function()
      require("dap").restart()
    end,
    "Restart Session",
  },
  ["<leader><space>q"] = {
    function()
      require("dap").terminate()
      require("dapui").close()
    end,
    "Terminate Debugging",
  },
}

local M = {
  {
    "mfussenegger/nvim-dap",
    config = function()
      for k, v in pairs(mappings) do
        vim.keymap.set("n", k, v[1], { desc = v[2] })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-float",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { silent = true })
        end,
      })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    dependencies = { "mason.nvim", "nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "cppdbg" },
        handlers = {
          function(config)
            -- all sources with no handler get passed here

            -- Keep original functionality
            require("mason-nvim-dap").default_setup(config)
          end,
          cppdbg = function(config)
            -- config.configurations = cppdbg_configs
            config.adapters = vim.tbl_extend("keep", config.adapters, { options = { initialize_timeout_sec = 10 } })
            config.configurations = {}
            require("mason-nvim-dap").default_setup(config)
            require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
          end,
        },
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = { "mason-nvim-dap.nvim" },
    config = function()
      require("dapui").setup()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.after.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}

return M
