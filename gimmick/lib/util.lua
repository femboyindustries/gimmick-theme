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

---@param tab any[]
---@param elem any
function includes(tab, elem)
  if not tab then error('bad argument #1 (expected table, got nil)', 2) end
  for _, v in pairs(tab) do
    if elem == v then return true end
  end
  return false
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

function getActorType(actor)
  local _, _, type = string.find(tostring(actor), '(%a+)%s.*')
  return type
end

---@param actor Actor | ActorFrame
---@param depth number?
function actorToString(actor, depth)
  depth = depth or 0

  local name = 'Layer'

  local type = getActorType(actor)

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

function copy(tab)
  return {unpack(tab)}
end

---@param o any
function pretty(o, depth, seen)
  depth = depth or 0
  if depth > 6 then
    return '...'
  end
  seen = seen and copy(seen) or {}

  if type(o) == 'userdata' then
    if seen[o] then return '(circular)' end
    seen[o] = true

    if o.x then -- actor
      local type = getActorType(o)
      local str = type .. '[' .. o:GetName() .. ']'

      if type == 'BitmapText' then
        str = str .. ': ' .. pretty(o:GetText(), depth + 1, seen)
      elseif type == 'ActorFrame' then
        local children = o:GetChildren()
        str = str .. ': ' .. pretty(children, depth + 1, seen)
      end

      return str
    else
      return tostring(o)
    end
  elseif type(o) == 'table' then
    if seen[o] then return '(circular)' end
    seen[o] = true
    local keys = countKeys(o)
    local onlyNumbers = true
    for i = 1, keys do
      if o[i] == nil then
        onlyNumbers = true
        break
      end
    end

    local str = ''
    local linebreaks = false
    local nPos = 0

    if onlyNumbers then
      for i, v in ipairs(o) do
        local s = pretty(v, depth, seen)
        if string.find(s, '\n') or (#str - nPos + #s + depth * 2) > 40 then
          linebreaks = true
          str = str .. '\n'
          str = str .. string.rep('  ', depth)
          nPos = #str
        end
        str = str .. s .. ', '
      end
    else
      for k, v in pairs(o) do
        local ks = (type(k) == 'string' and string.find(k, '^[a-zA-Z0-9]+$')) and k or ('[' .. pretty(k, depth + 1, seen) .. ']')
        local vs = pretty(v, depth, seen)
        local s = ks .. ' = ' .. vs
        local nPos = (string.find(str, '\n') or 0)
        if string.find(s, '\n') or (#str - nPos + #s + depth * 2) > 40 then
          linebreaks = true
          str = str .. '\n'
          str = str .. string.rep('  ', depth)
          nPos = #str
        end

        str = str .. s .. ', '
      end
    end

    str = string.sub(str, 1, #str - 2)

    if linebreaks then
      if string.sub(str, 1, 1) ~= '\n' then
        str = '\n' .. string.rep('  ', depth) .. str
      end
      str = str .. '\n' .. string.rep('  ', depth - 1) .. '}'
    else
      str = str .. ' }'
    end

    return '{ ' .. str
  elseif type(o) == 'string' then
    if string.find(o, '\n') then
      return '[[' .. string.gsub(o, '\\', '\\\\') .. ']]'
    else
      return '"' .. string.gsub(string.gsub(o, '\\', '\\\\'), '"', '\\"') .. '"'
    end
  elseif type(o) == 'nil' then
    return 'nil'
  else
    return tostring(o)
  end
end