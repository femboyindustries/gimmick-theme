require 'gimmick.screens.common.init'

gimmick.ChoiceProvider = function(choices)
  local init = iterFunction(function(n, self)
    self:removecommand('Init')

    local ctx = gimmick.actorgen.Context.new()

    local text = choices[n].name

    local text = ctx:BitmapText('common', text)
    text:zoom(0.8)
    text:horizalign('center')
    text:shadowlength(0)
    text:diffusealpha(0)
    text:sleep(0.1 * n)
    text:accelerate(0.4)
    text:diffusealpha(1)

    text:addcommand('GainFocus', function()
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

    gimmick.actorgen.ready(ctx)
  end)
  local command = iterFunction(function(n)
    return choices[n].command
  end)

  return {
    init = init,
    initEnd = function(self)
      self:removecommand('Init')
      gimmick.actorgen.finalize()
    end,
    ChoiceNames = function()
      init:reset()
      command:reset()
      return string.sub(string.rep(',1', #choices), 2)
    end,
    Choice1 = command,
  }
end

---@param initFunc fun(self: ActorFrame, ctx: Context): nil
function gimmick.ActorScreen(initFunc)
  return {
    init = function(self)
      self:removecommand('Init')

      local ctx = gimmick.actorgen.Context.new()

      initFunc(self, ctx)

      gimmick.actorgen.ready(ctx)
    end,
    initEnd = function(self)
      self:removecommand('Init')
      gimmick.actorgen.finalize()
    end
  }
end

gimmick.NopScreen = {
  init = function() end,
  initEnd = function() end,
}

gimmick.Screen = function()
  return {
    Init = function() end,
    header = gimmick.NopScreen,
    footer = gimmick.NopScreen,
    underlay = gimmick.NopScreen,
    overlay = gimmick.NopScreen,
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