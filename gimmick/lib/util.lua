---@generic T
---@param a T
---@param b T
---@param x number
---@return T
function mix(a, b, x)
  return a + (b - a) * x
end

---@param n number
---@return number
function round(n)
  return math.floor(n + 0.5)
end

---@param x number
---@return number
function sign(x)
  if x < 0 then return -1 end
  if x > 0 then return 1 end
  return 0
end

---@param x number
---@return number
function signStrict(x)
  if x < 0 then return -1 end
  return 1
end

---@param x number
---@param a number
---@param b number
---@return number
function clamp(x, a, b)
  return math.max(math.min(x, math.max(a, b)), math.min(a, b))
end

---@param o any
---@param r number?
---@return string
function fullDump(o, r, forceFull)
  if type(o) == 'table' and (not r or r > 0) then
    local s = '{'
    local first = true
    for k,v in pairs(o) do
      if not first then
        s = s .. ', '
      end
      local nr = nil
      if r then
        nr = r - 1
      end
      if type(k) ~= 'number' or forceFull then
        s = s .. tostring(k) .. ' = ' .. fullDump(v, nr)
      else
        s = s .. fullDump(v, nr)
      end
      first = false
    end
    return s .. '}'
  elseif type(o) == 'string' then
    return '"' .. o .. '"'
  else
    return tostring(o)
  end
end

---@param x number
---@return number
function pingpong(x)
  return math.abs(x % 2 - 1)
end

---@param x number
---@param snap number
---@return number
function snap(x, snap)
  return math.floor(x / snap + 0.5) * snap
end

---@param inputstr string
---@param sep string
---@return string[]
function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

---@param str string
---@param len number
---@param char string
function lpad(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

function escapeLuaPattern(str)
  return str:gsub("([%^%$%(%)%.%[%]%*%+%-%?])","%%%1")
end

function replace(s, oldValue, newValue)
  return string.gsub(s, escapeLuaPattern(oldValue), newValue)
end

function startsWith(str, sub)
  return str:sub(1, #sub) == sub
end

function endsWith(str, sub)
  return str:sub(-#sub) == sub
end

local whitespaces = {' ', '\n', '\r'}

---@param str string
function trimLeft(str)
  while includes(whitespaces, string.sub(str, 1, 1)) do
    str = string.sub(str, 2)
  end
  return str
end

---@param str string
function trimRight(str)
  while includes(whitespaces, string.sub(str, -1, -1)) do
    str = string.sub(str, 1, -2)
  end
  return str
end

---@param str string
function trim(str)
  return trimRight(trimLeft(str))
end

---@generic T table<any>
---@param tab T
---@return T
function deepcopy(tab)
  local new = {}
  for k, v in pairs(tab) do
    if type(v) == 'table' then
      local mt = getmetatable(v)
      new[k] = deepcopy(v)
      if mt then
        setmetatable(new[k], deepcopy(mt))
      end
    else
      new[k] = v
    end
  end
  return new
end

function slice(tbl, s, e)
  s = s or 0
  e = e or #tbl
  local pos, new = 1, {}

  for i = s, e do
    new[pos] = tbl[i]
    pos = pos + 1
  end

  return new
end

-- prefers tab1 with type mismatches; prefers tab2 with value mismatches
function mergeTable(tab1, tab2)
  local tab = {}
  for k, v1 in pairs(tab1) do
    local v2 = tab2[k]
    if type(v1) ~= type(v2) then
      tab[k] = v1
    else
      if type(v1) == 'table' then
        tab[k] = mergeTable(v1, v2)
      else
        tab[k] = v2
      end
    end
  end
  return tab
end

-- always prefers tab2 unless it is nil
function mergeTableLenient(tab1, tab2)
  local tab = {}
  for k, v in pairs(tab1) do
    tab[k] = v
  end
  for k, v in pairs(tab2) do
    if type(v) == 'table' then
      if tab[k] ~= nil and not getmetatable(v) then
        tab[k] = mergeTableLenient(tab[k], v)
      else
        tab[k] = v
      end
    elseif v ~= nil then
      tab[k] = v
    end
  end
  return tab
end

function countKeys(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

---@param actor Actor | ActorFrame
---@param depth number?
function actorToString(actor, depth)
  depth = depth or 0

  local name = 'Layer'

  local _, _, type = string.find(tostring(actor), '(%a+)%s.*')

  local str = {
    '<', name,
  }

  local values = {
    Type = type,
    Name = actor:GetName(),
    Shader = actor:GetShader() and tostring(actor:GetShader()),
  }

  for k, v in pairs(values) do
    if v ~= '' then
      table.insert(str, ' ')
      table.insert(str, k)
      table.insert(str, '="')
      table.insert(str, v)
      table.insert(str, '"')
    end
  end

  if actor.GetChildren and type ~= 'ActorFrameTexture' then
    table.insert(str, '><children>\n')
    for _, child in ipairs(actor:GetChildren()) do
      table.insert(str, string.rep('  ', (depth + 1)) .. actorToString(child, depth + 1) .. '\n')
    end
    table.insert(str, string.rep('  ', depth) .. '</children></' .. name .. '>')
  else
    table.insert(str, '/>')
  end

  return table.concat(str, '')
end

-- Recursively seraches for an actor with `name`
---@param actor Actor | ActorFrame
---@param name string
function getRecursive(actor, name)
  if actor.GetName and actor:GetName() == name then
    return actor
  end
  if actor.GetChildren then
    for _, child in ipairs(actor:GetChildren()) do
      local res = getRecursive(child, name)
      if res then return res end
    end
  end
end