local easable = require 'gimmick.lib.easable'
local actor235 = require 'gimmick.lib.actor235'
local judge = require 'gimmick.lib.color'

---@class MeterWheel
---@field meter easable @ easable<number>
---@field color easable @ easable<color>
---@field pie Sprite
---@field rating BitmapText
---@field shader RageShaderProgram
local MeterWheel = {}

MeterWheel.__index = MeterWheel

---@param ctx Context
---@param scope Scope
function MeterWheel.new(ctx, scope)
  local wheel = setmetatable({
    meter = scope.tick:easable(0, 20),
    color = scope.tick:easable(DIFFICULTIES[DIFFICULTY_BEGINNER].color, 18),

    rating = ctx:BitmapText(FONTS.sans_serif),

    shader = ctx:Shader('Shaders/pie.frag'),
    pie = ctx:Sprite('Graphics/white.png'),
  }, MeterWheel)

  wheel.rating:shadowlength(0)

  wheel.pie:addcommand('Init', function(a)
    a:SetShader(actor235.Proxy.getRaw(wheel.shader))
  end)

  return wheel
end

---@param meter number
---@param difficulty number?
function MeterWheel:set(meter, difficulty)
  self.meter:reset(meter)
  if difficulty then
    local diff = DIFFICULTIES[difficulty] or DIFFICULTIES[DIFFICULTY_EDIT]
    self.color:reset(diff.color)
  end
end
---@param meter number
---@param difficulty number?
function MeterWheel:ease(meter, difficulty)
  self.meter:set(meter)
  if difficulty then
    local diff = DIFFICULTIES[difficulty] or DIFFICULTIES[DIFFICULTY_EDIT]
    self.color:set(diff.color)
  end
end

function MeterWheel:draw(x, y)
  local fill = self.meter.eased / 20

  self.pie:diffuse(self.color.eased:unpack())

  for cycle = 1, math.floor(1 + fill) do
    local widthPx = 10
    local size = 64 + (cycle - 1) * 32
    self.pie:xywh(x, y, size, size)

    local a = clamp(fill - (cycle - 1), 0, 1)

    self.shader:uniform1f('width', 1 / (size * 0.5) * math.min(a * 20, 1))
    self.shader:uniform1f('radiusOffset', widthPx / (size * 0.5) * 0.5)
    self.shader:uniform1f('fill', 1)
    self.pie:diffusealpha(0.5)
    self.pie:Draw()

    self.shader:uniform1f('width', widthPx / (size * 0.5))
    self.shader:uniform1f('radiusOffset', 0)
    self.shader:uniform1f('fill', a)
    self.pie:diffusealpha(1)
    self.pie:Draw()
  end

  self.rating:settext(tostring(self.meter.target))
  self.rating:xy(x, y)
  self.rating:diffuse(1, 1, 1, 1)
  self.rating:zoom(0.55)
  self.rating:Draw()
end

return MeterWheel