local Plugin = { "lewis6991/gitsigns.nvim" }

Plugin.name = "gitsigns"

Plugin.event = { "BufReadPre", "BufNewFile" }

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

Plugin.keys = function()
  local gs = require("gitsigns")
  return {
    -- Next Hunk
    { "<leader>gj", gs.next_hunk, desc = "Next Hunk" },
    { "]g", gs.next_hunk, desc = "Next Hunk" },

    -- Previous Hunk
    { "<leader>gk", gs.prev_hunk, desc = "Previous Hunk" },
    { "[g", gs.prev_hunk, desc = "Previous Hunk" },

    -- Staging/Resetting
    { "<leader>gs", gs.stage_hunk, desc = "Stage Hunk" },
    { "<leader>gu", gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
    { "<leader>gr", gs.reset_hunk, desc = "Reset Hunk" },
    { "<leader>gR", gs.reset_buffer, desc = "Reset Buffer" },
    { "<leader>gS", gs.stage_buffer, desc = "Stage Buffer" },
    { "<leader>gp", gs.preview_hunk, desc = "Preview Hunk" },

    -- Blame
    { "<leader>gb", gs.blame_line, desc = "Blame Line" },
    { "<leader>gB", gs.toggle_current_line_blame, desc = "Toggle Blame Line" },
  }
end

return Plugin
