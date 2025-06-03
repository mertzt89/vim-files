local add = MiniDeps.add

-- Utility function to create a default map for which-key,
-- the main purpose is to make the spec below more readable
--
-- @param key string
-- @param desc string
-- @param mode string or string[]
local function default_map(key, desc, mode)
  local m = mode or { "n", "v" }

  return {
    key,
    desc = desc,
    mode = m,
  }
end

add({
  source = "folke/which-key.nvim",
})

require("which-key").setup({
  spec = {
    default_map("g", "+goto"),
    default_map("gz", "+surround"),
    default_map("]", "+next"),
    default_map("[", "+prev"),
    default_map("<leader>b", "+buffer"),
    default_map("<leader>c", "+code"),
    default_map("<leader>f", "+file/find"),
    default_map("<leader>g", "+git"),
    default_map("<leader>q", "+quit/session"),
    default_map("<leader>u", "+ui"),
    default_map("<leader>w", "+windows"),
    default_map("<leader>x", "+diagnostics/quickfix"),
  },
})
