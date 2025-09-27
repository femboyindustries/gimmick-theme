--
-- actor235 - a portable version of uranium's actor generation
--
local M = {}

-- "configurable" constants

local NODES_PER_AF = 10
local ACTORS_FILENAME = 'actors.xml'
local PATH_PREFIX_SHADER = ''
local PATH_PREFIX_FILE = ''
local ENABLE_LOGGING = false

local function warn(str)
  Debug('[actor235] WARN: ' .. tostring(str))
  event:call('warn', 'actor235: ' .. str)
end

local function print(...)
  if not ENABLE_LOGGING then return end

  local msg = {}
  for _, val in ipairs(arg) do
    table.insert(msg, tostring(val))
  end
  Debug('[actor235] ' .. table.concat(msg, '\t'))
end

--[[
  ====================================
  =            PROXYING              =
  ====================================
]]

-- A proxy stand-in for an actor, used until the real actor is available.
-- 
-- Calls to this actor will be "queued", being held in memory until the proxy is
-- resolved, after which they'll all be ran in order.
-- Calls to `addcommand` with `Init` are overridden and also called after the
-- proxy is resolved.
--
-- Values from queued function calls are not returned. Other than that caveat, a
-- proxy of an actor will behave the same as regular calls to the actor, albeit
-- delayed.
local Proxy = {}

-- These functions override the actual Actor methods.
local actorMethodOverrides = {}

-- Calls a method on a resolved proxy
function Proxy.call(proxy, key, _, ...)
  if not Proxy.resolved(proxy) then
    error('actor235: attempting to call method on unresolved proxy', 2)
  end
  local actor = proxy.__proxy.raw
  -- normally you'd be concerned with return values here, but there's not really
  -- anything to return here _to_
  local res, err = pcall(actor[key], actor, unpack(arg))
  if not res then
    error('error calling ' .. key .. ': ' .. err, 2)
  end
end

local methodCache = setmetatable({}, {__mode = 'v'})

-- Wraps a method, letting it be called as if it was on the real actor.
--
-- When a method on an object in Lua is called with :, then the object is passed
-- in as the first argument. This is inconvenient for proxies, since that object
-- will be the proxy instead of the actor, potentially causing an AV.
--
-- This function will wrap the call, resolving the proxy first, and then
-- proceeding with the call as usual.
function Proxy.wrapCall(func)
  if methodCache[func] then return methodCache[func] end

  -- defining ahead-of-time to avoid creating an anonymous function each time

  local protected = function(args)
    -- wrapping it in a table because in a pcall lua will only pass along the
    -- first returned value
    return {func(unpack(args))}
  end

  local wrapped = function(...)
    arg[1] = Proxy.getRaw(arg[1])
    local ok, res = pcall(protected, arg)
    if not ok then error(res, 2) end
    return unpack(res)
  end

  methodCache[func] = wrapped

  return wrapped
end

-- Resolves a proxy, realizing its actor and making it run through the backlog
-- of called methods
function Proxy.resolve(proxy, actor)
  if Proxy.resolved(proxy) then
    error('actor235: proxy has already been resolved', 2)
  end
  proxy.__proxy.raw = actor

  -- work through the queue

  for _, v in ipairs(proxy.__proxy.methodQueue) do
    local func = actor[v.key]
    if not func then
      error(
        'actor235: error while initializing \'' .. proxy.__proxy.name .. '\' on ' .. v.debug.short_src .. ':' .. v.debug.currentline .. ':\n' ..
        'you\'re calling a function \'' .. v.key .. '\' on a ' .. proxy.__proxy.name .. ' which doesn\'t exist!:\n'
      )
    else
      local success, result = pcall(function()
        Proxy.call(proxy, v.key, unpack(v.arg))
      end)
      if not success then
        error(
          'actor235: error while initializing \'' .. proxy.__proxy.name .. '\' on ' .. v.debug.short_src .. ':' .. v.debug.currentline .. ':\n' ..
          result
        )
      end
    end
  end

  proxy.__proxy.methodQueue = {}

  -- run the initcommands

  for _, c in ipairs(proxy.__proxy.initCommands) do
    local func = c[1]
    local success, result = pcall(function()
      func(actor)
    end)
    if not success then
      error(
        'actor235: error on \'' .. proxy.__proxy.name .. '\' InitCommand defined on ' .. c.debug.short_src .. ':' .. c.debug.currentline .. ':\n' ..
        result
      )
    end
  end

  proxy.__proxy.initCommands = {}
