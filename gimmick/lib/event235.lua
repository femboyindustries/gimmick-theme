---@class EventHandler
---@field callbacks table<string, fun()[]>
---@field children EventHandler[]
---@field parent EventHandler?
---@field name string?
local EventHandler = {}

EventHandler.__index = EventHandler

function EventHandler:__tostring()
  -- wow! horrid
  local name = rawget(self, 'name')
  if not name then
    local f = getmetatable(self).__tostring
    getmetatable(self).__tostring = nil
    name = tostring(self)
    getmetatable(self).__tostring = f
  end
  return 'EventHandler (' .. name .. ')'
end

---@param event string
---@param ... any
---@return any
--- Call a defined callback.
function EventHandler:call(event, ...)
  if self.callbacks[event] then
    for _, callback in ipairs(self.callbacks[event]) do
      --local start = os.clock()
      local res = callback(unpack(arg))
      --local dur = os.clock() - start

      if res ~= nil then return res end
    end
  end
  for _, child in pairs(self.children) do
    child:call(event, unpack(arg))
  end
end

---@param event string
---@param f function
--- Register a callback handler.
function EventHandler:on(event, f)
  if not self.callbacks[event] then
    self.callbacks[event] = {}
  end
  table.insert(self.callbacks[event], f)
end

-- Create a subhandler, passing all the events of this handler to it
---@param name string?
---@return EventHandler
function EventHandler:subhandler(name)
  local handler = self.new(name)
  table.insert(self.children, handler)
  handler.parent = self
  return handler
end

-- Orphan a subhandler, not letting it recieve events from its parent anymore
function EventHandler:orphan()
  if not self.parent then
    error('Tried to orphan parentless EventHandler', 2)
  end

  local children = self.parent.children
  for i = #children, 1, -1 do
    local child = children[i]
    if child == self then
      table.remove(children, i)
      break
    end
  end
  self.parent = nil
end

---@param name string?
---@return EventHandler
function EventHandler.new(name)
  return setmetatable({
    name = name,
    callbacks = {},
    children = setmetatable({}, { __mode = 'v' }),
  }, EventHandler)
end

return setmetatable(EventHandler, EventHandler)