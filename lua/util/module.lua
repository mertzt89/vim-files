local M = {}

--- Convert lua module name to file path within config directory
function M.resolve_module(path)
  local config_path = vim.fn.stdpath("config")
  if path:sub(1, 1) == "." then
    path = config_path .. path:sub(2)
  elseif path:sub(1, 1) ~= "/" then
    path = config_path .. "/lua/" .. path:gsub("%.", "/")
  end
  return path
end

--- Convert file path to lua module name
function M.resolve_path(path)
  local config_path = vim.fn.stdpath("config") .. "/lua/"
  if path:sub(1, #config_path) == config_path then
    path = path:sub(#config_path + 1)
  end
  local result = path:gsub("/", "."):gsub("%.lua$", "")
  return result
end

function M.foreach_lua_do(path, func)
  local files = vim.fn.readdir(path, [[v:val =~ '\.lua$']])
  for _, file in ipairs(files) do
    local full_path = path .. "/" .. file
    if vim.fn.isdirectory(full_path) == 0 then
      func(full_path)
    end
  end
end

function M.parent(module)
  local parts = vim.split(module, ".", { plain = true })
  if #parts == 1 then
    return nil
  end
  table.remove(parts, #parts)
  return table.concat(parts, ".")
end

return M