end

function Proxy.resolved(proxy)
  return proxy.__proxy.raw ~= nil
end

function Proxy.getRaw(proxy)
  return proxy.__proxy.raw
end

function Proxy.isProxy(proxy)
  return rawget(proxy, '__proxy') ~= nil
end

function Proxy.setData(proxy, key, value)
  assert(Proxy.isProxy(proxy), 'actor235: passed in value is not a Proxy')
  proxy.__proxy.data[key] = value
  return value
end

function Proxy.getData(proxy, key, value)
  assert(Proxy.isProxy(proxy), 'actor235: passed in value is not a Proxy')
  return proxy.__proxy.data[key]
end

-- Once you have the actual actor, call `Proxy.resolve`.
---@param name string
function Proxy.new(name)
  return setmetatable({
    __proxy = {
      name = name,
      raw = nil,
      initCommands = {},
      methodQueue = {},
      methodCache = {},
      -- custom user data
      data = {},
    },
  }, {
    __name = name,
    __tostring = function(self)
      return 'Proxy of ' .. (self.__proxy.raw and tostring(self.__proxy.raw) or (self.__proxy.name .. ' (unresolved)'))
    end,

    __newindex = function()
      error('actor235: cannot set properties on actors!', 2)
    end,
    __index = function(self, key)
      -- return if resolved
      if Proxy.resolved(self) then
        local actor = self.__proxy.raw

        if actorMethodOverrides[key] then
          return actorMethodOverrides[key]
        end

        local val = actor[key]
        if type(val) == 'function' then
          print(actor,debug.traceback())
          return Proxy.wrapCall(val)
        end
        return val
      end

      -- otherwise, queue it up
      return function(...)
        if key == 'addcommand' and arg[2] == 'Init' then
          table.insert(self.__proxy.initCommands, {
            arg[3],
            debug = debug.getinfo(2, 'Sl'),
          })
        else
          table.insert(self.__proxy.methodQueue, {
            key = key,
            arg = arg,
            debug = debug.getinfo(2, 'Sl'),
          })
        end
      end
    end,
  })
end

M.Proxy = Proxy

--[[
  ====================================
  =         INITIALIZATION           =
  ====================================
]]
-- Low-level actor initialization / loading

local log = NODES_PER_AF == 10
            and math.log10
            or  function(n)
              return math.log(n)/math.log(NODES_PER_AF)
            end

---@class AbstractActor
---@field Type string?
---@field File string?
---@field Font string?
---@field Init? fun(self: Actor): nil
---@field Frag string
---@field Vert string
---@class AbstractActorFrame
---@field Type 'ActorFrame'
---@field Children (AbstractActor | AbstractActorFrame)[]
---@field Init? fun(self: Actor): nil

---@class NodeStack
---@field actors (AbstractActor | AbstractActorFrame)[] @ Actors that should be defined in this stack
---@field depth number @ The depth at which actor placement should begin
---@field cd number @ The current actors.xml depth, incremented on recursing into actors.xml and decremented after the last Condition call
---@field actorIdx number @ The current actor's index, referring to `actors` (1-indexed)

local stack = {}

---@param entry NodeStack
function stack:push(entry)
  table.insert(self, entry)
end

