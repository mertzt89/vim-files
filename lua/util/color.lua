---@class util.color
local M = {}

-- local function resolve(hl)
--   if not hl then
--     return nil
--   end
--
--   if hl.link then
--     -- If the highlight is a link, resolve it to the actual highlight group
--     local linked = vim.api.nvim_get_hl(0, {name = hl.link}, true)
--     if linked then
--       return resolve(linked)
--     end
--   end
--
-- end

---@param name string Name of defined highlight
function M.fg(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: deprecated
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

---@param hl string hightlight group to brighten
---@param by number amount to brighten by in float percent, defaults to 1.1
function M.adjust_brightness(hl, by)
  local orig = M.fg(hl)
  if orig == nil or orig.fg == nil then
    return nil
  end

  local r, g, b = orig.fg:match("#(%x%x)(%x%x)(%x%x)")
  if not (r and g and b) then
    return nil
  end

  r = math.min(255, math.floor(tonumber(r, 16) * by))
  g = math.min(255, math.floor(tonumber(g, 16) * by))
  b = math.min(255, math.floor(tonumber(b, 16) * by))

  local ret = {
    fg = string.format("#%02x%02x%02x", r, g, b),
  }
  return ret
end

return M
