require 'gimmick.lib.easings'
local easable = require 'gimmick.lib.easable'

---@class Tick
local tick = {
  time = 0,
  locked = false,

  -- one-time events
  ---@type { time: number, func: fun(time: number), funcArgs: any[] }[]
  funcs = { },
  -- recurring, temporary events
  ---@type { time: number, dur: number, func: fun(a: number) }[]
  perframes = { },
  ---@type { time: number, dur: number, func: fun(a: number) }[]
  perframesActive = { },
  -- recurring events with a value and easing function
  ---@type { time: number, dur: number, ease: (fun(a: number): number), from: number, to: number, func: fun(a: number) }[]
  eases = { },
  ---@type { time: number, dur: number, ease: (fun(a: number): number), from: number, to: number, func: fun(a: number) }[]
  easesActive = { },

  -- mirin-like easing events, used with :aux()
  ---@type { time: number, dur: number, ease: (fun(a: number): number), aux: Aux, value: number, add: boolean, transient: boolean }[]
  auxEases = { },
  ---@type { time: number, dur: number, ease: (fun(a: number): number), aux: Aux, value: number, add: boolean, transient: boolean }[]
  auxEasesActive = { },

  ---@type easable[]
  easables = { },
}

local defaultConfig = deepcopy(tick)

tick.__index = tick

--[[
  -- scraps
  local quad = ctx:Quad()
  tick:easeActor(0, 5, outSine, quad, 'x', 500)
  tick:ease(0, 5, outSine, 0, 500, function(x) quad:x(x) end)

  -- this is what i want
  local aux = tick:aux(0) -- 0 as default
  aux:ease(0, 5, outSine, 500)
  -- in a drawfunction
  quad:x(aux.value)
]]

local function insertSorted(tab, value)
  for i, cmp in ipairs(tab) do
    if cmp.time > value.time then
      table.insert(tab, i, value)
      break
    end
  end
  table.insert(tab, value)
end

function tick:update(dt)
  self.time = self.time + dt

  for i = #self.funcs, 1, -1 do
    local f = self.funcs[i]
    if self.time >= f.time then
      f.func(unpack(f.funcArgs))
      table.remove(self.funcs, i)
    else
      break
    end
  end

  for i = #self.perframes, 1, -1 do
    local f = self.perframes[i]
    if self.time >= f.time then
      table.remove(self.perframes, i)
      table.insert(self.perframesActive, f)
    else
      break
    end
  end

  for i = #self.perframesActive, 1, -1 do
    local f = self.perframesActive[i]
    if self.time < (f.time + f.dur) then
      f.func(self.time)
    else 
      table.remove(self.perframesActive, i)
    end
  end
  
  for i = #self.eases, 1, -1 do
    local f = self.eases[i]
    if self.time >= f.time then
      table.remove(self.eases, i)
      table.insert(self.easesActive, f)
    else
      break
    end
  end

  for i = #self.easesActive, 1, -1 do
    local f = self.easesActive[i]
    if self.time < (f.time + f.dur) then
      local a = (self.time - f.time) / f.dur
      local b = f.ease(a)
      f.func(f.from * (1 - b) + f.to * b)
    else
      if f.ease(1) >= 0.5 then
        f.func(f.to)
      else
        f.func(f.from)
      end
      table.remove(self.easesActive, i)
    end
  end

  ---@type table<Aux, number>
  local auxOffsets = { }
  
  for i = #self.auxEases, 1, -1 do
    local e = self.auxEases[i]
    if self.time >= e.time then
      table.remove(self.auxEases, i)
      table.insert(self.auxEasesActive, e)

      if not e.transient then
        local old = e.aux.target
        auxOffsets[e.aux] = 0
        if e.add then
          e.aux.target = old + e.value
          --e.value = e.value
        else
          e.aux.target = e.value
          e.value = e.value - old
        end
      end
    else
      break
    end
  end

  for i = #self.auxEasesActive, 1, -1 do
    local e = self.auxEasesActive[i]
    if self.time < (e.time + e.dur) then
      local a = (self.time - e.time) / e.dur
      local b = e.ease(a)
      if e.transient then
        auxOffsets[e.aux] = (auxOffsets[e.aux] or 0) + e.value * b
      else
        auxOffsets[e.aux] = (auxOffsets[e.aux] or 0) - e.value * (1 - b)
      end
    else
      table.remove(self.auxEasesActive, i)
      auxOffsets[e.aux] = auxOffsets[e.aux] or 0
    end
  end
  
  for aux, offset in pairs(auxOffsets) do
    aux.value = aux.target + offset
  end

  for _, e in ipairs(self.easables) do
    e:update(dt)
  end
