
--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 1].
]]
local function hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r, g, b
end

--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 1].
]]
local function rgbToHsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2
  if max == 0 then s = 0 else s = (max - min) / max end

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    local s
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end


--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 1] and
 * returns h, s, and v in the set [0, 1].
]]
local function rgbToHsv(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 1].
]]
local function hsvToRgb(h, s, v)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r, g, b
end

---@class color
---@field r number @red, 0.0 - 1.0
---@field g number @green, 0.0 - 1.0
---@field b number @blue, 0.0 - 1.0
---@field a number @alpha, 0.0 - 1.0
---@operator add(color): color
---@operator add(number): color
---@operator sub(color): color
---@operator sub(number): color
---@operator mul(color): color
---@operator mul(number): color
---@operator div(color): color
---@operator div(number): color
local col = {}

--- for use in actor:diffuse(col:unpack())
---@return number, number, number, number
function col:unpack()
  return self.r, self.g, self.b, self.a
end

-- conversions

---@return number, number, number
function col:rgb()
  return self.r, self.g, self.b
end

---@return number, number, number
function col:hsl()
  return rgbToHsl(self.r, self.g, self.b)
end

---@return number, number, number
function col:hsv()
  return rgbToHsv(self.r, self.g, self.b)
end

---@return string
function col:hex()
  return string.format('%02x%02x%02x',
    math.floor(self.r * 255),
    math.floor(self.g * 255),
    math.floor(self.b * 255))
end

-- setters

---@return color
function col:hue(h)
  local _, s, v = self:hsv()
  return hsv(h % 1, s, v, self.a)
end

---@return color
function col:huesmooth(h)
  local _, s, v = self:hsv()
  return shsv(h % 1, s, v, self.a)
end

---@return color
function col:alpha(a)
  return rgb(self.r, self.g, self.b, a)
end

--- multiplies current alpha by provided value
---@return color
function col:malpha(a)
  return rgb(self.r, self.g, self.b, self.a * a)
end

-- effects

---@return color
function col:invert()
  return rgb(1 - self.r, 1 - self.g, 1 - self.b, self.a)
end

---@return color
function col:grayscale()
  return rgb(self.r * 0.299 + self.g * 0.587 + self.b * 0.114, self.a)
end

---@return color
function col:hueshift(a)
  local h, s, v = self:hsv()
  return hsv((h + a) % 1, s, v, self.a)
end

local colmeta = {}

function colmeta:__index(i)
  if i == 1 then return self.r end
  if i == 2 then return self.g end
  if i == 3 then return self.b end
  if i == 4 then return self.a end
  return col[i]
end

local function typ(a)
  return ((type(a) == 'table' and a.r and a.g and a.b and a.a) and 'color') or ((type(a) == 'table' and a.l and a.a and a.b) and 'oklab') or type(a)
end

local function genericop(a, b, f, name)
  local typea = typ(a)
  local typeb = typ(b)
  if typea == 'number' then
    return rgb(f(b.r, a), f(b.g, a), f(b.b, a), b.a)
  elseif typeb == 'number' then
    return rgb(f(a.r, b), f(a.g, b), f(a.b, b), a.a)
  elseif typea == 'color' and typeb == 'color' then
    return rgb(f(a.r, b.r), f(a.g, b.g), f(a.b, b.b), f(a.a, b.a))
  end
  error('cant apply ' .. name .. ' to ' .. typea .. ' and ' .. typeb, 3)
end

function colmeta.__add(a, b)
  return genericop(a, b, function(a, b) return a + b end, 'add')
end
function colmeta.__sub(a, b)
  return genericop(a, b, function(a, b) return a - b end, 'sub')
end
function colmeta.__mul(a, b)
  return genericop(a, b, function(a, b) return a * b end, 'mul')
end
function colmeta.__div(a, b)
  return genericop(a, b, function(a, b) return a / b end, 'div')
end

function colmeta.__eq(a, b)
  return (typ(a) == 'color' and typ(b) == 'color') and (a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a)
end

function colmeta:__tostring()
  return '#' .. self:hex()
end
colmeta.__name = 'color'

-- constructors

---@return color
function rgb(r, g, b, a)
  a = a or 1
  return setmetatable({r = r, g = g, b = b, a = a or 1}, colmeta)
end

