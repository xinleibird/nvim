local target_pattern = "Syntax tree for"

local real_watch = vim.loop.fs_event

---@diagnostic disable-next-line: inject-field
vim.loop.fs_event = function(...)
  local obj = real_watch(...)
  local original_start = obj.start

  obj.start = function(self, path, flags, cb)
    if path:find(target_pattern) then
      return 0
    end
    return original_start(self, path, flags, cb)
  end

  return obj
end
