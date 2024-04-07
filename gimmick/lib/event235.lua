local M = {}

local callbacks = {}

---@param event string
---@param ... any
---@return any
--- Call a defined callback.
function M.call(event, ...)
  if callbacks[event] then
    for _, callback in ipairs(callbacks[event]) do
      --local start = os.clock()
      local res = callback(unpack(arg))
      --local dur = os.clock() - start

      if res ~= nil then return res end
    end
  end
end

---@param event string
---@param f function
--- Register a callback handler.
function M.on(event, f)
  if not callbacks[event] then
    callbacks[event] = {}
  end
  table.insert(callbacks[event], f)
end

return M