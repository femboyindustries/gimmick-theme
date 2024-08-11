local tick = require 'gimmick.lib.tick'

---@class Scope
---@field tick Tick
---@field event EventHandler
---@field active boolean
---@field dead boolean
local Scope = {}
Scope.__index = Scope

---@return Scope
function Scope.new(screenName)
  return setmetatable({
    tick = tick.new(),
    event = event:subhandler(screenName),
    active = false,
    dead = false,
  }, Scope)
end

---@param dt number
function Scope:update(dt)
  if not self.active then return end
  self.tick:update(dt)
end

function Scope:onCommand()
  if self.active then
    warn('onCommand on scope called twice')
    return
  end

  self.event:call('on')

  self.active = true
end
function Scope:offCommand()
  if self.dead then
    warn('offCommand on scope called twice')
    return
  end

  self.event:call('off')

  self.dead = true
  self.event:orphan()
  self.event = nil
  self.tick:lock(function()
    self.tick = nil
  end)
end

return Scope