---@return color
function hsl(h, s, l, a)
  a = a or 1
  local r, g, b = hslToRgb(h % 1, s, l)
  return setmetatable({r = r, g = g, b = b, a = a or 1}, colmeta)
end

---@return color
function hsv(h, s, v, a)
  a = a or 1
  local r, g, b = hsvToRgb(h % 1, s, v)
  return setmetatable({r = r, g = g, b = b, a = a or 1}, colmeta)
end

--- smoother hsv. not correct but looks nicer
---@return color
function shsv(h, s, v, a)
  h = h % 1
  return hsv(h * h * (3 - 2 * h), s, v, a)
end

local function hexToRGB(hex)
  hex = string.gsub(hex, '#', '')
  if string.len(hex) == 3 then
    return (tonumber('0x' .. string.sub(hex, 1, 1)) * 17) / 255, (tonumber('0x' .. string.sub(hex, 2, 2)) * 17) / 255, (tonumber('0x' .. string.sub(hex, 3, 3)) * 17) / 255
  else
    return tonumber('0x' .. string.sub(hex, 1, 2)) / 255, tonumber('0x' .. string.sub(hex, 3, 4)) / 255, tonumber('0x' .. string.sub(hex, 5, 6)) / 255
  end
end

---@param hex string
---@return color
function hex(hex)
  return rgb(hexToRGB(hex))
end

-- something quite similar to the color class, but with OKLAB and specific
-- color manipulation functions
-- https://bottosson.github.io/posts/oklab/

local function srgbToOklab(r, g, b)
  local l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
	local m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
	local s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;

  local l_ = math.sqrt(l);
  local m_ = math.sqrt(m);
  local s_ = math.sqrt(s);

  return
    0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
    1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
    0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
end

local function oklabToSrgb(L, a, b)
  local l_ = L + 0.3963377774 * a + 0.2158037573 * b;
  local m_ = L - 0.1055613458 * a - 0.0638541728 * b;
  local s_ = L - 0.0894841775 * a - 1.2914855480 * b;

  local l = l_*l_*l_;
  local m = m_*m_*m_;
  local s = s_*s_*s_;

  return
     4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

---@class oklab
---@field l number
---@field a number
---@field b number
---@field alpha number
oklab = {}

oklab.__index = oklab

local function genericoplab(a, b, f, name)
  local typea = typ(a)
  local typeb = typ(b)
  if typea == 'number' then
    return oklab.new(f(b.l, a), f(b.a, a), f(b.b, a), b.alpha)
  elseif typeb == 'number' then
    return oklab.new(f(a.l, b), f(a.a, b), f(a.b, b), a.alpha)
  elseif typea == 'oklab' and typeb == 'oklab' then
    return oklab.new(f(a.l, b.l), f(a.a, b.a), f(a.b, b.b), f(a.alpha, b.alpha))
  end
  error('cant apply ' .. name .. ' to ' .. typea .. ' and ' .. typeb, 3)
end

function oklab.__add(a, b)
  return genericoplab(a, b, function(a, b) return a + b end, 'add')
end
function oklab.__sub(a, b)
  return genericoplab(a, b, function(a, b) return a - b end, 'sub')
end
function oklab.__mul(a, b)
  return genericoplab(a, b, function(a, b) return a * b end, 'mul')
end
function oklab.__div(a, b)
  return genericoplab(a, b, function(a, b) return a / b end, 'div')
end

function oklab.__eq(a, b)
  return (typ(a) == 'color' and typ(b) == 'color') and (a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a)
end

function oklab:unpack()
  -- no tonemapping for now. lol
  local r, g, b = oklabToSrgb(self.l, self.a, self.b)
  return r, g, b, self.alpha
end

---@param r number
---@param g number
---@param b number
---@param alpha? number
---@return oklab
function oklab.fromRGB(r, g, b, alpha)
  local l, a_, b_ = srgbToOklab(r, g, b)
  return setmetatable({l = l, a = a_, b = b_, alpha = alpha or 1}, oklab)
end

---@param hex string
function oklab.fromHex(hex)
  return oklab.fromRGB(hexToRGB(hex))
end

---@param color color
function oklab.fromColor(color)
  return oklab.fromRGB(color.r, color.g, color.b, color.a)
end

function oklab.new(l, a, b, alpha)
  return setmetatable({l = l, a = a, b = b, alpha = alpha or 1}, oklab)
end