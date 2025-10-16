---@class util.ignore
local M = {}

local default_ignore_files = {
  vim.env.HOME .. "/.ignore",
  vim.fn.getcwd() .. "/.gitignore",
  vim.fn.getcwd() .. "/.ignore",
}

local exclude = {}
local include = {}
local watchers = {}

local function try_watch(file)
  if vim.fn.filereadable(file) == 1 then
    if not watchers[file] then
      watchers[file] = require("util.file").watch(file, function(_, changed_file, ev)
        if not watchers or not watchers[changed_file] then
          return
        end

        watchers[changed_file]:stop()
        watchers[changed_file] = nil
        try_watch(changed_file)

        if ev.change then
          vim.schedule(function()
            M.refresh()
          end)
        end
      end)
    end
  end
end

local function create_commands()
  vim.api.nvim_create_user_command("IgnoreAdd", function(args)
    M.add(args.args)
  end, {
    nargs = "*",
    complete = "file",
    desc = "Add paths to ignore list",
  })

  vim.api.nvim_create_user_command("IgnoreRemove", function(args)
    M.remove(args.args)
  end, {
    nargs = "*",
    complete = "file",
    desc = "Remove paths from ignore list",
  })

  vim.api.nvim_create_user_command("IgnoreRefresh", function()
    M.refresh()
  end, {
    desc = "Refresh ignore lists",
  })

  vim.api.nvim_create_user_command("IgnoreClear", function()
    M.clear()
  end, {
    desc = "Clear ignore lists",
  })

  vim.api.nvim_create_user_command("IgnoreShowExclude", function()
    vim.notify(vim.inspect(M.get_exclude()), nil, { ft = "lua", title = "Ignore" })
  end, {
    desc = "Show current ignore list",
  })

  vim.api.nvim_create_user_command("IgnoreShowInclude", function()
    vim.notify(vim.inspect(M.get_include()), nil, { ft = "lua", title = "Ignore" })
  end, {
    desc = "Show current include list",
  })
end

---@param paths string|string[]
function M.add(paths)
  if type(paths) == "string" then
    paths = { paths }
  end

  for _, path in ipairs(paths) do
    if not vim.tbl_contains(exclude, path) then
      table.insert(exclude, path)
    end
  end
end

function M.include(paths)
  if type(paths) == "string" then
    paths = { paths }
  end

  for _, path in ipairs(paths) do
    if not vim.tbl_contains(include, path) then
      table.insert(include, path)
    end
  end
end

---@param paths string|string[]
function M.remove(paths)
  if type(paths) == "string" then
    paths = { paths }
  end

  exclude = vim.tbl_filter(function(v)
    return not vim.tbl_contains(paths, v)
  end, exclude)
end

function M.get_exclude()
  return exclude
end

function M.get_include()
  return include
end

---@param ignore_file string
function M.import(ignore_file)
  if not ignore_file then
    return
  end

  local file = io.open(ignore_file, "r")
  if not file then
    return
  end

  for line in file:lines() do
    line = line:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    -- ignore lines beginning with '#'
    if not string.match(line, "^%s*#") then
      -- Add lines starting with '!' to include list, otherwise add to exclude
      if string.sub(line, 1, 1) == "!" then
        line = string.sub(line, 2) -- Remove the '!' character
        if not vim.tbl_contains(include, line) then
          table.insert(include, line)
        end
      elseif line ~= "" and not vim.tbl_contains(exclude, line) then
        table.insert(exclude, line)
      end
    end
  end

  file:close()
end

---@param ignore_files string|string[]
local function try_import_watch(ignore_files)
  if type(ignore_files) == "string" then
    ignore_files = { ignore_files }
  end

  for _, file in ipairs(ignore_files) do
    if vim.fn.filereadable(file) then
      M.import(file)
      try_watch(file)
    end
  end
end

function M.refresh()
  M.clear()

  for _, file in ipairs(default_ignore_files) do
    try_import_watch(file)
  end
end

function M.clear()
  exclude = {}
  include = {}
end

function M.setup()
  M.refresh()
  create_commands()
end

setmetatable(M, {
  __call = function(_, ...)
    M.add(...)
  end,
})

return M
