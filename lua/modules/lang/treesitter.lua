local module = {}
local plug = require("lib.plug")

function module.register_plugins()
  -- Tresitter
  plug.use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = {"comment"}, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {"comment"} -- list of language that will be disabled
        }
      }
    end,
    run = ':TSUpdate'
  })
end

function module.init()
end

function module.context(width, separator)
  separator = separator or ' -> '

  if not plug.has_plugin("nvim-treesitter") then
    return " "
  end
  local type_patterns = {
    "class",
    "function",
    "method",
    "interface",
    "type_spec",
    "table",
    "if_statement",
    "for_statement",
    "for_in_statement",
    "call_expression",
    "comment",
    "switch_statement",
    "case_statement"
  }

  if vim.o.ft == "json" then
    type_patterns = { "object", "pair" }
  end

  local context = require("nvim-treesitter").statusline({
    indicator_size = width,
    type_patterns = type_patterns,
    separator = separator
  })
  return context or ""
end

return module
