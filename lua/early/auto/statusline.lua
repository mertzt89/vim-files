local add = MiniDeps.add

local function isRecording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end -- not recording
  return "Recording @" .. reg
end

add({
  source = "nvim-lualine/lualine.nvim",
})

require("lualine").setup({
  options = {
    theme = "auto",
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
    lualine_x = { { isRecording, color = "Number" }, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
