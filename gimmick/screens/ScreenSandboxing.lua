local bar = require 'gimmick.bar'

return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    
    local bar1 = bar:new(ctx)

    --local af = bar:new()
    self:SetDrawFunction(function()
      bar:add(0.0001)
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