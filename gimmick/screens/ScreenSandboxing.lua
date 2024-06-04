local bar = require 'gimmick.bar'

return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    
    local bar1 = bar:new(ctx)

    --local af = bar:new()
    bar:set(4)
    bar1:sleep(2)
    bar:sub(0.2)
    self:SetDrawFunction(function()
      bar1:Draw()
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}