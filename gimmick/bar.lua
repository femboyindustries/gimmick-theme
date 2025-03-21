---@diagnostic disable: undefined-field, need-check-nil
local easable = require 'gimmick.lib.easable'

-- if you put another local here i think i will do something to you mayflower


---@class Bar
local judge_eyes = {}

judge_eyes.__index = judge_eyes

--clamp the bar amount between 0 and 10 to avoid errors
local function clamping_tbl()
  return {
    __newindex = function(table, key, value)
      if key == "width" and value < 10.999999 then
        value = 10.999999
      end
      if key == "width" and value < 0 then
        value = 0
      end
      rawset(table, key, value)
    end
  }
end

---@param ctx Context
---@param options? {skew: number, width: number, height: number, inner_padding: number}
---@return Bar
function judge_eyes:init(ctx, options)
  if options then
    self:set_options(options)
  end

  local options = self.options

  local bar = ctx:ActorFrame()

  self.outline = ctx:Quad()
  self.outline:xy(0, 0)
  self.outline:SetWidth(options.width + options.inner_padding)
  self.outline:SetHeight(options.height + options.inner_padding)
  self.outline:skewx(-options.skew)
  self.outline:diffuse(1, 1, 1, 0.8)

  self.inner_bg = ctx:Quad()
  self.inner_bg:xy(0, 0)
  self.inner_bg:SetWidth(options.width)
  self.inner_bg:SetHeight(options.height)
  self.inner_bg:skewx(-options.skew)
  self.inner_bg:diffuse(0, 0, 0.05, 1)

  self.subbar.actor = ctx:Quad()
  self.subbar.actor:halign(0)
  self.subbar.actor:xy(0 - (options.width * 0.5 - options.inner_padding), 0)
  self.subbar.actor:SetWidth((options.width - (options.inner_padding * 2)) * 2)
  self.subbar.actor:SetHeight(options.height - options.inner_padding)
  self.subbar.actor:skewx(-options.skew)
  local colors = self:getcolor(38)
  self.subbar.actor:diffuse(colors[1] * 0.8, colors[2] * 0.8, colors[3] * 0.8, 1)
  ctx:addChild(bar, self.subbar.actor)

  for i = 1, 10, 1 do
    local inner = ctx:Quad()
    local amount = (i <= self:getBarAmount() and self:getBarLevel() or 1)
    inner:halign(0)
    inner:xy(0 - (options.width * 0.5 - options.inner_padding), 0)
    inner:SetWidth((options.width - (options.inner_padding * 2)) * amount)
    inner:SetHeight(options.height - options.inner_padding)
    inner:skewx(-options.skew)
    local colors = self:getcolor(i)
    inner:diffuse(colors[1], colors[2], colors[3], 1)
    table.insert(self.bars, inner)
    ctx:addChild(bar, inner)
  end

  ctx:addChild(bar, self.outline)
  ctx:addChild(bar, self.inner_bg)

  bar:xy(scx, scy)
  setDrawFunctionWithDT(bar, function(dt)
    self:updateSettings(dt)
    self.outline:Draw()
    self.inner_bg:Draw()
    for _, inner in ipairs(self.bars) do
      inner:Draw()
    end
    self.subbar.actor:Draw()
  end)

  self.actorframe = bar
  return self
end

---Create a new Bar instance
---@param context Context
---@param options? {skew: number, width: number, height: number, inner_padding: number}
---@return Bar
function judge_eyes.new(context, options)
  local instance = setmetatable({
    options = {
      skew = 0.4,          --how skewed it should be
      width = 400,         --width of bar
      height = 12,         --height of bar
      inner_padding = 2.5, --how much padding between the outline and actual moving bar
    },
    subbar = {
      eased = easable(0, 12),
      x = 0,
      width = 0
    },
    bars = {},
    baramountold = 0,
    barlevelold = 0,
    barlevel = 0,
    barcolors = {
      hex('#D16500'),
      hex('#E7C043'),
      hex('#8034DE'),
      hex('#5BE9E9'),
      hex('#BA8FE3'),
      hex('#C1AC8B'),
      hex('#3967E4'),
      hex('#30A937'),
      hex('#9959AA'),
      hex('#BFA3C9'),
      hex('#BE5AE8'),
      hex('#DD0000'), --the color of the subbar
    },
  }, judge_eyes)
  setmetatable(instance.subbar, clamping_tbl())
  return instance:init(context, options)
end

---Set the options of the Bar
---@param options {skew: number, width: number, height: number, inner_padding: number}
function judge_eyes:set_options(options)
  for k, v in pairs(options) do
    self.options[k] = v
  end
