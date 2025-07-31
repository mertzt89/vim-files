---@class util.tmux
local M = {}

---@class TmuxOpts
---@field detatch? boolean
---@field mode? "window" | "hsplit" | "vsplit"
---@field cwd? string | function(): string
local defaults = {
  detatch = false,
  ---@type "window" | "hsplit" | "vsplit"
  mode = "window",
}

local function validate(opts)
  if opts.mode ~= "window" and opts.mode ~= "hsplit" and opts.mode ~= "vsplit" then
    error("Invalid mode: " .. opts.mode .. ". Expected 'window', 'hsplit', or 'vsplit'.")
  end
end

function M.has_tmux()
  return vim.fn.executable("tmux")
end

if M.has_tmux() then
  ---@param cmd? string | string[]
  ---@param opts? TmuxOpts
  function M.open(cmd, opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    validate(opts)

    local tmux_cmd = {
      "tmux",
    }

    if opts.mode == "window" then
      table.insert(tmux_cmd, "new-window")
    elseif opts.mode == "hsplit" then
      table.insert(tmux_cmd, "split-window")
      table.insert(tmux_cmd, "-v")
    elseif opts.mode == "vsplit" then
      table.insert(tmux_cmd, "split-window")
      table.insert(tmux_cmd, "-h")
    end

    if cmd then
      table.insert(tmux_cmd, "-n")
      table.insert(tmux_cmd, cmd)
    end

    if opts.detatch then
      table.insert(tmux_cmd, "-d")
    end

    if opts.cwd then
      local cwd = type(opts.cwd) == "function" and opts.cwd() or opts.cwd
      if cwd then
        table.insert(tmux_cmd, "-c")
        table.insert(tmux_cmd, cwd)
      end
    end

    os.execute(table.concat(tmux_cmd, " "))
  end
else
  function M.open(cmd, opts)
    vim.notify("Tmux is not installed. Falling back to embedded terminal.", vim.log.levels.WARN)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    local cwd = type(opts.cwd) == "function" and opts.cwd() or opts.cwd --[[@as string]]

    Snacks.terminal.open(cmd, {
      cwd = cwd,
      start_insert = not opts.detatch,
    })
  end
end

return M
