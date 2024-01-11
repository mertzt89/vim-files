return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
        disabled_filetypes = {
          statusline = { "NvimTree" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
    init = function()
      vim.opt.showmode = false
    end,
  },
  { import = ... .. ".early" },
  { import = ... .. ".code" },
  { import = ... .. ".editor" },
  { import = ... .. ".themes" },
  { import = ... .. ".tools" },
}
