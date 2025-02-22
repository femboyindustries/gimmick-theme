-- FlexVer 1.1.1 Lua implementation by Jade "oatmealine"

---@enum FlexVer.SegmentType
local SegmentType = {
  -- The run is entirely non-digit codepoints
  Text = 0,
  -- The run is entirely digit codepoints
  Numeric = 1,
  -- The run's first codepoint is ASCII hyphen-minus (`-`) **and is longer than one codepoint**
  Prerelease = 2,
  -- Represents blank padding spots used when two versions' lengths do not match.
  Null = 3,
}

local NULL = { type = SegmentType.Null }

---@type table<FlexVer.SegmentType, fun(a: FlexVer.Segment, b: FlexVer.Segment): number>
local comparators = {}

local function compare(a, b)
  return comparators[a.type](a, b)
end

comparators[SegmentType.Null] = function(a, b)
  return b.type == SegmentType.Null and 0 or -compare(b, a)
end
comparators[SegmentType.Text] = function(a, b)
  if b.type == SegmentType.Null then return 1 end
  for i = 1, math.min(string.len(a.value), string.len(b.value)) do
    local c1, c2 = string.sub(a.value, i, i), string.sub(b.value, i, i)
    if c1 ~= c2 then return string.byte(c1) - string.byte(c2) end
  end
  return string.len(a.value) - string.len(b.value)
end
comparators[SegmentType.Prerelease] = function(a, b)
  if b.type == SegmentType.Null then return -1 end
  return comparators[SegmentType.Text](a, b)
end
comparators[SegmentType.Numeric] = function(a, b)
  if b.type == SegmentType.Null then return 1 end
  if b.type ~= SegmentType.Numeric then return comparators[SegmentType.Text](a, b) end

  return tonumber(a.value) - tonumber(b.value)
end

local function isAsciiNumber(char)
  local c = string.byte(char)
  return c >= 48 and c <= 57
end

---@alias FlexVer.Segment { type: FlexVer.SegmentType, value: string }

---@param str string
local function makeSegment(str)
  if isAsciiNumber(string.sub(str, 1, 1)) then
    return { type = SegmentType.Numeric, value = str }
  elseif string.find(str, '^%-%D') then
    return { type = SegmentType.Prerelease, value = str }
  end
  return { type = SegmentType.Text, value = str }
end

---@class FlexVer
---@field segments FlexVer.Segment[]
local FlexVer = {}
FlexVer.__index = FlexVer

---@param str string
---@return FlexVer
function FlexVer.new(str)
  local self = setmetatable({}, FlexVer)
  self.segments = {}

  local buffer = {}
  local lastIsNumber

  for i = 1, string.len(str) do
    local c = string.sub(str, i, i)
    if c == '+' then break end
    local isNumber = isAsciiNumber(c)
    if lastIsNumber == nil then lastIsNumber = isNumber end
    if i ~= 1 and (lastIsNumber ~= isNumber or (c == '-' and buffer[1] ~= '-')) then
      local segment = table.concat(buffer, '')
      table.insert(self.segments, makeSegment(segment))
      buffer = {}
    end
    lastIsNumber = isNumber

    table.insert(buffer, c)
  end

  if #buffer > 0 then
    local segment = table.concat(buffer, '')
    table.insert(self.segments, makeSegment(segment))
  end

  return self
end

---@param other FlexVer
---@return number
function FlexVer:compare(other)
  for i = 1, math.max(#self.segments, #other.segments) do
    local c = compare(self.segments[i] or NULL, other.segments[i] or NULL)
    if self.segments[i] and other.segments[i] then print(self.segments[i].value, c, other.segments[i].value) end
    if c ~= 0 then return c end
  end
  return 0
end

return FlexVer