end

---@param delay number
---@param func fun(time: number)
function tick:func(delay, func, ...)
  if self.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  insertSorted(self.funcs, {
    time = self.time + delay,
    func = func,
    funcArgs = arg,
  })
end

---@param delay number
---@param dur number
---@param func fun(time: number)
function tick:perframe(delay, dur, func)
  if self.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  insertSorted(self.perframes, {
    time = self.time + delay,
    dur = dur,
    func = func,
  })
end

---@param delay number
---@param dur number
---@param ease fun(a: number): number
---@param from number
---@param to number
---@param func fun(time: number)
function tick:ease(delay, dur, ease, from, to, func)
  if self.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  insertSorted(self.eases, {
    time = self.time + delay,
    dur = dur,
    ease = ease,
    from = from,
    to = to,
    func = func,
  })
end
 
---@return Tick
function tick.new()
  return setmetatable(deepcopy(defaultConfig), tick)
end

---@class Aux
---@field value number
---@field tick Tick
---@field target number
local Aux = {}
Aux.__index = Aux

---@param delay number
---@param duration number
---@param ease fun(a: number): number
---@param value number
function Aux:ease(delay, duration, ease, value)
  if self.tick.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  insertSorted(self.tick.auxEases, {
    time = self.tick.time + delay,
    dur = duration,
    ease = ease,
    aux = self,
    value = value,
    add = false,
    transient = ease(1) < 0.5,
  })
end

---@param delay number
---@param duration number
---@param ease fun(a: number): number
---@param value number
function Aux:add(delay, duration, ease, value)
  if self.tick.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  insertSorted(self.tick.auxEases, {
    time = self.tick.time + delay,
    dur = duration,
    ease = ease,
    aux = self,
    value = value,
    add = true,
    transient = ease(1) < 0.5,
  })
end

---@param default? number
function tick:aux(default)
  if self.locked then error('this tick instance is locked, no new functions can be scheduled', 2) end
  return setmetatable({
    value = default or 0,
    target = default or 0,
    tick = self,
  }, Aux)
end

---@param default? number
---@param speed? number
---@return easable
function tick:easable(default, speed)
  local e = easable(default, speed)
  table.insert(self.easables, e)
  return e
end

---@param callback fun() @ Callback to call upon finishing
function tick:lock(callback)
  local maxTime = 0

  for _, f in ipairs(self.funcs)           do maxTime = math.max(maxTime, f.time) end
  for _, f in ipairs(self.perframes)       do maxTime = math.max(maxTime, f.time + f.dur) end
  for _, f in ipairs(self.perframesActive) do maxTime = math.max(maxTime, f.time + f.dur) end
  for _, f in ipairs(self.eases)           do maxTime = math.max(maxTime, f.time + f.dur) end
  for _, f in ipairs(self.easesActive)     do maxTime = math.max(maxTime, f.time + f.dur) end
  for _, f in ipairs(self.auxEases)        do maxTime = math.max(maxTime, f.time + f.dur) end
  for _, f in ipairs(self.auxEasesActive)  do maxTime = math.max(maxTime, f.time + f.dur) end

  self:func(maxTime, callback)

  self.locked = true
end

return tick