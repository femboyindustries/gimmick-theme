barlib = require 'gimmick.bar'
local easeable = require 'gimmick.lib.easable'
return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    local a = true
    local bar = barlib.new(ctx)
    local bar_af = bar.actorframe
    local ease = easeable(0,0.5)    
    ease:reset(0)
    bar:set(0.1)
    local oldt = os.clock()
    local timer = 2
    setDrawFunctionWithDT(self, function(dt)
      bar_af:Draw()
      ease:update(dt)
      bar:set(ease.eased)
      if a and timer < 0.1 then
        ease:add(0.001)
        --a = false
      end

      timer = timer - dt
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}