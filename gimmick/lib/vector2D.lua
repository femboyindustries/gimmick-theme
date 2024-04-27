---@class vector2D A vector can be defined as a set of 2 coordinates. They can be obtained by doing either vect.x and vect.y or vect[1] and vect[2], for compatibility purposes.
---The reason such a simple class exists is to do simplified math with it - math abstracted as :length(), :angle(), etc is much easier to read.
---@field public x number @x coordinate
---@field public y number @y coordinate
---@operator add(vector2D): vector2D
---@operator add(number): vector2D
---@operator sub(vector2D): vector2D
---@operator sub(number): vector2D
---@operator mul(vector2D): vector2D
---@operator mul(number): vector2D
---@operator div(vector2D): vector2D
---@operator div(number): vector2D
---@operator unm: vector2D
local vect = {}

---@return number
function vect:length()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

---@return number
function vect:lengthSquared()
  return self.x * self.x + self.y * self.y
end

---@return number @angle in degrees
function vect:angle()
  return math.deg(math.atan2(self.y, self.x))
end

---@return vector2D
function vect:normalize()
  local len = self:length()
  if len ~= 0 and len ~= 1 then
    return vector2D(self.x / len, self.y / len)
  else
    return self
  end
end

---@return vector2D
function vect:resize(x)
  local n = self:normalize()
  return vector2D(n.x * x, n.y * x)
end

---@param ang number @angle in degrees
---@return vector2D
function vect:rotate(ang)
  local a = self:angle()
  local len = self:length()
  return vectorFromAngle(a + ang, len)
end

---@return number, number
function vect:unpack()
  return self.x, self.y
end

---@param v2 vector2D
---@return number
function vect:distance(v2)
  return (self - v2):length()
end

---@param v2 vector2D
---@return number
function vect:distanceSquared(v2)
  return (self - v2):lengthSquared()
end

local vectmeta = {}

local function typ(a)
  return (type(a) == 'table' and a.x and a.y) and 'vector' or type(a)
end

local function genericop(a, b, f, name)
  local typea = typ(a)
  local typeb = typ(b)
  if typea == 'number' then
    return vector2D(f(b.x, a), f(b.y, a))
  elseif typeb == 'number' then
    return vector2D(f(a.x, b), f(a.y, b))
  elseif typea == 'vector' and typeb == 'vector' then
    return vector2D(f(a.x, b.x), f(a.y, b.y))
  end
  error('cant apply ' .. name .. ' to ' .. typea .. ' and ' .. typeb, 3)
end

function vectmeta.__add(a, b)
  return genericop(a, b, function(a, b) return a + b end, 'add')
end
function vectmeta.__sub(a, b)
  return genericop(a, b, function(a, b) return a - b end, 'sub')
end
function vectmeta.__mul(a, b)
  return genericop(a, b, function(a, b) return a * b end, 'mul')
end
function vectmeta.__div(a, b)
  return genericop(a, b, function(a, b) return a / b end, 'div')
end

function vectmeta.__eq(a, b)
  return (typ(a) == 'vector' and typ(b) == 'vector') and (a.x == b.x and a.y == b.y)
end

function vectmeta:__unm()
  return vector2D(-self.x, -self.y)
end

function vectmeta:__tostring()
  return '(' .. self.x .. ', ' .. self.y .. ')'
end
vectmeta.__name = 'vector'

function vectmeta:__index(i)
  if i == 1 then return self.x end
  if i == 2 then return self.y end
  return vect[i]
end

--- create a new vector
---@param x number | nil
---@param y number | nil
---@return vector2D
function vector2D(x, y)
  x = x or 0
  y = y or x
  return setmetatable({x = x, y = y}, vectmeta)
end

--- create a new vector from an angle
---@param ang number | nil @angle in degrees
---@param amp number | nil
---@return vector2D
function vectorFromAngle(ang, amp)
  ang = math.rad(ang or 0)
  amp = amp or 1
  return vector2D(math.cos(ang) * amp, math.sin(ang) * amp)
end

vector = vector2D