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
    { "<leader>gj", gs.next_hunk },
    { "]g", gs.next_hunk },

    -- Previous Hunk
    { "<leader>gk", gs.prev_hunk },
    { "[g", gs.prev_hunk },

    -- Staging/Resetting
    { "<leader>gs", gs.stage_hunk },
    { "<leader>gu", gs.undo_stage_hunk },
    { "<leader>gr", gs.reset_hunk },
    { "<leader>gR", gs.reset_buffer },
    { "<leader>gS", gs.stage_buffer },
    { "<leader>gp", gs.preview_hunk },

    -- Blame
    { "<leader>gb", gs.blame_line },
    { "<leader>gB", gs.toggle_current_line_blame },
  }
end

return Plugin