---@return NodeStack
function stack:pop()
  local t = self[#self]
  table.remove(self, #self)
  return t
end

---@return NodeStack
function stack:top()
  return self[#self]
end

function stack:clear()
  for i = #self, 1, -1 do
    table.remove(self, i)
  end
end

function stack:log(str)
  print(string.rep('  ', #self) .. tostring(str))
end

local function getMinDepth(t)
  local depth = math.ceil(log(#t))
  return math.max(depth, 1)
end

---@param actors (AbstractActor | AbstractActorFrame)[]
local function pushNewLayer(actors)
  stack:push({
    actorIdx = 0, -- start with 0 so Condition can increment it once
    actors = actors,
    depth = getMinDepth(actors),
    cd = 1,
  })

  --print('--- new layer ---   z: ' .. #stack)
end

local actorInit = {}

paw.actor = actorInit

---@type AbstractActor
local currentActor = nil

---@return AbstractActor
local function getNextActor()
  local s = stack:top()

  if s.cd < s.depth then
    -- recurse
    s.cd = s.cd + 1
    stack:log('s.cd++ (=' .. s.cd .. ')')
    return {
      Type = nil,
      File = ACTORS_FILENAME,
    }
  end

  s.actorIdx = s.actorIdx + 1

  local actor = s.actors[s.actorIdx]

  if actor.Type == 'ActorFrame' then
    -- recurse, push new layer
    pushNewLayer(actor.Children)
    return {
      Type = nil,
      File = ACTORS_FILENAME,
    }
  end

  return actor
end

function actorInit.Condition(hasShader)
  local s = stack:top()

  if not s then
    warn('ready() was not called, and yet actors.xml has been loaded? if it has, the stack is glogged')
    return false
  end

  if s.actorIdx >= #s.actors then
    -- we've placed every actor down, return early
    stack:log('cond: (done, returning early)')
    return false
  end

  if hasShader == false then
    -- first of the element pair, so we grab the current actor here
    currentActor = getNextActor()
  end

  local needsShader = not not (currentActor.Frag or currentActor.Vert)
  if hasShader ~= needsShader then
    -- only create an actor with frag/vert set if the actor truly needs it
    return
  end

  -- proceed with creation

  --print('cond: creating actor idx ' .. s.actorIdx)

  stack:log('<>')

  return true
end

function actorInit.Type()
  stack:log(' Type ' .. tostring(currentActor.Type))
  return currentActor.Type
end

function actorInit.File()
  stack:log(' File ' .. tostring(currentActor.File))
  return currentActor.File
end

function actorInit.Font()
  stack:log(' Font ' .. tostring(currentActor.Font))
  return currentActor.Font
end

function actorInit.Frag()
  stack:log(' Frag ' .. tostring(currentActor.Frag))
  return currentActor.Frag or 'nop.frag'
end

function actorInit.Vert()
  stack:log(' Vert ' .. tostring(currentActor.Vert))
  return currentActor.Vert or 'nop.vert'
end

---@param idx number @ a number from 1 to NODES_PER_AF, inclusive
function actorInit.Init(idx)
  ---@param self Actor
  return function(self)
    stack:log('</> -> ' .. tostring(self))

    local s = stack:top()

    if s.cd == s.depth then
      -- we're at the desired depth to define actors
      local actor = currentActor
      if actor.Init then actor.Init(self) end
    end

    if s.cd < 1 then
      -- we've just exited a layer!
      --print('--- layer ' .. #stack .. ' done ---')
      stack:pop()
      s = stack:top()

      local actor = s.actors[s.actorIdx]
      if actor.Init then actor.Init(self) end
    end

    if idx >= NODES_PER_AF or s.actorIdx == #s.actors then
      -- We've reached the end of the current actors.xml, decrement depth
      s.cd = s.cd - 1
      stack:log('s.cd-- (=' .. s.cd .. ')')
    end
  end
end

--[[
  ====================================
  =               DEF                =
  ====================================
]]
-- Defining actors, actor queue

---@class Context
---@field actorQueue ({ proxy: unknown, toXML: fun(): AbstractActor | AbstractActorFrame, subContext: Context? })[]
---@field locked boolean @ If locked, prevents new actors from being defined
local Context = {}

Context.__index = Context

function Context:assertUnlocked()
  if self.locked then
    error('actor235: attempting to modify actor queue while it is locked. did you call \'lock\' too early?', 3)
  end
end
function Context:lock()
  self.locked = true
end
function Context:reset()
  self.actorQueue = {}
  self.locked = false
end

-- Defines a Sprite actor.
---@param file string?
---@return Sprite
function Context:Sprite(file)
  self:assertUnlocked()
  local proxy = Proxy.new('Sprite')
  table.insert(self.actorQueue, {
    proxy = proxy,
    toXML = function()
      return {
        Type = (not file) and 'Sprite' or nil,
        File = file and (PATH_PREFIX_FILE .. file) or nil,
        Init = function(actor)
          Proxy.resolve(proxy, actor)
        end
      }
    end
  })
  return proxy
end

-- Defines a BitmapText actor.
---@param font string? @ Defaults to 'common'
---@param text string? @ String to initialize with
---@return BitmapText
function Context:BitmapText(font, text)
  self:assertUnlocked()
  local proxy = Proxy.new('BitmapText')
  table.insert(self.actorQueue, {
    proxy = proxy,
    toXML = function()
      return {
        Type = 'BitmapText',
        Font = font or 'common',
        Init = function(actor)
          if text then actor:settext(text) end
          Proxy.resolve(proxy, actor)
        end
      }
    end
  })
  return proxy
end

local function actor0Arg(type)
  return function(self)
    self:assertUnlocked()
    local proxy = Proxy.new(type)
    table.insert(self.actorQueue, {
      proxy = proxy,
      toXML = function()
        return {
          Type = type,
          Init = function(actor)
            Proxy.resolve(proxy, actor)
          end
        }
      end
    })
    return proxy
  end
end
local function actorFileArg(type, useType)
  return function(self, file)
    self:assertUnlocked()
    if not file then
      error('actor235: cannot create ' .. type .. ' a file', 2)
    end
    local proxy = Proxy.new(type)
    table.insert(self.actorQueue, {
      proxy = proxy,
      toXML = function()
        return {
          Type = useType and type or nil,
          File = PATH_PREFIX_FILE .. file,
          Init = function(actor)
            Proxy.resolve(proxy, actor)
          end
        }
      end
    })
    return proxy
  end
end

-- Defines a Quad actor.
---@type fun(ctx: Context): Quad
Context.Quad = actor0Arg('Quad')
-- Defines an ActorProxy actor.
---@type fun(ctx: Context): ActorProxy
Context.ActorProxy = actor0Arg('ActorProxy')
-- Defines a Polygon actor.
---@type fun(ctx: Context): Polygon
Context.Polygon = actor0Arg('Polygon')
-- Defines an ActorFrameTexture actor.
---@type fun(ctx: Context): ActorFrameTexture
Context.ActorFrameTexture = actor0Arg('ActorFrameTexture')
-- Defines a Model actor.
---@type fun(ctx: Context, file: string): Model
Context.Model = actorFileArg('Model', false)
-- Defines an ActorSound actor.
---@type fun(ctx: Context, file: string): ActorSound
Context.ActorSound = actorFileArg('ActorSound', true)

local function isShaderCode(str)
  return string.find(str or '', '\n')
end

-- Defines a shader. `frag` and `vert` can either be filenames or shader code.
---@param frag string | nil
---@param vert string | nil
---@return RageShaderProgram
function Context:Shader(frag, vert)
  self:assertUnlocked()
  local proxy = Proxy.new('RageShaderProgram')

  local fragFile = frag
  local vertFile = vert

  local isFragShaderCode = isShaderCode(frag)
  local isVertShaderCode = isShaderCode(vert)

  if isFragShaderCode then fragFile = nil end
  if isVertShaderCode then vertFile = nil end

  if (frag and vert) and ((isFragShaderCode and not isVertShaderCode) or (not isFragShaderCode and isVertShaderCode)) then
    error('actor235: cannot create a shader with 1 shader file and 1 shader code block', 2)
  end

  table.insert(self.actorQueue, {
    proxy = proxy,
    toXML = function()
      return {
        Type = 'Sprite',
        Frag = fragFile and (PATH_PREFIX_SHADER .. fragFile) or 'nop.frag',
        Vert = vertFile and (PATH_PREFIX_SHADER .. vertFile) or 'nop.vert',
        ---@param actor Sprite
        Init = function(actor)
          actor:hidden(1)
          local shader = actor:GetShader() --[[@as RageShaderProgram]]
          Proxy.resolve(proxy, shader)

          if isFragShaderCode or isVertShaderCode then
            shader:compile(vert or '', frag or '')
          end
        end
      }
    end
  })
  return proxy
end

-- Defines a texture.
---@param file string
---@return RageTexture
function Context:Texture(file)
  self:assertUnlocked()
  if not file then error('actor235: cannot create Texture without a file', 2) end

  local proxy = Proxy.new('RageTexture')

  table.insert(self.actorQueue, {
    proxy = proxy,
    toXML = function()
      return {
        File = file,
        Init = function(actor)
          actor:hidden(1)
          Proxy.resolve(proxy, actor:GetTexture())
        end,
      }
    end,
  })

  return proxy
end

-- Defines an ActorFrame.
---@return ActorFrame
function Context:ActorFrame()
  self:assertUnlocked()

  local proxy = Proxy.new('ActorFrame')
  local subContext = Context.new()
  Proxy.setData(proxy, 'subContext', subContext)

  table.insert(self.actorQueue, {
    proxy = proxy,
    toXML = function()
      return {
        Type = 'ActorFrame',
        Init = function(actor)
          Proxy.resolve(proxy, actor)
        end,
        Children = subContext:toTree(),
      }
    end,
  })

  return proxy
end

-- Creates a Context instance out of an ActorFrame.
-- All actors created under the new Context will be automatically parented
-- to the ActorFrame.
---@param frame ActorFrame
---@return Context
function Context.getContext(frame)
  return Proxy.getData(frame, 'subContext')
end

-- [deprecated, use Context.getContext preferably]
--
-- Adds a child to an ActorFrame. **Please be aware of the side-effects!**
---@param frame ActorFrame
---@param child Actor
function Context:addChild(frame, child)
  if not frame or not child then
    error('actor235: frame and actor must both Exist', 2)
  end
  if self.locked then
    error('actor235: cannot create frame-child associations after actors have been locked', 2)
  end
  if not Proxy.isProxy(frame) then
    error('actor235: ActorFrame passed into addChild must be one instantiated with ActorFrame()!', 2)
  end
  if not Proxy.isProxy(child) then
    error('actor235: actor passed into addChild must be one instantiated w/ actor235', 2)
  end

  -- hacky but it achieves what we need
  local subContext = self.getContext(frame)
  local movedActor
  for i = #self.actorQueue, 1, -1 do
    local actor = self.actorQueue[i]
    if actor.proxy == child then
      movedActor = actor
      table.remove(self.actorQueue, i)
      break
    end
  end
  assert(movedActor, 'actor235: referenced child is not under given Context instance')
  table.insert(subContext.actorQueue, movedActor)
end

---@return (AbstractActor | AbstractActorFrame)[]
function Context:toTree()
  local root = {}

  for _, q in ipairs(self.actorQueue) do
    table.insert(root, q.toXML())
  end

  return root
end

---@return Context
function Context.new()
  return setmetatable({
    actorQueue = {},
    locked = false,
  }, Context)
end

M.Context = Context

--[[
  ====================================
  =              MISC                =
  ====================================
]]
-- APIs, conveniences, etc

local function prettyPrintTree(tree, depth)
  depth = depth or 0
  for _, actor in ipairs(tree) do
    if actor.Type == 'ActorFrame' then
      print(string.rep('  ', depth) .. '<ActorFrame><children>')
      prettyPrintTree(actor.Children, depth + 1)
      print(string.rep('  ', depth) .. '</children></ActorFrame>')
    else
      local str = '<Layer'
      for k, v in pairs(actor) do
        str = str .. ' ' .. k .. '="' .. tostring(v) .. '"'
      end
      str = str .. '/>'

      print(string.rep('  ', depth) .. str)
    end
  end
end

-- Call this after you are done defining your actors.
---@param ctx Context
function M.ready(ctx)
  ctx:lock()
  stack:clear()
  local tree = ctx:toTree()
  prettyPrintTree(tree)
  pushNewLayer(tree)
  forcedEvaluation = false
end

-- For repeat initializations to persist state across Lua state resets.
-- Will function without `Condition` and pretend those are set correctly.
---@param frame ActorFrame
function M.forceEvaluate(frame)
  print('BEGIN FORCED EVALUATION')
  for i, child in ipairs(frame:GetChildren()) do
    local cond = actorInit.Condition((i - 1) % 2 ~= 0)
    if getActorType(child) == 'ActorFrame' then
      M.forceEvaluate(child)
    end
    if cond then
      actorInit.Init(math.ceil(i / 2))(child)
    end
  end
end

-- Call this once all of the actors have been initialized
function M.finalize()
  stack:clear()
end


return M