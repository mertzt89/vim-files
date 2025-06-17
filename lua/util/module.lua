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

--- Check if a plugin is loaded
---@param name string
function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded ~= nil
end

--- Register a callback to be called when a plugin is loaded, if the 
--- plugin is already loaded, it will call the function immediately.
---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
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

function M.self()
  return M.resolve_path(debug.getinfo(1, "S").source:sub(2))
end

---@param mod string | string[]
function M.relative(mod)
  if type(mod) == "table" then
    mod = table.concat(mod, ".")
  end

  return M.parent(M.resolve_path(debug.getinfo(2, "S").source:sub(2))) .. "." .. mod
end

return M
