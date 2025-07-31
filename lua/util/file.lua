---@class util.file
local M = {}

---@alias util.file.WatcherCallback uv.fs_event_start.callback
---@alias util.file.WatcherEvent uv.uv_fs_event_t|nil
---
---@class util.file.Watcher
---@field file string
---@field callback util.file.WatcherCallback
---@field watcher util.file.WatcherEvent
local W = {}

function W:start()
  if not self.watcher then
    self.watcher = vim.uv.new_fs_event()
  end

  self.watcher:start(
    self.file,
    {},
    vim.schedule_wrap(function(err, _, ev)
      self.callback(err, self.file, ev)
    end)
  )
end

function W:stop()
  if self.watcher then
    self.watcher:stop()
    self.watcher = nil
  end
end

---@
function W:new(file, callback)
  local w = {
    file = file,
    callback = callback,
    watcher = nil, -- Will be initialized in start()
  }
  setmetatable(w, self)
  self.__index = self
  return w
end

--- Watch a file or files for changes and call the provided function upon change.
---@param file string
---@param f util.file.WatcherCallback
---@return util.file.Watcher[]
function M.watch(file, f)
  ---@type util.file.Watcher
  local w = W:new(file, f)
  w:start()
  return w
end

return M
