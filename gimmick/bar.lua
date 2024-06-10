---@diagnostic disable: undefined-field, need-check-nil
local easable = require 'gimmick.lib.easable'

local ctx = nil
local outline = nil
local inner_bg = nil
local inner_width = nil

local judge_eyes = {
  options = {
    skew = 0.4,
    width = 400,
    height = 12,
    inner_padding = 2.5,
  },
  subbar = {
    actor = nil,
    eased = easable(0, 1),
    x = 0,
    width = 0
  },
  bars = {},
  barlevel = 0,
  barcolors = {
    { 1.0, 0.0, 0.0 }, -- Red
    { 1.0, 0.5, 0.0 }, -- Orange
    { 1.0, 1.0, 0.0 }, -- Yellow
    { 0.5, 1.0, 0.0 }, -- Lime green
    { 0.0, 1.0, 0.0 }, -- Green
    { 0.0, 1.0, 0.5 }, -- Teal
    { 0.0, 1.0, 1.0 }, -- Cyan
    { 0.0, 0.5, 1.0 }, -- Sky blue
    { 0.0, 0.0, 1.0 }, -- Blue
    { 0.5, 0.0, 1.0 }, -- Indigo
    { 1.0, 0.0, 1.0 }, -- Violet
    { 1.0, 0.0, 0.5 }, -- Magenta
  },
  actorframe = nil
}

function judge_eyes:init(context, options)
  ---@type Context
  ctx = context -- Initialize the global ctx
  if options then
    self:set_options(options)
  end

  local options = self.options

  local bar = ctx:ActorFrame()

  outline = ctx:Quad()
  outline:xy(0, 0)
  outline:SetWidth(options.width + options.inner_padding)
  outline:SetHeight(options.height + options.inner_padding)
  outline:skewx(-options.skew)
  outline:diffuse(1, 1, 1, 0.8)

  inner_bg = ctx:Quad()
  inner_bg:xy(0, 0)
  inner_bg:SetWidth(options.width)
  inner_bg:SetHeight(options.height)
  inner_bg:skewx(-options.skew)
  inner_bg:diffuse(0, 0, 0.05, 1)

  self.subbar.actor = ctx:Quad()
  self.subbar.actor:halign(0)
  self.subbar.actor:xy(0 - (options.width * 0.5 - options.inner_padding), scy * 0.1)
  self.subbar.actor:SetWidth((options.width - (options.inner_padding * 2)) * 2)
  self.subbar.actor:SetHeight(options.height - options.inner_padding)
  self.subbar.actor:skewx(-options.skew)
  local colors = self:getcolor(i)
  self.subbar.actor:diffuse(1, 1, 1, 1)
  ctx:addChild(bar, self.subbar.actor)

  for i = 1, 2, 1 do
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

  ctx:addChild(bar, outline)
  ctx:addChild(bar, inner_bg)


  bar:xy(scx, scy)
  bar:SetDrawFunction(function()
    self:updateSettings()
    outline:Draw()
    inner_bg:Draw()
    for _, inner in ipairs(self.bars) do
      inner:Draw()
    end
    self.subbar.actor:Draw()
  end)

  self.actorframe = bar
  return self
end

---@return ActorFrame
function judge_eyes:new(context, options)
  self:init(context, options)
  return self.actorframe
end

---@param options table
function judge_eyes:set_options(options)
  for k, v in pairs(options) do
    self.options[k] = v
  end
end

---Gets what the top most Bar Amount is
---@return int
function judge_eyes:getBarLevel()
  return self.barlevel % 1
end

---Gets How many bars there are
---@return float
function judge_eyes:getBarAmount()
  return math.floor(self.barlevel) + 1
end

