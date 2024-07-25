local Plugin = { "lewis6991/gitsigns.nvim" }

Plugin.name = "gitsigns"

Plugin.event = "LazyFile"

-- See :help gitsigns-usage
Plugin.opts = {
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "➤" },
    topdelete = { text = "➤" },
    changedelete = { text = "▎" },
  },
}

local keymap = function(key, cmd, desc)
  return {
    key,
    function()
      require("gitsigns")[cmd]()
    end,
    desc,
  }
end

Plugin.keys = {
  -- Next Hunk
  keymap("<leader>gj", "next_hunk", "Next Hunk"),
  keymap("]g", "next_hunk", "Next Hunk"),

  -- Previous Hunk
  keymap("<leader>gk", "prev_hunk", "Previous Hunk"),
  keymap("[g", "prev_hunk", "Previous Hunk"),

  -- Staging/Resetting
  keymap("<leader>gs", "stage_hunk", "Stage Hunk"),
  keymap("<leader>gu", "undo_stage_hunk", "Undo Stage Hunk"),
  keymap("<leader>gr", "reset_hunk", "Reset Hunk"),
  keymap("<leader>gR", "reset_buffer", "Reset Buffer"),
  keymap("<leader>gS", "stage_buffer", "Stage Buffer"),
  keymap("<leader>gp", "preview_hunk", "Preview Hunk"),

  -- Blame
  keymap("<leader>gb", "blame_line", "Blame Line"),
  keymap("<leader>gB", "toggle_current_line_blame", "Toggle Blame Line"),
}

return Plugin
