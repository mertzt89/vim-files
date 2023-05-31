local Plugin = { "lukas-reineke/indent-blankline.nvim" }

Plugin.name = "indent_blankline"

Plugin.event = { "BufReadPost", "BufNewFile" }

-- See :help indent-blankline-setup
Plugin.opts = {
  char = "▏",
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  use_treesitter = true,
  show_current_context = false,
  buftype_exclude = { "terminal" },
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "qf",
    "",
  },
}

return Plugin
