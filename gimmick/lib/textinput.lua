local M = {}

-- A bulk of this is adapted from Simply Love NotITG's keyboard input module, so
-- credits to them for this

-- todo: utf8 compatilibity (but also, is this really needed?)
-- todo: selections

local layouts = require 'gimmick.lib.layouts'
local LAYOUT_NAME = 'WorkmanUS' -- todo

local layout = layouts[LAYOUT_NAME]

local cmd = {
  ['left shift'] = true, ['right shift'] = true,
  ['left ctrl'] = true, ['right ctrl'] = true,
  ['left meta'] = true, ['right meta'] = true,
  ['left wnd'] = true, ['right wnd'] = true,
  ['left alt'] = true, ['right alt'] = true,
  backspace = true, menu = true, escape = true,
  left = true, right = true, up = true, down = true,
  ['caps lock'] = true, ['num lock'] = true, ['scroll lock'] = true,
  pgdn = true, pgup = true, ['end'] = true, home = true,
  prtsc = true, insert = true, pause = true, delete = true,
  unknown = true
}
for i=1, 12 do
  cmd['F' .. i] = true
end

M.capsLock = false

---@class TextInput
---@field text string[]
---@field cursor number @ the cursor shows up AFTER the character of this index
---@field insert boolean
---@field special { shift: boolean, ctrl: boolean, alt: boolean, meta: boolean, altgr: boolean }
local TextInput = {}

---@param key string
---@param held table<string, number>
function TextInput:onKey(key, held)
  if string.sub(key, 1, 3) == 'KP ' then
    key = string.sub(key, 4)
  end
  if key == 'KP' then
    return
  end

  self.special.shift = (held['left shift'] or held['right shift']) ~= nil
  self.special.ctrl = (held['left ctrl'] or held['right ctrl']) ~= nil
  self.special.alt = (held['left alt'] or held['right alt']) ~= nil
  self.special.meta = (held['left meta'] or held['right meta']) ~= nil
  self.special.altgr = held['right alt'] ~= nil or (self.special.alt and self.special.ctrl)

  if key == 'caps lock' then
    M.capsLock = not M.capsLock
    return
  elseif key == 'backspace' or key == 'delete' then
    if self.cursor > 0 then
      table.remove(self.text, self.cursor)
      self.cursor = self.cursor - 1
    end
    return
  elseif key == 'left' then
    self.cursor = self.cursor - 1
  elseif key == 'right' then
    self.cursor = self.cursor + 1
  elseif key == 'home' then
    while self.text[self.cursor] ~= '\n' and self.cursor > 0 do
      self.cursor = self.cursor - 1
    end
  elseif key == 'end' then
    while self.text[self.cursor + 1] ~= '\n' and self.cursor < #self.text do
      self.cursor = self.cursor + 1
    end
  elseif key == 'insert' then
    self.insert = not self.insert
  elseif not cmd[key] then
    local char = layout.remap[key] or key
    local out = char
    local upper = M.capsLock

    if self.special.shift and not layout.shift[char] then
      upper = not upper
    end

    if self.special.shift and layout.shift[char] then
      out = layout.shift[char]
    elseif self.special.altgr then
      out = layout.altgr[char]
    elseif self.special.alt and layout.alt[char] then
      out = self.special.shift and layout.alt[layout.alt[char]] or layout.alt[char]
    else
      if upper then
        out = string.upper(out)
      end
    end

    if not self.insert then
      table.insert(self.text, self.cursor + 1, out)
    else
      self.text[self.cursor + 1] = out
    end
    self.cursor = self.cursor + 1
  end

  local t = {}
  for k, v in pairs(self.text) do
    t[k] = v
  end
  self.text = t

  self.cursor = math.max(self.cursor, 0)
  self.cursor = math.min(self.cursor, #self.text)
end

function TextInput:toString()
  return table.concat(self.text, '')
end

TextInput.__index = TextInput

---@param text string[]?
---@return TextInput
function M.new(text)
  return setmetatable({
    text = text or {},
    cursor = 0,
    insert = false,
    special = {
      shift = false,
      ctrl = false,
      alt = false,
      meta = false,
      altgr = false
    }
  }, TextInput)
end

local testString = 'aeiouAEOIU'

---@param chars string[]
---@param text BitmapText
function M.wrapText(chars, text, maxWidth)
  local glyphLen = {}

  text:settext(testString .. testString)
  local extra = text:GetWidth() * (text:GetZoomX() * text:GetBaseZoomX())
  local fontHeight = text:GetHeight() * (text:GetZoomY() * text:GetBaseZoomY()) * 1.3

  local positions = {}

  local width = 0
  local x, y = 0,0

  for i = 1, #chars do
    local char = chars[i]

    if char == '\n' then
      y = y + fontHeight
      x = 0

      table.insert(positions, {
        char = char,
        x = x,
        y = y,
      })
    else
      if not glyphLen[char] then
        text:settext(testString .. char .. testString)
        glyphLen[char] = text:GetWidth() * (text:GetZoomX() * text:GetBaseZoomX()) - extra
      end

      if (x + glyphLen[char]) > maxWidth then
        width = maxWidth
        y = y + fontHeight
        x = 0
      end

      x = x + glyphLen[char]
      width = math.max(width, x)

      table.insert(positions, {
        char = char,
        x = x,
        y = y,
      })
    end
  end

  return positions, x, y + fontHeight
end

return M