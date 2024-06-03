local ctx = nil
local outline = nil
local inner_bg = nil

local judge_eyes = {
  options = {
    skew = 0.4,
    width = 400,
    height = 12,
    inner_padding = 2.5,
  },
  bars = {},
  barlevel = 1,
  actorframe = nil
}

function judge_eyes:init(context, options)
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

  for i = 0, self:getBarAmount(), 1 do
    local inner = ctx:Quad()
    local amount = (i <= self:getBarAmount() and self:getBarLevel() or 1)
    inner:halign(0)
    inner:xy(0 - (options.width * 0.5 - options.inner_padding), 0)
    inner:SetWidth((options.width - (options.inner_padding * 2)) * amount)
    inner:SetHeight(options.height - options.inner_padding)
    inner:skewx(-options.skew)
    inner:diffuse(math.random(), math.random(), math.random(), 1)
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
  print(self.options)
end

---@private
function judge_eyes:getBarLevel()
  return self.barlevel % 1
end

function judge_eyes:getBarAmount()
  return math.floor(self.barlevel)
end

function judge_eyes:updateSettings()
  outline:SetWidth(self.options.width + self.options.inner_padding)
  outline:SetHeight(self.options.height + self.options.inner_padding)
  outline:skewx(-self.options.skew)
  inner_bg:SetWidth(self.options.width)
  inner_bg:SetHeight(self.options.height)
  inner_bg:skewx(-self.options.skew)
  inner_bg:diffuse(0, 0, 0.05, 1)

  for i, inner in ipairs(self.bars) do
    local amount = (i < self:getBarAmount() and 1 or self:getBarLevel())
    --print(self:getBarAmount(),#self.bars,amount,i)
    inner:xy(0 - (self.options.width * 0.5 - self.options.inner_padding), 0)
    inner:SetWidth((self.options.width - (self.options.inner_padding * 2)) * amount)
    inner:SetHeight(self.options.height - self.options.inner_padding)
    inner:skewx(-self.options.skew)
  end
end

function judge_eyes:lower(input)
  self.barlevel = self.barlevel - input
  self:updateSettings()
end

function judge_eyes:add(input)
  self.barlevel = self.barlevel + input
  self:updateSettings()
end

function judge_eyes:set(input)
  self.barlevel = input
  self:updateSettings()
end

return judge_eyes
