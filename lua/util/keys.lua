---@class util.keys
local M = {}

---@class KeymapOpts
---@field noremap boolean? Whether the keymap should be non-recursive
---@field silent boolean? Whether the keymap should be silent
---@field desc string? Description of the keymap, used for documentation and help
---@field buffer number? The buffer number to which the keymap should be applied, (0 = current buffer)
---@field mode string | string[]? The mode(s) in which the keymap should be set, defaults to "n" (normal mode)

---@class Keymap
---@field [1] string lhs
---@field [2] string | function rhs
---@field [3] KeymapOpts?

---@param keymap Keymap | Keymap[]
function M.map(keymap)
  ---@type Keymap[]
  local keys = {}

  if type(keymap) == "table" and not vim.islist(keymap) then
    keys = {
      keymap --[[@as Keymap]],
    }
  else
    keys = keymap --[[@as Keymap[]]
  end

  for _, key in ipairs(keys) do
    local keyOpts = key[3] or {}
    local mode = keyOpts.mode or "n"
    local opts = {
      noremap = keyOpts.noremap ~= false,
      silent = keyOpts.silent ~= false,
      desc = keyOpts.desc or nil,
      buffer = keyOpts.buffer or nil,
    }

    vim.keymap.set(mode, key[1], key[2], opts)
  end
end

return M