end

---Gets what the top most Bar Level is
---@return float
function judge_eyes:getBarLevel()
  return self.barlevel % 1
end

---Gets How many bars there are
---@return integer
function judge_eyes:getBarAmount()
  return math.floor(self.barlevel) + 1
end

---@param dt number
function judge_eyes:updateSettings(dt)
  self.outline:SetWidth(self.options.width + self.options.inner_padding)
  self.outline:SetHeight(self.options.height + self.options.inner_padding)
  self.outline:skewx(-self.options.skew)
  self.inner_bg:SetWidth(self.options.width)
  self.inner_bg:SetHeight(self.options.height)
  self.inner_bg:skewx(-self.options.skew)
  self.inner_bg:diffuse(0, 0, 0.05, 1)

  for index, value in ipairs(self.bars) do
    value:hidden(1)
  end

  for i = 1, self:getBarAmount(), 1 do
    local inner = self.bars[i]
    if inner then
      inner:hidden(0)
      local amount = (i < self:getBarAmount() and 1 or self:getBarLevel())
      inner:xy(0 - (self.options.width * 0.5 - self.options.inner_padding), 0)
      inner:SetWidth((self.options.width - (self.options.inner_padding * 2)) * amount)
      inner:SetHeight(self.options.height - self.options.inner_padding)
      inner:skewx(-self.options.skew)
      local colors = self:getcolor(i)
      inner:diffuse(colors[1], colors[2], colors[3], 1)
    end
  end

  self.subbar.x = -(self.options.width * 0.5 - self.options.inner_padding)
  if math.abs(self:getBarLevel() - 1) > 0.001 then
    self.subbar.x = self.subbar.x + (self.bars[self:getBarAmount()] or self.bars[#self.bars]):GetWidth()
  end
  self.subbar.width = (self.options.width - (self.options.inner_padding * 2)) * 1
  self.subbar.eased:update(dt)
  self.subbar.actor:x(self.subbar.x)
  if self.subbar.eased.eased < 0.1 then
    self.subbar.actor:SetWidth(0)
  else
    self.subbar.actor:SetWidth(self.subbar.eased.eased)
  end

end

---@param num number
---@return {red: number, green: number, blue: number}
function judge_eyes:getcolor(num)
  if not num then num = 11037 end
  local amount = #self.barcolors
  return self.barcolors[(num >= amount and amount or num)]
end

---@param input number
---@return boolean
function judge_eyes:inbounds(input)
  return self:getBarAmount() <= 1 and self:getBarLevel() - input < 0 and self:getBarLevel() - input <= 10
end

---Make the Bar smaller
---@param input number
---@return nil
function judge_eyes:sub(input)
  if self:inbounds(input) then
    input = self:getBarLevel()
  end

  self.baramountold = self:getBarAmount()
  self.barlevelold = self.barlevel

  local inner_width = (self.options.width - (self.options.inner_padding * 2))
  local bar_amount = self:getBarAmount()
  local bar_level = self:getBarLevel()
  local remainder = bar_level - input

  if remainder < 0 then
    remainder = 0
  end

  if math.abs(remainder) < 0.001 then
    remainder = 0
  end

  local sub_width = inner_width * input
  local max_value = inner_width * (1 - remainder)

  if max_value < 0.1 then
    max_value = 0
  end

  local a
  if self.baramountold > math.floor(self.barlevel - input) then
    a = clamp(sub_width, 0, inner_width * (1 - ((self.barlevel - input) % 1)))
  else
    a = clamp(sub_width, 0, max_value)
  end

  self.subbar.eased:reset(a)
  self.subbar.eased:set(0)

  self.barlevel = self.barlevel - input
  if self.barlevel < 0 then
    self.barlevel = 0
  end

  print('Updated Bar Level:', self.barlevel)
end

---Add to the Bar without an animation
---@param input number
function judge_eyes:add(input)
  if input < 0 then
    self:sub(-input)
  else
    self.baramountold = self:getBarAmount()
    self.barlevelold = self.barlevel
    self.barlevel = self.barlevel + input
  end

  if self.barlevel >= 10 then
    warn('Bar will not go over 10')
    self.barlevel = 9.999999
  end

end

---Set the bar to an amount without animation
---@param input number
function judge_eyes:set(input)
  if input > 10 then
    input = 9.999999
  end
  self.baramountold = self:getBarAmount()
  self.barlevelold = self.barlevel
  self.barlevel = input
end

return judge_eyes