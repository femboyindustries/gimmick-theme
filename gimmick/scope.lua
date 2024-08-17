local tick = require 'gimmick.lib.tick'

SCOPE_LOAD_REGISTRY = {}

---@class Scope
---@field name string?
---@field tick Tick
---@field event EventHandler
---@field active boolean
---@field dead boolean
local Scope = {}
Scope.__index = Scope

---@return Scope
function Scope.new(screenName)
  return setmetatable({
    name = screenName,
    tick = tick.new(),
    event = event:subhandler(screenName),
    active = false,
    dead = false,
  }, Scope)
end

function Scope:getName()
  return self.name or tostring(self)
end

---@param dt number
function Scope:update(dt)
  if not self.active then return end
  self.tick:update(dt)
end

function Scope:onCommand()
  if self.active then
    warn('onCommand on Scope called twice')
    return
  end

  if SCOPE_LOAD_REGISTRY[self:getName()] then
    warn(
      'MEMORY LEAK DETECTED; ' ..
      'Scope \'' .. self:getName() .. '\' is being initialized a second time. ' ..
      'Are you forgetting to call OffCommands on the old screen?'
    )
    -- this could be potentially worse than just ignoring it
    --SCOPE_LOAD_REGISTRY[self:getName()]:offCommand()
  end

  SCOPE_LOAD_REGISTRY[self:getName()] = self

  --print('  Entering ' .. self:getName())

  self.event:call('on')

  self.active = true
end
function Scope:offCommand()
  if self.dead then
    warn('offCommand on Scope called twice')
    return
  end

  SCOPE_LOAD_REGISTRY[self:getName()] = nil

  --print('  Leaving  ' .. self:getName())

  self.event:call('off')

  self.dead = true
  self.event:orphan()
  self.event = nil
  self.tick:lock(function()
    self.tick = nil
  end)
end

return Scope