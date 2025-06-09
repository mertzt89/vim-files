local keymap = function(key, cmd, desc)
  return {
    key,
    function()
      require("gitsigns")[cmd]()
    end,
    desc = desc,
  }
end

return {
  {
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
    event = "LazyFile",
    -- See :help gitsigns-usage
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "➤" },
        topdelete = { text = "➤" },
        changedelete = { text = "▎" },
      },
    },

    keys = {
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
    },
  },
}
