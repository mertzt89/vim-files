local util = require("util")

---@class util.dirs
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m)
    return m.get()
  end,
})

---@class RootDir
---@field paths string[]
---@field spec RootDirSpec

---@alias RootDirFn fun(buf: number): (string|string[])

---@alias RootDirSpec string|string[]|RootDirFn

---@type RootDirSpec[]
M.spec = { { ".git" }, "cwd", "lsp" }

M.detectors = {}

function M.detectors.cwd()
  return { vim.loop.cwd() }
end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  for _, client in pairs(util.lsp_get_clients({ bufnr = buf })) do
    -- only check workspace folders, since we're not interested in clients
    -- running in single file mode
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
  end
  return vim.tbl_filter(function(path)
    path = require("lazy.core.util").norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.loop.cwd()
  local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
  -- vim.print("Found")
  -- vim.print(pattern)
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.cwd()
  return M.realpath(vim.loop.cwd()) or ""
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.loop.fs_realpath(path) or path
  return require("lazy.core.util").norm(path)
end

---@param spec RootDirSpec
---@return RootDirFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

---@param opts? { buf?: number, spec?: RootDirSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type RootDir[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

function M.info()
  local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec

  local roots = M.detect({ all = true })
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
        first and "x" or " ",
        path,
        type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = "```lua"
  lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
  lines[#lines + 1] = "```"
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Root Directories" })
  return roots[1] and roots[1].paths[1] or vim.loop.cwd()
end

---@type table<number, string>
M.cache = {}

function M.setup()
  vim.api.nvim_create_user_command("RootDirs", function()
    require("util.dirs").info()
  end, { desc = "Root dirs for the current buffer" })

  vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("root_dir_cache", { clear = true }),
    callback = function(event)
      M.cache[event.buf] = nil
    end,
  })
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {spec?: RootDirSpec, normalize?:boolean}
---@return string
function M.root(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local detect_opts = { all = false }
    if opts.spec then
      detect_opts.spec = opts.spec
    end
    local roots = M.detect(detect_opts)
    ret = roots[1] and roots[1].paths[1] or vim.loop.cwd()
    M.cache[buf] = ret
  end
  if opts.normalize then
    return ret
  end
  return util.is_win() and ret:gsub("/", "\\") or ret
end

return M
