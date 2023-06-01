local Plugin = { "nvim-lualine/lualine.nvim" }

Plugin.name = "lualine"

Plugin.event = "VeryLazy"

function Plugin.config()
  -- Customize auto generated theme
  local theme = require "lualine.themes.auto"
  local fore = theme.normal.c.fg
  theme.normal.b.fg = fore
  theme.insert.b.fg = fore
  theme.replace.b.fg = fore
  theme.visual.b.fg = fore
  theme.command.b.fg = fore

  -- Config
  local config = {
    options = {
      -- Disable sections and component separators
      component_separators = "",
      section_separators = { left = "", right = "" },
      theme = theme,
      always_divide_middle = false,
      disabled_filetypes = {
        statusline = { "NvimTree" },
        winbar = {},
      },
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = { {
        "mode",
        icon = " ",
      } },
      lualine_b = {
        { "filetype", icon_only = true, padding = { left = 1 } },
        {
          "filename",
          symbols = {
            modified = "●",
            readonly = "",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
        },
      },
      -- These will be filled later
      lualine_c = {
        { "branch", icon = "" },
        {
          "diff",
          -- Is it me or the symbol for modified us really weird
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          padding = { right = 1 },
        },
        {
          function()
            return "%="
          end,
        },
        {
          -- Lsp server name .
          function()
            if not rawget(vim, "lsp") then
              return ""
            end

            local Lsp = vim.lsp.util.get_progress_messages()[1]

            if vim.o.columns < 120 or not Lsp then
              return ""
            end

            local msg = Lsp.message or ""
            local percentage = Lsp.percentage or 0
            local title = Lsp.title or ""
            local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 120) % #spinners
            local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

            return content or ""
          end,
          icon = " LSP:",
          color = { fg = "#ffffff", gui = "bold" },
        },
      },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        },
      },
      lualine_y = {},
      lualine_z = { { "location", icon = " " }, "progress" },
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  require("lualine").setup(config)
end

function Plugin.init()
  vim.opt.showmode = false
end

return Plugin
