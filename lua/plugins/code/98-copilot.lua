local copilotState = {}

local native_copilot = vim.lsp.inline_completion ~= nil
if native_copilot then
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

---@param kind string
local function pick(kind)
  return function()
    local actions = require("CopilotChat.actions")
    local items = actions[kind .. "_actions"]()
    if not items then
      vim.notify("No " .. kind .. " found on the current line", vim.log.levels.WARN)
      return
    end
    require("CopilotChat.integrations.fzflua").pick(items)
  end
end

return {
  -- Mason: Install copilot-language-server
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "copilot-language-server" },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-5",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show help actions with telescope
      { "<leader>ad", pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- Show prompts actions with telescope
      { "<leader>ap", pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      -- require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },

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
