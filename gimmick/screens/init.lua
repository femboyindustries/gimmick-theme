require 'gimmick.screens.common.init'

local Scope = require 'gimmick.scope'

---@param choices { name: string, command: string }[]
---@param setupChoice? fun(self: ActorFrame, ctx: Context, i: number, name: string): nil
gimmick.ChoiceProvider = function(choices, setupChoice)
  setupChoice = setupChoice or function(self, ctx, i, name)
    local text = ctx:BitmapText(FONTS.sans_serif, name)
    text:zoom(0.8)
    text:horizalign('center')
    text:shadowlength(1)
    text:diffusealpha(0)
    text:sleep(0.1 * n)
    text:accelerate(0.4)
    text:diffusealpha(1)

    text:addcommand('GainFocus', function()
      text:tween(1/3, outElastic)
      text:diffuse(1, 0, 1, 1)
      text:zoom(1)
    end)
    text:addcommand('LoseFocus', function()
      text:diffuse(1, 1, 1, 1)
      text:zoom(0.8)
    end)
    text:addcommand('Disabled', function()
      text:diffuse(0.5, 0.5, 0.5, 1)
    end)
    text:addcommand('Off', function()
      text:sleep(.2) text:linear(.5) text:diffusealpha(0)
    end)
  end

  local init = iterFunction(function(n, self)
    self:removecommand('Init')

    local ctx = actorgen.Context.new()

    setupChoice(self, ctx, n, choices[n].name)

    actorgen.ready(ctx)
  end)
  local command = iterFunction(function(n)
    return choices[n].command
  end)

  return {
    init = init,
    initEnd = function(self)
      self:removecommand('Init')
      actorgen.finalize()
    end,
    ChoiceNames = function()
      init:reset()
      command:reset()
      return string.sub(string.rep(',1', #choices), 2)
    end,
    Choice1 = command,
  }
end

---@param initFunc fun(self: ActorFrame, ctx: Context, scope: Scope): nil
function gimmick.ActorScreen(initFunc)

  local dbg = debug.getinfo(2, 'Sl')
  if dbg.short_src == '(tail call)' then dbg = debug.getinfo(3, 'Sl') end
  local src = dbg.source .. ':' .. dbg.currentline
  src = string.gsub(src, '^@%./themes/gimmick/', '') -- to make it clickable in vscode
  src = string.gsub(src, '^gimmick/', '') -- for conciseness

  return {
    ---@param self ActorFrame
    init = function(self)
      self:removecommand('Init')

      local ctx = actorgen.Context.new()
      local scope = Scope.new(src)

      local lastT
      self:addcommand('Update', function()
        if not lastT then lastT = os.clock() end
        local t = os.clock()
        local dt = t - lastT
        lastT = t
        scope:update(dt)
      end)

      self:luaeffect('Update')

      self:addcommand('On', function()
        scope:onCommand()
      end)
      self:addcommand('Off', function()
        scope:offCommand()
      end)

      scope.event:on('press', function(pn, btn)
        if btn == 'Back' then
          print(scope.name)
          print('Back key pressed, simulating OffCommand')
          self:queuecommand('Off')
        end
      end)

      initFunc(self, ctx, scope)

      actorgen.ready(ctx)
    end,
    ---@param self ActorFrame
    initEnd = function(self)
      self:removecommand('Init')
      actorgen.finalize()
    end
  }
end

gimmick.NopScreen = {
  init = function() actorgen.ready(actorgen.Context.new()) end,
  initEnd = function() actorgen.finalize() end,
}

gimmick.Screen = function()
  return {
    Init = function() end,
    header = gimmick.NopScreen,
    footer = gimmick.NopScreen,
    underlay = gimmick.NopScreen,
    overlay = gimmick.NopScreen,
    background = gimmick.NopScreen,
    ['in'] = gimmick.NopScreen,
    out = gimmick.NopScreen,
    cancel = gimmick.NopScreen,
    choices = gimmick.ChoiceProvider({{
      name = '???',
      command = '',
    }})
  }
end

gimmick.s = setmetatable({}, {
  __index = function(t, k)
    local ok, res = pcall(require, 'gimmick.screens.' .. k)
    if not ok then
      print(res)
      print('screen ' .. k .. ' not defined or errored, falling back to defaults')
      t[k] = gimmick.Screen()
    else
      t[k] = mergeTableLenient(gimmick.Screen(), res)
    end

    return t[k]
  end
})