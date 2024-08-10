local tick = require 'gimmick.lib.tick'

---@class Scope
---@field tick Tick
---@field active boolean
---@field dead boolean
local Scope = {}
Scope.__index = Scope

---@return Scope
function Scope.new()
  return setmetatable({
    tick = tick:new(),
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
  self.active = true
end
function Scope:offCommand()
  self.dead = true
end

return Scope