local oldt = os.clock()
function judge_eyes:updateSettings()
  local newt = os.clock()
  local dt = newt - oldt
  oldt = newt

  outline:SetWidth(self.options.width + self.options.inner_padding)
  outline:SetHeight(self.options.height + self.options.inner_padding)
  outline:skewx(-self.options.skew)
  inner_bg:SetWidth(self.options.width)
  inner_bg:SetHeight(self.options.height)
  inner_bg:skewx(-self.options.skew)
  inner_bg:diffuse(0, 0, 0.05, 1)

  for index, value in ipairs(self.bars) do
    value:hidden(1)
  end

  for i = 1, self:getBarAmount(), 1 do
    local inner = self.bars[i]
    inner:hidden(0)
    local amount = (i < self:getBarAmount() and 1 or self:getBarLevel())
    inner:xy(0 - (self.options.width * 0.5 - self.options.inner_padding), 0)
    inner:SetWidth((self.options.width - (self.options.inner_padding * 2)) * amount)
    inner:SetHeight(self.options.height - self.options.inner_padding)
    inner:skewx(-self.options.skew)
    local colors = self:getcolor(i)
    inner:diffuse(colors[1], colors[2], colors[3], 1)
  end

  --print(self.subbar.actor:GetWidth(),self.subbar.actor:GetX(),self.subbar.width)
  -- Update subbar position and width
  self.subbar.x = -(self.options.width * 0.5 - self.options.inner_padding) + self.bars[self:getBarAmount()]:GetWidth()
  self.subbar.width = (self.options.width - (self.options.inner_padding * 2)) * 1
  self.subbar.eased:update(dt)
  self.subbar.actor:x(self.subbar.x)
  self.subbar.actor:SetWidth(self.subbar.eased.eased)
end

function judge_eyes:getcolor(num)
  if not num then num = 11037 end
  local amount = #self.barcolors
  return self.barcolors[(num >= amount and amount or num)]
end

function judge_eyes:sub(input)
  print('===============================')
  print('Removing ' .. input)

  local inner_width = (self.options.width - (self.options.inner_padding * 2))
  print('Inner width: ' .. inner_width)

  -- Get the bar amount and log it
  local bar_amount = self:getBarLevel()
  print('Initial bar amount: ' .. bar_amount)

  -- Calculate the remaining balls and log it
  local remainder = bar_amount - input
  print('Remaining balls: ' .. remainder)

  -- Check for underflow and adjust accordingly
  if remainder < 0 then
    -- Calculate the remaining amount to remove after moving to the lower bar
    local remaining_input = input - bar_amount
    print('Remaining input after underflow: ' .. remaining_input)

    -- Calculate the sub_width for the remaining input
    local sub_width = inner_width * remaining_input
    print('Sub width after underflow: ' .. sub_width)

    -- Calculate the max value for clamping for the lower bar
    local max_value = inner_width
    print('Max value for clamping after underflow: ' .. max_value)

    -- Apply the clamp function
    local a = clamp(sub_width, 0, max_value)
    print('Clamped value after underflow: ' .. a)

    -- Reset and set the eased value
    self.subbar.eased:reset(a)
    print('Subbar eased reset to: ' .. a)

    self.subbar.eased:set(0)
    print('Subbar eased set to 0')
  else
    -- Normal case without underflow
    self.barlevel = self.barlevel - input
    print('Updated bar level: ' .. self.barlevel)

    -- Calculate the sub_width
    local sub_width = inner_width * input
    print('Sub width: ' .. sub_width)

    -- Calculate the max value for clamping
    local max_value = inner_width * (remainder % 1)
    print('Max value for clamping: ' .. max_value)

    -- Apply the clamp function
    local a = clamp(sub_width, 0, max_value)
    print('Clamped value: ' .. a)

    -- Reset and set the eased value
    self.subbar.eased:reset(a)
    print('Subbar eased reset to: ' .. a)

    self.subbar.eased:set(0)
    print('Subbar eased set to 0')
  end

  print('===============================')
  print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
  print('===============================')
end

function judge_eyes:add(input)
  self.barlevel = self.barlevel + input
end

function judge_eyes:set(input)
  print('Setting to ' .. input)
  self.barlevel = input
end

return judge_eyes