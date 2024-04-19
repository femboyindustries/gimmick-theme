-- Every time :settext() is called on BitmapText, the engine has to recalculate
-- the position of the characters, line wrapping, etc etc etc.
-- Thus, it's more efficient to have a unique BitmapText for each piece of text
-- you want to display on a screen.
--
-- This is unfortunately, as they say, a "pain in the ass".
--
-- This class does this semi-automatically - it will allocate a pool of
-- BitmapTexts, then try and relatively sanely allocate them with given strings
-- of text, such that :settext() calls are reduced.
--
-- Alongside :settext(), there's a few other functions that call BuildChars(),
-- namely:
--
-- - CropToWidth()
-- - SetHorizAlign()
-- - SetVertAlign()
--
-- However, these don't rebuild the text if the values match, so we can ignore
-- them, and simply reset them when fetching a freshly freed actor.

---@class TextPool
---@field texts table<string, BitmapText>
---@field usage table<BitmapText, int>
---@field i int
---@field lowest int
---@field init (fun(actor: BitmapText): nil)?
local TextPool = {}

-- this is very intentionally named
local FREE_USE = -1

---@param ctx Context
---@param font string
---@param size number? @ Keep this at around the number of texts drawn per frame
---@param init (fun(actor: BitmapText): nil)?
function TextPool.new(ctx, font, size, init)
  size = size or 32

  local actors = {}

  for _ = 1, size do
    local text = ctx:BitmapText(font)
    if init then init(text) end
    table.insert(actors, text)
  end

  local usage = {}

  for _, actor in ipairs(actors) do
    usage[actor] = FREE_USE
  end

  return setmetatable({
    usage = usage,
    texts = {},
    i = 1,
    lowest = nil,
    init = init,
  }, TextPool)
end

TextPool.__index = TextPool

---@return BitmapText
function TextPool:free()
  if not self.lowest then
    -- pool is not exhausted, just fetch a FREE_USE actor
    for actor, use in pairs(self.usage) do
      if use == FREE_USE then
        self.usage[actor] = self.i
        self.i = self.i + 1
        return actor
      end
    end
    -- nvm
    self.lowest = 1
  end
  -- pool is exhausted, look for lowest
  for actor, use in pairs(self.usage) do
    if use == self.lowest then
      self.lowest = self.lowest + 1
      self.usage[actor] = self.i
      self.i = self.i + 1
      return actor
    end
  end

  error('could not find actor to use with lowest index??')
end

---@param text string
---@return BitmapText
function TextPool:get(text)
  local cached = self.texts[text]
  if cached then return cached end

  local new = self:free()
  new:align(0.5, 0.5)
  new:wrapwidthpixels(-1)
  if self.init then
    self.init(new)
  end
  new:settext(text)
  self.texts[text] = new
  return new
end

return TextPool