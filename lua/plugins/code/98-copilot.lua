local copilotState = {}

local enableCopilotLSP = vim.lsp.inline_completion ~= nil

if enableCopilotLSP then
  ---@alias copilot_status_notification_data { status: ''|'Normal'|'InProgress'|'Warning', message: string }

  ---@param result copilot_status_notification_data
  local function copilotStatusNotificationHandler(_, result, _)
    copilotState = result
  end

  vim.lsp.inline_completion.enable()
  vim.lsp.config("copilot", {
    handlers = {
      statusNotification = copilotStatusNotificationHandler,
    },
  })
  vim.lsp.enable("copilot")

  -- Keymaps for copilot
  Util.lsp.on_attach(function(client, bufnr)
    if client.name ~= "copilot" then
      return
    end

    Util.keys.map({
      {
        "<M-]>",
        function()
          vim.lsp.inline_completion.select({ count = 1 })
        end,
        { mode = { "n", "i" }, desc = "Next Copilot Suggestion", buffer = bufnr },
      },
      {
        "<M-[>",
        function()
          vim.lsp.inline_completion.select({ count = -1 })
        end,
        { mode = { "n", "i" }, desc = "Previous Copilot Suggestion", buffer = bufnr },
      },
      {
        "<M-l>",
        function()
          return vim.lsp.inline_completion.get()
        end,
        { mode = { "n", "i" }, desc = "Accept Copilot Suggestion", buffer = bufnr },
      },
    })
  end)
else
  vim.notify("LSP Inline Completion not available (available on nightly)", vim.log.levels.WARN)
end

return {
  -- Mason: Install copilot-language-server
  enableCopilotLSP
      and {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = { "copilot-language-server" },
        },
      }
    or nil,

  -- Blink CMP source for Copilot
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  -- Add copilot status to lualine
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local colors = {
        [""] = Util.color.fg("Special"),
        ["Normal"] = Util.color.fg("Special"),
        ["Warning"] = Util.color.fg("DiagnosticError"),
        ["InProgress"] = Util.color.fg("DiagnosticWarn"),
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          return " "
        end,
        cond = function()
          local ok, clients = pcall(Util.lsp.get_clients, { name = "copilot", bufnr = 0 })
          if not ok then
            return false
          end
          return ok and #clients > 0
        end,
        color = function()
          if copilotState and colors[copilotState.status] then
            return colors[copilotState.status]
          end

          return colors[""]
        end,
      })
    end,
  },
}
