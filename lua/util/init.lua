---@class util
---@field bootstrap util.bootstrap
---@field color util.color
---@field command util.command
---@field events util.events
---@field ignore util.ignore
---@field keys util.keys
---@field lsp util.lsp
---@field module util.module
---@field tmux util.tmux
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

--- Split a string by a separator and return a table of substrings.
---@param str string The string to split
---@param sep? string The separator to split by, defaults to whitespace
function M.split(str, sep)
  if not sep then
    sep = "%s" -- Default to whitespace if no separator is provided
  end

  local t = {} -- Create an empty table to store the results
  local pattern = "([^" .. sep .. "]+)" -- Create a pattern to match characters not in the separator
  for match in string.gmatch(str, pattern) do
    table.insert(t, match) -- Insert each matched substring into the table
  end
  return t -- Return the table containing the substrings
end

function M.is_win()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

function M.grep_operator(callback)
  local set_opfunc = vim.fn[vim.api.nvim_exec(
    [[
      func s:set_opfunc(val)
        let &opfunc = a:val
      endfunc
      echon get(function('s:set_opfunc'), 'name')
    ]],
    true
  )]

  return function()
    local op = function(t, ...)
      local regsave = vim.fn.getreg("@")
      local selsave = vim.o.selection
      local selvalid = true

      vim.o.selection = "inclusive"

      if t == "v" or t == "V" then
        vim.api.nvim_command('silent execute "normal! gvy"')
      elseif t == "line" then
        vim.api.nvim_command("silent execute \"normal! '[V']y\"")
      elseif t == "char" then
        vim.api.nvim_command('silent execute "normal! `[v`]y"')
      else
        selvalid = false
      end

      vim.o.selection = selsave
      if selvalid then
        local query = vim.fn.getreg("@")
        callback(query)
      end

      vim.fn.setreg("@", regsave)
    end

    set_opfunc(op)
    vim.api.nvim_feedkeys("g@", "n", false)
  end
end

function M.setup()
  M.events.setup()
  M.ignore.setup()
end

return M
