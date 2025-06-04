local M = {}

---@type string[]
local ensure = {}

--- Ensure treesitter module(s)
---@param modules string | string[]
function M.ensure(modules)
  -- Convert to list if modules is a string
  if type(modules) == "string" then
    modules = { modules }
  end

  -- Ensure each module is in the list
  for _, module in ipairs(modules) do
    if not vim.tbl_contains(ensure, module) then
      table.insert(ensure, module)
    end
  end
end

function M.get_ensure()
  return ensure
end

return M
