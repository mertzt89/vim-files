return {
  "lukas-reineke/indent-blankline.nvim",
  name = "indent_blankline",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  -- See :help ibl.setup()
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "NvimTree",
        "lazy",
        "mason",
      },
    },
  },
}
